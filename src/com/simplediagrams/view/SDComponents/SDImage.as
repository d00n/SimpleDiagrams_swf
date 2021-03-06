package com.simplediagrams.view.SDComponents
{
	
	import com.simplediagrams.events.LoadImageEvent;
	import com.simplediagrams.model.SDImageModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.events.PropertyChangeEvent;

	[SkinState("normal")]
	[SkinState("selected")]
	[Bindable]	
	public class SDImage extends SDBase implements ISDComponent
	{	
					
		private var _model:SDImageModel
		
		public var imageData:ByteArray		
		
		[SkinPart(required="true")]		
		public var imageHolder:Image;
				
		public function SDImage()
		{
			super();
			this.setStyle("skinClass", Class(SDImageSkin))
		}
		
		protected function onImageLoaded(event:Event):void
		{
			_model.origWidth = imageHolder.content.width
			_model.origHeight = imageHolder.content.height
		}
	
		public function onAddImageClick():void
		{
			Logger.debug("onAddImageClick()", this)
			var evt:LoadImageEvent = new LoadImageEvent(LoadImageEvent.BROWSE_FOR_IMAGE, true)
			evt.model = _model
			dispatchEvent(evt)
		}
		
		public function set objectModel(objectModel:SDObjectModel):void
		{
			Logger.debug("set model() model: " + objectModel, this)         
            _model = SDImageModel(objectModel)
            
            //redraw();
            x = _model.x;
            y = _model.y;         
			this.width = _model.width
			this.height = _model.height  
			this.rotation = _model.rotation
			this.imageData = _model.imageData
			this.depth = _model.depth;
            
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
				
				case "imageData":
					Logger.debug("imageData changed", this)
					imageData = _model.imageData
					this.invalidateProperties()
					break
							
			}
			
			
		}        
       
       override protected function partAdded(partName:String, instance:Object) : void
       {
       		super.partAdded(partName, instance)
       		
       		if (instance == imageHolder)
       		{
       			imageHolder.addEventListener(Event.COMPLETE, onImageLoaded)
       		}
       	
       }
        
        																	
		public override function destroy():void
		{
			super.destroy()
			_model = null
		}
		
		
		
	}
}