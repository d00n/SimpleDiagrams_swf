package com.simplediagrams.view.SDComponents
{
	
	import com.simplediagrams.events.DragCircleEvent;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
	
	import flash.events.MouseEvent;
	
	import mx.events.PropertyChangeEvent;
	
	import spark.components.Label;
	import spark.primitives.Graphic;

	[SkinState("normal")]
	[SkinState("selected")]
	[Bindable]
	public class SDLine extends SDBase implements ISDComponent
	{				
		
		[SkinPart(required="true")]		
		public var startDragCircle:DragCircle;
		
		[SkinPart(required="true")]		
		public var startLineShape:Graphic
		
		[SkinPart(required="true")]		
		public var startLineCircle:Graphic
		
		[SkinPart(required="true")]		
		public var startLineHitArea:Graphic		
		
		[SkinPart(required="true")]
		public var endDragCircle:DragCircle;
		
		[SkinPart(required="true")]		
		public var endLineShape:Graphic
		
		[SkinPart(required="true")]		
		public var endLineCircle:Graphic
		
		[SkinPart(required="true")]
		public var endLineHitArea:Graphic
		
		[SkinPart(required="true")]
		public var lblText:Label
				
		[SkinPart(required="true")]
		public var arcDragCircle:DragCircle;
		
		private var _model:SDLineModel		
		public var linePath:String		
		public var lineColor:Number		
		public var lineWeight:Number		
		public var startX:Number = -1			
		public var startY:Number = -1	
		public var startAngle:Number = -1	
		public var endX:Number = -1 
		public var endY:Number = -1		
		public var textX:Number = -1		
		public var textY:Number = -1		
		public var textRotation:Number = 0
		public var endAngle:Number
		public var startLineStylePath:String				
		public var endLineStylePath:String		
		public var startLineCircleVisible:Boolean = false;				
		public var endLineCircleVisible:Boolean = false
		public var startLineSolidCircleVisible:Boolean = false;				
		public var endLineSolidCircleVisible:Boolean = false
		public var text:String
		public var fontColor:Number = 0xFFFFFF
		
		protected var origX:Number // used to track changes to startDragCircle
		protected var origY:Number 
		protected var origEndX:Number
		protected var origEndY:Number
		
		protected var _draggingArcCircle:Boolean = false
		
		public function SDLine()
		{
			super();
			this.setStyle("skinClass",Class(SDLineSkin))
			this.mouseChildren = true
		}
			
			
			
		public function set objectModel(objectModel:SDObjectModel):void
		{
			Logger.debug("set model() model: " + objectModel, this)         
			_model = SDLineModel(objectModel)
					
			x = _model.x;
			y = _model.y;         
			
			startX = _model.startX
			startY = _model.startY
			
			endX = _model.endX			
			endY = _model.endY
			this.depth = _model.depth;
			
			lineColor=_model.color
			lineWeight=_model.lineWeight
				
			text = _model.text
							
			_model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
						
			textX = startX+ ((endX - startX) / 2)
			textY = startY+ ((endY - startX) / 2)
				
			drawPath()		
			setAngles()
			drawStartLineStyle()
			drawEndLineStyle()
			
		}
		
		public override function get objectModel():SDObjectModel
		{
			return _model
		}
		
		
		override protected function onModelChange(event:PropertyChangeEvent):void
		{
			super.onModelChange(event)
				
				switch(event.property)
				{
					case "selected": 						
						invalidateSkinState();						
						break
					
					case "x": 
						x = event.newValue as Number
						break
						
					case "y":
						y = event.newValue as Number
						break
					
					
					case "startX":
						startX = event.newValue as Number
						startDragCircle.x = startX
						this.repositionText()
						break
						
					case "startY":					
						startY = event.newValue as Number
						startDragCircle.y = startY
						this.repositionText()
						break
						
					case "endX":
						endX = event.newValue as Number
						endDragCircle.x = endX
						this.repositionText()
						break
						
					case "endY":
						endY = event.newValue as Number
						endDragCircle.y = endY
						this.repositionText()
						break
					
					case "bendX":
						if (!_draggingArcCircle) this.positionArcCircle()
						break
					
					case "bendY":
						if (!_draggingArcCircle) this.positionArcCircle()
						break
											
					case "color":
						lineColor=_model.color
						break
						
					case "lineWeight":
						lineWeight=_model.lineWeight
						break
						
					case "startLineStyle":
						drawStartLineStyle()
						break
						
					case "endLineStyle":
						drawEndLineStyle()
						break
					
					case "fontColor":
						this.fontColor = event.newValue as Number
						
					case "text":
						this.text = String(event.newValue)
											
				}
				
				this.invalidateProperties()
				drawPath()
				
		}        
		
		
		protected function drawStartLineStyle():void
		{
			//clear out any old styles
			startLineCircleVisible = false
			startLineSolidCircleVisible = false
				
			switch (_model.startLineStyle)
			{
				case SDLineModel.NONE_STYLE:
					var p:String = "M 0,0"			
					break
				
				case SDLineModel.ARROW_STYLE:
					p = "M 10,-10 L 0,0 L 10,10"			
					break
				
				case SDLineModel.STOP_LINE_STYLE:					
					p = "M 0,-10 L 0,10"
					break
					
				case SDLineModel.SOLID_ARROW_STYLE:
					p = "M 0,-10 L -10,0 L 0,10 z"					
					break
					
				case SDLineModel.CIRCLE_LINE_STYLE:
					p = "M 0 0"
					startLineCircleVisible = true
					break
				
				case SDLineModel.SOLID_CIRCLE_LINE_STYLE:
					p = "M 0 0"
					startLineSolidCircleVisible = true
					break
					
			}
			startLineStylePath = p		
		}
		
		protected function drawEndLineStyle():void
		{
			
			//clear out any old styles
			endLineCircleVisible = false
			endLineSolidCircleVisible = false
				
			switch (_model.endLineStyle)
			{
				
				case SDLineModel.NONE_STYLE:
					var p:String = "M 0,0"			
					break
				
				case SDLineModel.ARROW_STYLE:				
					p = "M -10,-10 L 0,0 L -10,10"
					break
				
				case SDLineModel.STOP_LINE_STYLE:				
					p = "M 0,-10 L 0,10"					
					break
					
				case SDLineModel.SOLID_ARROW_STYLE:
					p = "M 0,-10 L 10,0 L 0,10 z"					
					break
					
				case SDLineModel.CIRCLE_LINE_STYLE:
					p = "M 0 0"
					endLineCircleVisible = true				
					break
				
				case SDLineModel.SOLID_CIRCLE_LINE_STYLE:
					p = "M 0 0"
					endLineSolidCircleVisible = true				
					break
					
			}
			endLineStylePath = p		
		}
		
		override protected function getCurrentSkinState():String
    	{	
    		if (_model && _model.selected) 
    		{    			
    			return "selected"
    		}
    		
    		return super.getCurrentSkinState()
    	}
	
		protected function positionArcCircle():void
		{
			arcDragCircle.x = _model.bendX
			arcDragCircle.y = _model.bendY	
		}	
		
		protected function setAngles():void
		{	
					
			var a:Number = (Math.atan(  (_model.bendY - _model.startY) / (_model.bendX - _model.startX) )) * 180 / Math.PI 
			if (_model.bendX < _model.startX) a = 180 + a 
			startAngle = a
			
			a = (Math.atan(  (_model.endY - _model.bendY) / (_model.endX - _model.bendX) )) * 180 / Math.PI 
			if (_model.bendX > _model.endX) a = 180 + a 
			endAngle = a
			
		}
				
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);		 
			if( instance == arcDragCircle)
			{
				arcDragCircle.addEventListener(MouseEvent.MOUSE_DOWN , onArcDragCircleDown);
				arcDragCircle.addEventListener(MouseEvent.MOUSE_UP , onDragCircleUp);
				positionArcCircle()
			}
			else if (instance == startDragCircle)
			{				
				startDragCircle.addEventListener(MouseEvent.MOUSE_DOWN , onStartDragCircleDown);
				startDragCircle.addEventListener(MouseEvent.MOUSE_UP , onDragCircleUp);
				startDragCircle.doubleClickEnabled = true
			}
			else if (instance == startLineShape)
			{
				startLineShape.rotation = startAngle
			}
			else if (instance == endDragCircle)
			{
				endDragCircle.addEventListener(MouseEvent.MOUSE_DOWN , onEndDragCircleDown);
				endDragCircle.addEventListener(MouseEvent.MOUSE_UP , onDragCircleUp);	
				endDragCircle.x = _model.endX
				endDragCircle.y = _model.endY	
			}			
			else if (instance == startLineHitArea)
			{				
				startLineHitArea.addEventListener(MouseEvent.DOUBLE_CLICK , onStartLineHitAreaHit);	
				startLineHitArea.rotation = startAngle
			}
			else if (instance == endLineHitArea)
			{
				endLineHitArea.addEventListener(MouseEvent.DOUBLE_CLICK , onEndLineHitAreaHit);	
				endLineHitArea.rotation = endAngle				
			}
			else if (instance == endLineShape)
			{				
				endLineShape.rotation = endAngle		
				this.invalidateProperties()						
			}
		}
		
		public function onStartDragCircleClick(event:MouseEvent):void
		{
			Logger.debug("onStartDragCircleClick()", this)
		}
		
		
		public function onStartLineHitAreaHit(event:MouseEvent):void
		{
			Logger.debug("onStartLineHitAreaHit()", this)
			_model.nextStartLineStyle()
		}
		
		public function onEndLineHitAreaHit(event:MouseEvent):void
		{			
			_model.nextEndLineStyle()
		}
						
														
		protected function onArcDragCircleDown(event:MouseEvent):void
		{
			_draggingArcCircle = true 
				
			arcDragCircle.addEventListener(MouseEvent.MOUSE_MOVE , onArcDragCircleMove);
			arcDragCircle.startDrag()
			event.stopImmediatePropagation()
						
			var evt:DragCircleEvent = new DragCircleEvent(DragCircleEvent.DRAG_CIRCLE_DOWN, true)
			evt.sdLineModel = _model
			dispatchEvent(evt)
		}
										
		protected function onStartDragCircleDown(event:MouseEvent):void
		{					
			startDragCircle.addEventListener(MouseEvent.MOUSE_MOVE , onStartDragCircleMove);
			startDragCircle.startDrag()
			event.stopPropagation()
			
			var evt:DragCircleEvent = new DragCircleEvent(DragCircleEvent.DRAG_CIRCLE_DOWN, true)
			evt.sdLineModel = _model
			dispatchEvent(evt)
		}		
						
		protected function onEndDragCircleDown(event:MouseEvent):void
		{
			endDragCircle.addEventListener(MouseEvent.MOUSE_MOVE , onEndDragCircleMove);
			endDragCircle.startDrag()
			event.stopImmediatePropagation()
			
			var evt:DragCircleEvent = new DragCircleEvent(DragCircleEvent.DRAG_CIRCLE_DOWN, true)
			evt.sdLineModel = _model
			dispatchEvent(evt)
		}
												
		protected function onStartDragCircleMove(event:MouseEvent):void
		{			
			_model.startX = startDragCircle.x
			_model.startY = startDragCircle.y
			repositionText()
			
		}
		
		protected function onEndDragCircleMove(event:MouseEvent):void
		{
			_model.endX = endDragCircle.x
			_model.endY = endDragCircle.y
			repositionText()
		}
				
		protected function onArcDragCircleMove(event:MouseEvent):void
		{
			_model.bendX = arcDragCircle.x
			_model.bendY = arcDragCircle.y
			repositionText()
		}
		
		protected function repositionText():void
		{
			if (startDragCircle&&endDragCircle)
			{
				textX = startDragCircle.x + ((endDragCircle.x - startDragCircle.x) / 2)
				textY = startDragCircle.y + ((endDragCircle.y - startDragCircle.y) / 2)
			}	
		}
		
		
															
		protected function onDragCircleUp(event:MouseEvent):void
		{			
			_draggingArcCircle = false
			event.target.stopDrag()
				
			if (event.target==arcDragCircle)
			{
				arcDragCircle.removeEventListener(MouseEvent.MOUSE_MOVE , onArcDragCircleMove);
			}
			else if (event.target == startDragCircle)
			{
				startDragCircle.removeEventListener(MouseEvent.MOUSE_MOVE , onStartDragCircleMove);				
			}
			else if (event.target == endDragCircle)
			{
				endDragCircle.removeEventListener(MouseEvent.MOUSE_MOVE , onEndDragCircleMove);				
			}
						
			_model.width = this.width
			_model.height = this.height
						
			var evt:DragCircleEvent = new DragCircleEvent(DragCircleEvent.DRAG_CIRCLE_UP, true)
			evt.sdLineModel = _model
			dispatchEvent(evt)
				
		}		
											
		protected function drawPath():void
		{
			if (_model==null) return
			var p:String = "M " +  _model.startX + "," + _model.startY
			p+= "Q " + _model.bendX + "," + _model.bendY +" " + _model.endX + "," + _model.endY
			//p+= "L " + _model.endX + "," + _model.endY
			this.linePath = p
			invalidateProperties()
			setAngles()   
			
		}
		
																			
		public override function destroy():void
		{
			super.destroy()
			_model = null
		}
																						
																									
																							
	}
}