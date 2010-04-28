package com.simplediagrams.commands
{
	
	
	/**
	 * The Undo/Redo interface used by the undo/redo stack
	 */
	public interface IUndoRedoCommand extends ICommand
	{
		/**
		 * Performs an undo operation.
		 * 
		 * <p>
		 * All data specific to the undo operation should have been stored at
		 * the time redo() was called with the initial event, as no
		 * information is passed to the undo event function directly.
		 * </p>
		 */
		function undo() : void;
		
		/**
		 * Performs a redo operation.
		 *
		 * <p>redo() is expected to store data sufficient for the operation to be undone
		 * and/or redone.  The redo operation will typically operate on the
		 * model or call delegates that will operate on the module.
		 * </p>
		 *
		 */
		function redo() : void;
		
			
		/**
		 * The type of undo operation.
		 *
		 * <p>
		 * An operation can be <code>"normal"</code>, <code>"ignored"</code>,
		 * or <code>"reset"</code>.
		 * </p>
		 *
		 * <p>
		 * normal - Appends the command onto the undo stack, calls redo()
		 * </p>
		 *
		 * <p>
		 * ignored - Calls redo(), does not affect the undo stack
		 * </p>
		 *
		 * <p>
		 * reset - Calls redo(), clears the undo stack.
		 * </p>
		 *
		 * @return The current undoType
		 */
		function get undoType() : String;
		
	
	}
}
