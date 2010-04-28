package com.simplediagrams.model
{
	import mx.collections.ArrayCollection;
	import com.simplediagrams.util.Logger
	import com.simplediagrams.model.SDObjectModel
	import org.swizframework.Swiz;
	import flash.text.engine.FontWeight
	
	public class SettingsModel
	{
		
		public var recentFilesAC:ArrayCollection = new ArrayCollection()
		private var _defaultDiagramStyle:String = DiagramStyleManager.CHALKBOARD_STYLE
		
		//remember the line style last selected (or loaded from settings)
		//this is updated by controller
		public var defaultStartLineStyle:uint = SDLineModel.NONE_STYLE
		public var defaultEndLineStyle:uint = SDLineModel.ARROW_STYLE
		public var defaultTextPosition:String = SDObjectModel.TEXT_POSITION_TOP
			
		protected var _defaultLineWeight:uint = 1		
		protected var _defaultFontSize:Number = 12
		protected var _defaultTextAlign:String = "left"
		protected var _defaultFontWeight:String = "normal"
			
		public function SettingsModel()
		{
		}
		
		public function set defaultDiagramStyle(styleName:String):void
		{
			var diagramStylesMager:DiagramStyleManager = Swiz.getBean("diagramStyleManager") as DiagramStyleManager
			if (diagramStylesMager.isValidStyle(styleName))
			{
				_defaultDiagramStyle = styleName
			}	
		}
		
		public function get defaultDiagramStyle():String
		{
			return _defaultDiagramStyle
		}
		
		
		public function get defaultFontSize():Number
		{
			return _defaultFontSize
		}
		
		public function set defaultFontSize(value:Number):void
		{
			if (value<=3) value = 12 
			_defaultFontSize=value
		}
		
		public function get defaultFontWeight():String
		{
			return _defaultFontWeight
		}
		
		public function set defaultFontWeight(value:String):void
		{
			if (value == FontWeight.BOLD || value == FontWeight.NORMAL)	_defaultFontWeight=value		
		}
		
		public function get defaultLineWeight():Number
		{
			return _defaultLineWeight
		}
		
		public function set defaultLineWeight(value:Number):void
		{
			if (value<=0) value=1
			if (value>100) value=100
			_defaultLineWeight=value
		}
		
		
		public function get defaultTextAlign():String
		{
			return _defaultTextAlign
		}
		
		public function set defaultTextAlign(value:String):void
		{
			if (value=="left" || value=="right" || value=="center" || value=="justify")
			{
				_defaultTextAlign=value
			}
			else
			{
				_defaultTextAlign = "left"
				Logger.warn("unrecognized textAlign value: " + value, this)
			}			
		}
		
		
	}
}