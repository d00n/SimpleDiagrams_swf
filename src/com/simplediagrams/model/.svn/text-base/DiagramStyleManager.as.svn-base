package com.simplediagrams.model
{
	import com.simplediagrams.events.StyleEvent;
	import com.simplediagrams.util.Logger;
	
	import flash.events.EventDispatcher;
	
	import org.swizframework.Swiz;

	[Bindable]
	public class DiagramStyleManager extends EventDispatcher
	{
		
		public static const CHALKBOARD_STYLE:String = "chalkboardStyle"
		public static const WHITEBOARD_STYLE:String = "whiteboardStyle"
		public static const NAPKIN_STYLE:String = "napkinStyle"
		public static const BASIC_STYLE:String = "basicStyle"
		
		protected var _currStyle:String = CHALKBOARD_STYLE
		protected var validStyles:Array
		
		protected var _blackColorMatrix:Array
		protected var _whiteColorMatrix:Array
		
		
		public function DiagramStyleManager() 
		{
			validStyles = [CHALKBOARD_STYLE, WHITEBOARD_STYLE, NAPKIN_STYLE, BASIC_STYLE]
			
			_blackColorMatrix = []
			_blackColorMatrix = _blackColorMatrix.concat([0, 0, 0, 0, 0]); // red
            _blackColorMatrix = _blackColorMatrix.concat([0, 0, 0, 0, 0]); // green
            _blackColorMatrix = _blackColorMatrix.concat([0, 0, 0, 0, 0]); // blue
            _blackColorMatrix = _blackColorMatrix.concat([0, 0, 0, 1, 0]); // alpha
            
            
			_whiteColorMatrix = []
			_whiteColorMatrix = _whiteColorMatrix.concat([0, 0, 0, 0, 255]); // red
            _whiteColorMatrix = _whiteColorMatrix.concat([0, 0, 0, 0, 255]); // green
            _whiteColorMatrix = _whiteColorMatrix.concat([0, 0, 0, 0, 255]); // blue
            _whiteColorMatrix = _whiteColorMatrix.concat([0, 0, 0, 1, 0]); // alpha
		}
	
		public function isValidStyle(styleName:String):Boolean
		{
			return (validStyles.indexOf(styleName)!=-1)
		}
		
		public function get currStyle():String
		{
			return _currStyle
		}

		public function set currStyle(v:String):void
		{
			if (isValidStyle(v))
			{
				_currStyle = v
			}
			else
			{
				Logger.warn("unrecognized style: " + v, this)
			}
			
		}

		public function changeStyle(styleName:String):void
		{
			if (validStyles.indexOf(styleName) !=-1)
			{
					
				Logger.debug("changing style to: " + styleName, this)
		
				_currStyle = styleName
												
				var evt:StyleEvent = new StyleEvent(StyleEvent.STYLE_CHANGED, true)
				evt.styleName = _currStyle
				Swiz.dispatchEvent(evt)
			}
			else
			{
				Logger.error("changeStyle() Unrecognized style: " + styleName, this)
			}		
			
		}
		
		public function get toolBarBackgroundColor():Number
		{
			switch(_currStyle)
			{
				case CHALKBOARD_STYLE:
					return 0xFFFFFF
					break
				
				case NAPKIN_STYLE:
				case BASIC_STYLE:	
				case WHITEBOARD_STYLE:
					return 0x000000			
					break
				
				default:
					Logger.error("toolBarBackgroundColor() unrecognized style: " + _currStyle, this)				
					
			}
			return 0x000000
		}
		
		
		
		public function get defaultSymbolColor():Number
		{
			switch(_currStyle)
			{
				case CHALKBOARD_STYLE:
					return 0xFFFFFF
					break
								
				case NAPKIN_STYLE:
				case BASIC_STYLE:	
					return 0x000000				
					break
				
				case WHITEBOARD_STYLE:
					return 0x0000CC			
					break
				
				default:
					Logger.error("defaultSymbolColor() unrecognized style: " + _currStyle, this)				
							
			}
			return 0xFFFFFF
		}
		
		public function get defaultColorMatrix():Array
		{
			switch(_currStyle)
			{
				case CHALKBOARD_STYLE:
				case BASIC_STYLE:	
					return _whiteColorMatrix
					break
								
				case NAPKIN_STYLE:
				case WHITEBOARD_STYLE:
					return _blackColorMatrix				
					break
				
				default:
					Logger.error("unrecognized style: " + _currStyle, this)			
			}
			
			return _whiteColorMatrix
		}
		
		public function get marqueeColor():Number
		{
			switch(_currStyle)
			{
				case CHALKBOARD_STYLE:
				case NAPKIN_STYLE:
				case BASIC_STYLE:	
				case WHITEBOARD_STYLE:
					return 0x999999;
					break
								
				
				default:
					Logger.error("unrecognized style: " + _currStyle, this)	
					return 0xFFFFFF;
			}
		}
	
		
		public function get marqueeBorderColor():Number
		{
			switch(_currStyle)
			{
				case CHALKBOARD_STYLE:
				case NAPKIN_STYLE:
				case BASIC_STYLE:		
				case WHITEBOARD_STYLE:
					return 0xCCCCCC;
					break
									
				
				default:
					Logger.error("unrecognized style: " + _currStyle, this)	
					return 0xFFFFFF;
			}
		}
	}
}