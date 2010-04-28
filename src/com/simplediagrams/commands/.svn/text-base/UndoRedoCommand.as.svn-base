
/*
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

package com.simplediagrams.commands
{
	
	import com.simplediagrams.util.Logger
	import org.spicefactory.lib.reflect.ClassInfo;
		
	/**
	 * A suitable base class that implements the IUndoCommand interface.
	 *
	 * @see com.sophware.undoredo.commands.IUndoCommand
	 */
	public class UndoRedoCommand implements IUndoRedoCommand
	{
		
		/**
		 * The "normal" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_NORMAL:String = "normal";
		
		/**
		 * The "ignored" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_IGNORED:String = "ignored";
		
		/**
		 * The "reset" undoType as specified by <code>IUndoCommand</code>.
		 */
		public static const UNDOTYPE_RESET:String = "reset";
		
		
		
		private var _undoType:String;
		
		/**
		 * Creates an UndoCommand with no text specified.
		 */
		public function UndoRedoCommand():void
		{
			_undoType = UNDOTYPE_NORMAL;
		}
					
				
		
		/**
		 * Performs an undo operation
		 */
		public function undo() : void
		{
			// must be overriden in derived class
		}
		
		
		/**
		 * Performs the initial modifications, as well as the redo operation
		 * after an undo event.
		 */
		public function redo() : void
		{
			// must be overriden in derived class
		}
		
		
		/**
		 * Execute is called by the front controller and is only used for the
		 * initial set of modifications.
		 * 
		 * <p>
		 * This normally does not need to be overridden as it calls redo()
		 * which generally performs the necessary changes. 
		 * </p>
		 */
		public function execute() : void
		{		
			redo();
		}
				
		
		/**
		 * Returns the undo type associated with the command.
		 */
		[Bindable]
		public function get undoType() : String
		{
			return _undoType;
		}
		
		
		/**
		 * Sets the undo type associated with the command.
		 */
		public function set undoType(type : String) : void
		{
			_undoType = type;
		}
		
		public function toString():String
		{
			return "Command: " + ClassInfo.forInstance(this).simpleName
		}
		
	}
}
