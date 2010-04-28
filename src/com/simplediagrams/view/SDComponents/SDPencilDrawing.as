package com.simplediagrams.view.SDComponents
{
	
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDPencilDrawingModel;
	import com.simplediagrams.util.Logger;
	
	import mx.events.PropertyChangeEvent;


	public class SDPencilDrawing extends SDBase implements ISDComponent
	{				
		private var _model:SDPencilDrawingModel
		
		[Bindable]
		public var linePath:String 
		
		[Bindable]
		public var lineColor:Number 
		
		[Bindable]
		public var lineWeight:Number 
						
		public function SDPencilDrawing()
		{
			super();
			this.setStyle("skinClass", Class(SDPencilDrawingSkin))
		}
		
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
	       
			//if (instance == DragCircle)
			//	dragCircle.addEventListener(MouseEvent.MOUSE_DOWN, onDragCircleMouseDown)
	    }

		
		public function set objectModel(objectModel:SDObjectModel):void
		{
			Logger.debug("set model() model: " + objectModel, this)         
            _model = SDPencilDrawingModel(objectModel)
            
            x = _model.x;
            y = _model.y;         
			this.depth = _model.depth;
		  	            
			lineColor=_model.color
			lineWeight=_model.lineWeight
			linePath=_model.linePath  
                	
            _model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
        	
            
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
			
			 	case "x": 
                	x = event.newValue as Number
                	break
                	
                case "y":
                	y = event.newValue as Number
                	break					
                
                case "linePath":
                	this.linePath = event.newValue as String
					Logger.debug("changing path to : " + linePath)
					break
				
                case "color":
                	lineColor = event.newValue as Number
                	break
                
                case "lineWeight":
                	lineWeight = event.newValue as Number
                	break
                	
                
			}
			
		}        
       
       	        
        																	
		public override function destroy():void
		{
			super.destroy()
			_model = null
		}
		
		
		
	}
}