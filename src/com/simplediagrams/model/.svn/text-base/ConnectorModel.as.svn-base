package com.simplediagrams.model
{
	
	import com.simplediagrams.util.Logger;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.events.PropertyChangeEvent;

	[Bindable]
	public class ConnectorModel extends EventDispatcher
	{
							
		private var _fromModel:SDObjectModel
		private var _toModel:SDObjectModel
		private var _lineModel:SDLineModel
									
								
		public function ConnectorModel()
		{
			
		}
		
		public function createConnectorComponent(fromModel:SDObjectModel, toModel:SDObjectModel, lineModel:SDLineModel):void
		{
			this._fromModel = fromModel
			this._toModel = toModel
			this._lineModel = lineModel
			
			//setup listeners			
            _fromModel.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onFromModelChange, false, 0, true );
            _toModel.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onToModelChange, false, 0, true );
			
			//position line
			repositionFromModelConnector()	
			repositionToModelConnector()														
			
		}
		
		
		protected function onFromModelChange(event:PropertyChangeEvent):void
        {
            switch( event.property )
            {
                case "x":
                case "y":      
                case "width":
                case "height":
                	repositionFromModelConnector()
                	break
                default:
            }
			            
        }
        
        protected function repositionFromModelConnector():void
        {
        	var p:Point = new Point()
        	
        	_lineModel.x = _fromModel.x
        	_lineModel.y = _fromModel.y
        	_lineModel.startX = 0
        	_lineModel.startY = 0
        	
        }
        
		protected function onToModelChange(event:PropertyChangeEvent):void
        {
            switch( event.property )
            {
                case "x":
                case "y":
                case "width":
                case "height":
                	repositionToModelConnector()
                	break
                default:
            }                             
        }
        
        protected function repositionToModelConnector():void
        {
        	_lineModel.endX = _toModel.x - _fromModel.x
        	_lineModel.endY = _toModel.y - _fromModel.y
        }
				

		//Getters and setters

		public function get fromModel():SDObjectModel
		{
			return _fromModel;
		}

		public function set fromModel(v:SDObjectModel):void
		{
			_fromModel = v;
			repositionFromModelConnector()
			repositionToModelConnector()
		}

		public function get toModel():SDObjectModel
		{
			return _toModel;
		}

		public function set toModel(v:SDObjectModel):void
		{
			_toModel = v;
			repositionFromModelConnector()
			repositionToModelConnector()
		}
						
		public function destroy():void
		{
            _fromModel.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onFromModelChange );
            _toModel.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onToModelChange);
            _fromModel = null
            _toModel = null
            _lineModel = null
		}


	

		
		
	}
}