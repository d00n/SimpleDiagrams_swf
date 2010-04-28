package com.simplediagrams.view.components
{
	import com.simplediagrams.model.ConnectorModel;
	
	import flash.display.Graphics;
	
	import mx.core.UIComponent;

	public class ConnectorComponent extends UIComponent
	{				
						
		private var _objectModel:ConnectorModel
		
		public function SDLineConnectorComponent()
		{
		}
		
		public override function set objectModel(model:ConnectorModel):void
		{
			if (_objectModel)
			{
				_objectModel.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange)
			}
			_objectModel = model
						 
            redraw();
            
            x = _model.x;
            y = _model.y;            
            
		}
		
		public override function get objectModel():SDObjectModel
        {
        	return _objectModel
        }
	
		protected function redraw():void
		{
			var g:Graphics = this.graphics
			g.moveTo(0,0)
			g.
		}
		
		override public function destroy():void
		{
			_model = null
		}
		
	}
}