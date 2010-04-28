package com.simplediagrams.model
{
	import com.simplediagrams.model.mementos.ITransformMemento;
	import com.simplediagrams.model.mementos.SDObjectMemento;
	import com.simplediagrams.model.mementos.SDSymbolMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.ISDComponent;
	import com.simplediagrams.view.SDComponents.SDSymbol;
	
	import flash.text.engine.FontWeight;

	[Bindable]
	public class SDSymbolModel extends SDObjectModel implements ITransformMemento
	{	
		
						
		public var libraryName:String	
		public var symbolName:String
		
		protected var _fontWeight:String  = "normal";
		protected var _textAlign:String  = "left";
		private var _fontSize:Number = 12
		protected var _textPosition:String = TEXT_POSITION_TOP
		public var text:String  = "";
		
		public var displayName:String //this is assigned by Library and used when symbol is placed in library for toolTip and such
				
		
		public function SDSymbolModel(symName:String="", initialWidth:Number=50, initialHeight:Number=50, colorizable:Boolean=true)
		{
			super();
			symbolName = symName
			displayName = symName //default behavior is display name is same as symbol name...can be changed in init function of library
			_width = initialWidth
			_height = initialHeight
			this.colorizable = colorizable
		}
		
		public override function createSDComponent():ISDComponent
		{
			Logger.debug("creating sdComponent...",this)
			//var component:SDSymbolComponent = new SDSymbolComponent()
			var component:SDSymbol = new SDSymbol()
			component.objectModel = this
			this.sdComponent = component
				
			Logger.debug("returning component: " + component,this)
			return component
		}
		
		public function get textAlign():String
		{
			
			return _textAlign	
		}
		
		public function set textAlign(value:String):void
		{
			if (value=="left" || value=="right" || value=="center" || value=="justify")
			{
				_textAlign=value
			}
			else
			{
				_textAlign = "left"
				Logger.warn("unrecognized textAlign value: " + value, this)
			}
		}
		
		public function get textPosition():String
		{
			
			return _textPosition	
		}
		
		public function set textPosition(value:String):void
		{
			
			Logger.debug("textPosition()  value: " + value, this)
			if (value==TEXT_POSITION_ABOVE || value==TEXT_POSITION_TOP || value==TEXT_POSITION_MIDDLE || value==TEXT_POSITION_BOTTOM || value==TEXT_POSITION_BELOW)
			{
				_textPosition=value
			}
			else
			{
				_textPosition = TEXT_POSITION_TOP
				Logger.warn("unrecognized textPosition value: " + value, this)
			}
		}
		
		
		public function set fontWeight(weight:String):void
		{
			if (weight != FontWeight.BOLD && weight != FontWeight.NORMAL)
			{
				return
			}			
			_fontWeight = weight
			
		}
		
		public function get fontWeight():String
		{			
			return	_fontWeight 
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
	
		public function getTextYPosition():Number
		{
			var textYPos:Number = 5
			switch (textPosition)
			{
				case TEXT_POSITION_ABOVE:
					textYPos = -20
					break
				
				case TEXT_POSITION_TOP:
					textYPos = 5
					break
				
				case TEXT_POSITION_MIDDLE:					
					textYPos = uint(height/2) - uint(fontSize / 2)
					break
				
				case TEXT_POSITION_BOTTOM:
					textYPos = height - (fontSize + 10)
					break
				
				case TEXT_POSITION_BELOW:
					textYPos = height + 5 
					break
				
				default:
					Logger.error("unrecognized textPosition: " +textPosition, this)
				
			}
			return textYPos
		
		}
		
		override public function getMemento():SDObjectMemento
		{
			var memento:SDSymbolMemento = new SDSymbolMemento()
			captureBasePropertiesInMemento(memento)
			
			//now record SDSymbolModel's specific properties into memento
			memento.symbolName = this.symbolName
			memento.libraryName = this.libraryName
			
			var mem:SDSymbolMemento = SDSymbolMemento(memento)
			mem.symbolName = symbolName
			mem.libraryName = libraryName
			mem.textAlign = textAlign
			mem.text = text
			mem.textPosition = textPosition
				
			return mem 
		}
		
		
		override public function setMemento(memento:SDObjectMemento):void
		{
			//set base properties from memento
			this.setBasePropertiesFromMemento(memento)
		
			//Symbol specific properties
			var mem:SDSymbolMemento = SDSymbolMemento(memento)
			symbolName = mem.symbolName
			libraryName = mem.libraryName
			textAlign = mem.textAlign
			text = mem.text
			textPosition = mem.textPosition
			
		}
						
		
		
		
		
		
		
	}
}