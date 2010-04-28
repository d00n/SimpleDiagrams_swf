package  com.simplediagrams.view.components
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.listClasses.IListItemRenderer;
	
	/** 
	 *  DataGrid that uses checkboxes for multiple selection
	 */
	public class CheckBoxDataGrid extends DataGrid
	{
		
		override protected function selectItem(item:IListItemRenderer,
											   shiftKey:Boolean, ctrlKey:Boolean,
											   transition:Boolean = true):Boolean
		{
			return false;
		}
		
		// turn off selection indicator
		override protected function drawSelectionIndicator(
			indicator:Sprite, x:Number, y:Number,
			width:Number, height:Number, color:uint,
			itemRenderer:IListItemRenderer):void
		{
		}
		
	}
	
}