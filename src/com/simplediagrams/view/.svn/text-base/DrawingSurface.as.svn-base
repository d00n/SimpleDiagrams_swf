package com.simplediagrams.view
{
	import com.simplediagrams.events.ColorEvent;
	import com.simplediagrams.events.StyleEvent;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.DiagramStyleManager;
	import com.simplediagrams.util.Logger;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	
	import org.swizframework.Swiz;
	
	[Event(name="lineDrawn", type="flash.events.Event")]
	public class DrawingSurface extends Canvas 
	{
		
		public static const LINE_DRAWN:String = "lineDrawn"
		
		public var hasDrawing:Boolean = false
		
		protected var _pencilColor:int = 0xFFFFFF
		protected var _pencilWidth:int = 1
		
		protected var _lineColor:int = 0xFFFFFF
		protected var _lineWidth:int = 1
		
		protected var _backgroundColor:int = 0xFFFFFF
		
		public var initialX:Number = 0
		public var initialY:Number = 0
		
		public var finalX:Number = 0
		public var finalY:Number = 0
		
		protected var _maxX:Number = 0
		protected var _maxY:Number = 0
		
		
		protected var _xOffset:Number
		protected var _yOffset:Number
		
		protected var _toolType:String
		
		protected var linePoints:Array = new Array()
		
		
		public function DrawingSurface():void
		{                   
			Swiz.addEventListener(StyleEvent.STYLE_CHANGED, onStyleChanged)
			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onLineMouseMove)
			this.addEventListener(MouseEvent.MOUSE_UP, onLineMouseUp)
		}	
		
		protected function onStyleChanged(event:StyleEvent):void
		{
			switch(event.styleName)
			{
				case DiagramStyleManager.CHALKBOARD_STYLE:
					_lineColor = 0xFFFFFF
					break
				
				case DiagramStyleManager.BASIC_STYLE:
				case DiagramStyleManager.NAPKIN_STYLE:
					_lineColor = 0x000000			
					break
				
				case DiagramStyleManager.WHITEBOARD_STYLE:
					_lineColor = 0x0000CC				
					break
			}
		}
		
		/* The Drawing Surface handles UI when the tool is either LINE tool or PENCIL tool */
		public function set toolType(type:String):void
		{
			clearListeners()
			
			if (type==DiagramModel.LINE_TOOL || type==DiagramModel.PENCIL_TOOL)
			{
				_toolType = type	
				this.mouseEnabled = true
			}
			
		}
		
		public function getPath():String
		{
			//normalize the path so that the top left corner is set correctly
			var len:int = linePoints.length
			var path:String = ""
			for (var i:int = 0; i<len;i++)
			{
				var action:Object = linePoints[i]
				path += action.moveType + " " + (action.x - initialX).toString() + "," + (action.y - initialY).toString() + " "
			}
			
			return path
		}
	
		public function getInitialPoint():Point
		{
			var p:Point = new Point()
			p.x = initialX
			p.y = initialY
			return p
		}
		
		public function getWidth():Number
		{
			return _maxX - initialX 
		}	
		
		public function getHeight():Number
		{
			return _maxY - initialY 
		}	
		
	
		public override function set mouseEnabled(value:Boolean):void
		{
			Logger.debug("drawingSurface mouseEnabled set to: " + value.toString(), this)
			super.mouseEnabled = value
			if (value)
			{
				setListeners()
			}
			else
			{
				hasDrawing = false
				this.graphics.clear()
				clearListeners()
			}
		}
	
		private function setListeners():void
		{
			Logger.debug("setListeners() _toolType" + _toolType, this)
			
			if (this._toolType==DiagramModel.PENCIL_TOOL)
			{	
				linePoints = new Array()
				Logger.debug("adding listeners to drawingSurface")
				this.addEventListener(MouseEvent.MOUSE_DOWN, onPencilMouseDown);
           		this.addEventListener(MouseEvent.MOUSE_UP, onPencilMouseUp); 
			}
			else if (this._toolType == DiagramModel.LINE_TOOL)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onLineMouseDown);
           		this.addEventListener(MouseEvent.MOUSE_UP, onLineMouseUp); 
			}
		}
	
		private function clearListeners():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onPencilMouseDown);
       	 	this.removeEventListener(MouseEvent.MOUSE_MOVE, onPencilMouseMove);
        	this.removeEventListener(MouseEvent.MOUSE_UP, onPencilMouseUp); 
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onLineMouseDown);
       	 	this.removeEventListener(MouseEvent.MOUSE_MOVE, onLineMouseMove);
           	this.removeEventListener(MouseEvent.MOUSE_UP, onLineMouseUp); 
		}
	

		/* DRAWING LINE FUNCTIONS */	
		protected function onLineMouseDown(e:MouseEvent):void
		{
			Logger.debug("handleLineMouseDown()", this)
			initialX = this.mouseX
           	initialY = this.mouseY
			this.addEventListener(MouseEvent.MOUSE_MOVE, onLineMouseMove)
			this.addEventListener(MouseEvent.MOUSE_UP, onLineMouseUp)
		}

		protected function onLineMouseMove(e:MouseEvent):void
		{
			Logger.debug("onLineMouseMove()", this)
			var g:Graphics = this.graphics
			g.clear()
			g.lineStyle(_lineWidth, _lineColor, 1)
			g.moveTo(initialX, initialY)
			g.lineTo(this.mouseX, this.mouseY)
		}
		
		protected function onLineMouseUp(e:MouseEvent):void
		{	
			Logger.debug("onLineMouseMove()", this)
			finalX = this.mouseX
			finalY = this.mouseY
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onLineMouseMove)
			this.removeEventListener(MouseEvent.MOUSE_UP, onLineMouseUp)
			
			dispatchEvent(new Event(LINE_DRAWN, true))
		
			this.graphics.clear()
			
		}

	
	
		/* DRAWING PENCIL FUNCTIONS */


		private function onPencilMouseDown(e:MouseEvent):void
		{
			Logger.debug("onPencilMouseDown()", this)
			if (hasDrawing==false)
            {
            	hasDrawing = true
            	initialX = this.mouseX
            	initialY = this.mouseY
				_maxX = 0
				_maxY = 0
            }	
            Logger.debug("initialX: " + initialX, this)
            Logger.debug("initialY: " + initialY, this)
            
            var g:Graphics = this.graphics;
            g.endFill();
            g.moveTo(mouseX, mouseY);
            g.lineStyle(_pencilWidth, _pencilColor, 1);
        
            this.addEventListener(MouseEvent.MOUSE_MOVE, onPencilMouseMove);
            this.addEventListener(MouseEvent.MOUSE_UP, onPencilMouseUp);
            
        	linePoints.push({moveType:"M", x:mouseX, y:mouseY})
        
		}

		private function onPencilMouseUp(e:MouseEvent):void 
        {
            this.removeEventListener(MouseEvent.MOUSE_MOVE, onPencilMouseMove);            
            linePoints.push({moveType:"L", x:mouseX, y:mouseY})
        }
        
        private function onPencilMouseMove(e:MouseEvent):void 
        {
    		if (mouseX<initialX) initialX = mouseX
    		if (mouseY<initialY) initialY = mouseY
    		
    		_maxX = Math.max(mouseX, _maxX)    		
    		_maxY = Math.max(mouseY, _maxY)
    		    		    		
            var g:Graphics = this.graphics;
            g.lineTo(mouseX, mouseY);
            linePoints.push({moveType:"L", x:mouseX, y:mouseY})
        	
        }
        
        public function clear(): void
        {
        	hasDrawing = false
        	linePoints = []
            graphics.clear();
            invalidateDisplayList();
            
        }
     
		public function set pencilColor(color:Number):void
		{
			_pencilColor= color
		}
		
		public function get pencilColor():Number
		{
			return _pencilColor
		}
		
		public function set pencilWidth(value:Number):void
		{
			_pencilWidth = value
		}
		
		public function get lineColor():Number
		{
			return _lineColor 
		}
		
		public function set lineColor(value:Number):void
		{
			_lineColor = value
		}
	
	}
}