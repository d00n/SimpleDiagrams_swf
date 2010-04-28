
/*
* Based on cade by Soph-Ware Associates, Inc.
*
* Copyright (C) 2007-2008 Soph-Ware Associates, Inc. 
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


package com.simplediagrams.model
{
	import com.simplediagrams.commands.IUndoRedoCommand;
	import com.simplediagrams.util.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class UndoRedoManager extends EventDispatcher
	{
		
		public static const MAX_UNDOS:Number = 100
		
		private var _stack:ArrayCollection = new ArrayCollection()
		
		//indicates if there are commands after stackIndex
		private var _cleanIndex:Number = -1;
		
		// should only be used by associated getter/setter 
		private var __stackIndex:Number = -1;

		
		public function UndoRedoManager()
		{
		}
		
		/**
		 * Returns true if an undoable event is present on the stack
		 */

		[Bindable("indexChanged")]
		public function get canUndo():Boolean
		{
			return stackIndex >=0
		}
		
		/**
		 * True if a redo operation can be performed
		 */
		[Bindable("indexChanged")]
		public function get canRedo():Boolean
		{
			// note, if all undo events have been undone, then stackIndex
			// will be -1 but stack.length will be greater than zero.  
			return stackIndex + 1 < _stack.length
		}
		
		public function clear():void
		{
			_stack = new ArrayCollection()
			stackIndex = -1
			setCleanIndex(-1)
			dispatchEvent(new Event("countChanged"))
		}
		
		[Bindable("countChanged")]
		public function get count():Number
		{
			return _stack.length
		}
		
		/**
		 * Returns the index of the current command.
		 *
		 * <p>
		 * The current command is the command that will be executed on the
		 * next call to redo().  If no commands are on the stack, then -1 will
		 * be returned.  The current command is not always the top-most
		 * command on the stack as other commands may have been undone.
		 * </p>
		 *
		 * <p>
		 * The index is a zero based index that should be between zero and
		 * count - 1, inclusive.  An index of -1 implies that no entries are
		 * available on the undo stack.
		 * </p>
		 */
		[Bindable("indexChanged")]
		public function get index():uint
		{
			return stackIndex
		}
		
		/**
		 * Pushes <code>cmd</code> onto the UndoStack and executes the command.
		 *  
		 * <p>
		 * All commands after the command at index() will be deleted.
		 * </p>
		 * 
		 * @param cmd The command being pushed onto the stack
		 */
		public function push(cmd:IUndoRedoCommand):void
		{
			//If there are redo's on the stack after the current index, wipe them out
			if (canRedo)
			{
				if (_cleanIndex>stackIndex)
				{
					setCleanIndex(-1)
				}
				removeCommands(stackIndex++, _stack.length)
			}
			
			//If there are more than a set amount, remove first and then change index
			if (_stack.length>MAX_UNDOS)
			{
				_stack.removeItemAt(0)
				stackIndex = _stack.length - 1
			}
			
			//don't execute command since it will already have been executed in the normal course of the program
			addUndoRedoCommand(cmd)
			
		}
		
		public function undo():void
		{
			Logger.debug("undo()", this)
			if (!canUndo) 
			{ 
				Logger.debug("can't undo.",this); 
				return;
			}
			if (stackIndex>_stack.length-1) stackIndex=_stack.length-1
			_stack[stackIndex].undo()
			stackIndex--
			Logger.debug("after undo, stack: ", this)
			traceStack()
		}
		
		public function redo():void
		{
			Logger.debug("redo()", this)
			if (!canRedo) 
			{ 
				Logger.debug("can't redo.",this)
				return
			}
			_stack[++stackIndex].redo()
			Logger.debug("after redo, stack: ", this)
			traceStack()
		}
		
		public function set index(ix:uint):void
		{
			if (!isValidIndex(ix)) return
				
			if (ix<stackIndex)
			{
				do
				{
					undo()
				}
				while (ix<stackIndex && stackIndex>0)
				
			}
			else if (ix>stackIndex)
			{
				var i:uint = count
				do
				{
					redo()
				}
				while (ix>stackIndex)
			}
		}
		
		/**
		 * Returns true if the stack is in a clean state.
		 * 
		 * <p>
		 * The stack is considered clean if the current index is the index at
		 * which clean = true was last called.  The stack is clean by default.
		 * </p>
		 */

		
		[Bindable("cleanChanged")]
		public function get clean():Boolean
		{
			return cleanIndex==index
		}
		
		
		/**
		* Sets the clean index to the current index if set to a true value.
		*
		* <p>
		* The clean index will be reset if the clean index is higher than the
		* current index and an event is pushed onto the stack.  (In other
		* words, if there are events to be redone and an event is pushed onto
		* the stack.)  The cleanIndex is set to -1 in the event of a reset.
		* </p>
		*/
		public function set clean(b:Boolean):void
		{
			if (!b)
				return;
			
			setCleanIndex(index);
		}
		
		/**
		 * Returns the index at which setClean was last called, or -1
		 * if it has not been called or has been reset.
		 */
		[Bindable("cleanChanged")]
		public function get cleanIndex():Number
		{
			return _cleanIndex;
		}
		
		
		
		/**
		 * Returns true if the index is valid
		 *
		 * @param ix a non-negative index number
		 */
		protected function isValidIndex(ix:Number):Boolean
		{
			if (ix >=0 && ix < count)
				return true;
			return false;
		}
		
		/**
		 * Adds an undo command to the top of the stack and dispatches an
		 * appropriate event.
		 *
		 * @param cmd The undo command to add to the stack
		 */
		protected function addUndoRedoCommand(cmd:IUndoRedoCommand):void
		{
			Logger.debug("adding command. cmd: " + cmd.toString(),this)
			_stack.addItem(cmd);
			stackIndex++;
			dispatchEvent( new Event("countChanged") );
			traceStack()
		}
		
		/**
		 * Removes the top undo command from the stack
		 */
		protected function removeUndoCommand():void
		{
			_stack.removeItemAt(_stack.length - 1);
			stackIndex--;
			dispatchEvent( new Event("countChanged") );
		}
		
		/**
		 * Removes the items between the first index (inclusive) and the last
		 * index (exclusive).
		 *
		 * <p>
		 * It is assumed that stackIndex is already set to something
		 * lower than the entries being removed, thus it is safe to perform
		 * this operation.  It will normally be used after a series of undo
		 * events have been performed and then a new undo event is pushed onto
		 * the stack, thus removing all the entries that are currently after
		 * the current stackIndex
		 * </p>
		 *
		 * @param start The starting index, included in removal
		 * @param end The ending index, excluded from removal
		 */
		protected function removeCommands(start:Number, end:Number):void
		{
			if (end <= start || start < 0)
				return;
			
			var ix:Number = end - 1;
			while (ix >= start) 
			{
				_stack.removeItemAt(ix--);
			}
		}
		
		/**
		 * Returns the current stack index.
		 *
		 * <p>
		 * The whole purpose of having stackIndex getters and setters is to
		 * allow the indexChanged event to be dispatched so that the getters
		 * for canUndo, canRedo, undoText, and redoText will be updated
		 * appropriately.
		 * </p>
		 */
		protected function get stackIndex():Number
		{
			return __stackIndex;
		}
		
		/**
		 * Updates the current stack index.
		 *
		 * <p>
		 * Updates the current stack index and dispatches the indexChanged
		 * event.
		 * </p>
		 */
		protected function set stackIndex(ix:Number):void
		{
			__stackIndex = ix;
			dispatchEvent(new Event("indexChanged"));
			dispatchEvent(new Event("cleanChanged"));
		}
		
		
		/**
		 * Updates the clean index and dispatches the cleanChanged event.
		 *
		 * <p>
		 * It would be nice if ActionScript supported public getters with
		 * private setters as then I wouldn't need this helper function.
		 * </p>
		 */
		protected function setCleanIndex(ix:Number):void
		{
			_cleanIndex = ix;
			dispatchEvent(new Event("cleanChanged"));
		}

		
		protected function traceStack():void
		{
			for (var i:uint=0;i<_stack.length;i++)
			{
				if (i==stackIndex)
				{
					Logger.debug("## " + i + ") " + IUndoRedoCommand(_stack[stackIndex]).toString(), this)
				}
				else 
				{					
					Logger.debug(i + ") " + IUndoRedoCommand(_stack[i]).toString(), this)
				}	
			}
		}

		
		
		
		
	}
}