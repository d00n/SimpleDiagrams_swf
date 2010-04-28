package com.simplediagrams.model
{
	
	
	import com.simplediagrams.model.mementos.SDLineMemento;
	import com.simplediagrams.model.mementos.SDObjectMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.ISDComponent;
	import com.simplediagrams.view.SDComponents.SDLine;


	[Bindable]
	[Table(name="lines")]
	public class SDLineModel extends SDObjectModel
	{
		public static const NONE_STYLE:Number = 0;
		public static const STOP_LINE_STYLE:Number = 1;
		public static const ARROW_STYLE:Number = 2;
		public static const SOLID_ARROW_STYLE:Number = 3;
		public static const CIRCLE_LINE_STYLE:Number = 4;
		public static const SOLID_CIRCLE_LINE_STYLE:Number = 5;
		
		public static const TEXT_INSIDE_CURVE:String = "textInsideCurve"
		public static const TEXT_OUTSIDE_CURVE:String = "textOutsideCurve"
		public static const TEXT_FOLLOW_CURVE:String = "textFollowCurve"
		
		protected var numStyles:int = 5;
		
		public var startX:Number = 0;
		public var startY:Number = 0;
		public var endX:Number = 100;
		public var endY:Number = 100;
		public var bendX:Number = 50;
		public var bendY:Number = 40;
		public var lineWeight:Number = 1;
		public var startLineStyle:int = SDLineModel.STOP_LINE_STYLE;	
		public var endLineStyle:int = SDLineModel.ARROW_STYLE	
		public var textAlignStyle:String = TEXT_FOLLOW_CURVE	
		
		private var _text:String = ""
		private var _fontSize:Number = 12
		private var _fontColor:Number = 0xFFFFFF
			
		private var _startLineState:SDLineMemento
		
		public function SDLineModel()
		{
		}
		
		public function init():void
		{
			this.bendX = endX / 2
			this.bendY = endY / 2
		}
					
		public override function createSDComponent():ISDComponent
		{
			var component:SDLine = new SDLine()
			component.objectModel = this
			this.sdComponent = component
			Logger.debug("component: " + component, this)
			return component
		}
	
		public function nextStartLineStyle():void
		{
			if (startLineStyle < (numStyles - 1))
			{
				startLineStyle++
			}
			else
			{
				startLineStyle = 0
			}
		}
		
		public function nextEndLineStyle():void
		{
			if (endLineStyle < (numStyles - 1))
			{
				endLineStyle++
			}
			else
			{
				endLineStyle = 0
			}
		}
		
		public function get text():String
		{
			return _text	
		}
		
		public function set text(value:String):void
		{
			_text = value
		}
		
				
		public function get fontSize():Number
		{
			return _fontSize	
		}
		
		public function set fontSize(value:Number):void
		{
			if (fontSize<3) value = 3
			_fontSize = value
		}		
		
		public function get fontColor():Number
		{
			return _fontColor	
		}
		
		public function set fontColor(value:Number):void
		{
			_fontColor = value
		}
		
		
		override public function getMemento():SDObjectMemento
		{
			var memento:SDLineMemento = new SDLineMemento()
			captureBasePropertiesInMemento(memento)
			
			memento.startX = this.startX
			memento.startY = this.startY
			memento.bendX = this.bendX
			memento.bendY = this.bendY
			memento.endX = this.endX
			memento.endY = this.endY
			
			memento.startLineStyle = this.startLineStyle
			memento.endLineStyle = this.endLineStyle
			memento.lineWeight = this.lineWeight
			
			return memento 
		}
		
		public function captureLineStartState():void
		{
			_startLineState = getMemento() as SDLineMemento
		}
		
		public function getLineStartState():SDLineMemento
		{
			return _startLineState
		}
		
		override public function setMemento(memento:SDObjectMemento):void
		{
			Logger.debug("setting memento. startLineStyle: " + SDLineMemento(memento).startLineStyle, this)
			if (memento is SDLineMemento)
			{
				var mem:SDLineMemento = SDLineMemento(memento)
				//set base properties from memento
				this.setBasePropertiesFromMemento(mem)
						
				this.startLineStyle = mem.startLineStyle 
				this.endLineStyle = mem.endLineStyle 
				this.lineWeight = mem.lineWeight 
									
				this.startX = mem.startX 
				this.startY = mem.startY
				this.bendX = mem.bendX
				this.bendY = mem.bendY
				this.endX = mem.endX
				this.endY = mem.endY
					
			}
		}
		
		
		
		
		
				
	}
}