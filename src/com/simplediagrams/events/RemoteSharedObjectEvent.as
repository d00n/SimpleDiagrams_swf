package com.simplediagrams.events
{
	import com.simplediagrams.model.SDImageModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.mementos.TransformMemento;
	
	import flash.events.Event;
	import flash.utils.ByteArray;

	
	public class RemoteSharedObjectEvent extends Event
	{
		
		public static const CHANGE_ALL_SHAPES_TO_DEFAULT_COLOR:String = "rso_changeAllShapesToDefaultColor";
		public static const RESET:String = "rso_reset";
		public static const STOP:String = "rso_stop";
		public static const START:String = "rso_start";
		public static const LOAD_IMAGE:String = "rso_loadImage";
		public static const CHANGE_COLOR:String = "rso_changeColor";
		public static const DISPATCH_TEXT_AREA_CHANGE:String = "rso_dispatchTextAreaChange";
		public static const ADD_SD_OBJECT_MODEL:String = "rso_addSDObjectModel";
		public static const DELETE_SELECTED_SD_OBJECT_MODEL:String = "rso_DeleteSelectedSDObjectModel";
		public static const OBJECT_CHANGED:String = "rso_ObjectChanged";
		public static const CUT:String = "rso_CutEvent";
		public static const PASTE:String = "rso_PasteEvent";
		public static const REFRESH_Z_ORDER:String = "rso_refreshZOrder";
		public static const TEXT_WIDGET_ADDED:String = "rso_TextWidgetAdded";
		public static const TEXT_WIDGET_CREATED:String = "rso_TextWidgetCreated";
		public static const PENCIL_DRAWING_CREATED:String = "rso_PencilDrawingCreated";
		public static const CREATE_LINE_COMPONENT:String = "rso_CreateLineComponent";
		public static const REFRESH_ZOOM:String = "rso_RefreshZoom";
		public static const CHANGE_LINE_POSITION:String = "rso_ChangeLinePosition";
		public static const SYMBOL_TEXT_EDIT:String = "rso_SymbolTextEdit";
		
		
		private var _imageData:ByteArray
		public static const STYLE_PHOTO:String = "photoStyle";
		public var sdImageModel:SDImageModel;
		public var text:String;
		public var color:Number;
		public var sdID:Number;
		public var memento:TransformMemento;
		public var sdObjectModel:SDObjectModel;

		public function RemoteSharedObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set imageData(v:ByteArray):void
		{
			_imageData = v;
		}
		public function get imageData():ByteArray
		{
			return _imageData;
		}
	}
}