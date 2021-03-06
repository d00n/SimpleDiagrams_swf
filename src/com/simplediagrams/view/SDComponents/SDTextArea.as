package com.simplediagrams.view.SDComponents
{
	
	import com.simplediagrams.controllers.DiagramController;
	import com.simplediagrams.controllers.RemoteSharedObjectController;
	import com.simplediagrams.events.RemoteSharedObjectEvent;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.util.Logger;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.*;
	import mx.controls.Image;
	import mx.events.PropertyChangeEvent;
	
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;
	
	import spark.components.TextArea;
	import spark.effects.RemoveAction;
	import spark.events.TextOperationEvent;
	

	[SkinState("normal")] 
	[SkinState("selected")] 
	[Bindable]
	public class SDTextArea extends SDBase implements ISDComponent
	{

		[SkinPart(required="true")]		
		public var mainTextArea:TextArea;
		
		[SkinPart(required="false")]		
		public var backgroundImage:Image;
		
		
		public var text:String
		public var fontColor:Number
		public var fontWeight:String
		public var fontSize:Number
		public var textAlign:String
		
		protected var _cwTextArea:ChangeWatcher
		protected var _model:SDTextAreaModel;
						
		public function SDTextArea()
		{
			this.setStyle("skinClass", Class(SDTextAreaBasicSkin))  
		}
	    
        public function set objectModel( objectModel:SDObjectModel ) : void
        {     
            _model = SDTextAreaModel(objectModel) 
            
            x = _model.x;
            y = _model.y;            
            
            width= _model.width;
            height= _model.height;
   			text = _model.text			
            fontColor = _model.color
			fontWeight = _model.fontWeight
            fontSize = _model.fontSize
            textAlign = _model.textAlign
            setSkinStyle()
			this.depth = _model.depth;
            
            _model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
        			        
        }
        
        protected override function getCurrentSkinState():String
    	{
      		if (_model && _model.selected)
      		{
      			return "selected"
      		}
      		else
      		{
      			return "normal"
      		}
     	}
     
      	override public function get objectModel():SDObjectModel
        {
        	return _model
        }
	
  
        
        override protected function onModelChange(event:PropertyChangeEvent):void
		{
			Logger.info("onModelChange event.property=" + event.property,this);
			
			super.onModelChange(event)
				
			switch(event.property)
			{    
								
    			case "selected":    			
    				
					
					if (event.newValue==false)
    				{
    				} 
					
    				this.invalidateSkinState()
    				break
    			
    			case "fontSize":
    				this.fontSize = Number(event.newValue)
    				break
    				
    			case "color":
    				this.fontColor = Number(event.newValue)
    				break
    			
				case "textAlign":
					this.textAlign = String(event.newValue)
					break
				
				case "fontWeight":
					this.fontWeight = String(event.newValue)
					break
				
    			case "skinStyle":
    				setSkinStyle()    				
    				break
				
    				
    			case "text":
    				text = String(event.newValue)
    				this.invalidateProperties()
    				
			}
                    
        }
      
        
        /* Set a skin based on the style defined in the model */
        protected function setSkinStyle():void
        {
        	switch(_model.styleName)
        	{
        		case SDTextAreaModel.NO_BACKGROUND:
        			this.setStyle("skinClass", Class(SDTextAreaBasicSkin))
        			break
        		
        		case SDTextAreaModel.PAPER_WITH_TAPE:
        			this.setStyle("skinClass", Class(SDTextAreaPaperWithTapeSkin))
        			break
        		
        		case SDTextAreaModel.STICKY_NOTE:
        			this.setStyle("skinClass", Class(SDTextAreaStickyNoteSkin))
        			break
        			
        		case SDTextAreaModel.INDEX_CARD:
        			this.setStyle("skinClass", Class(SDTextAreaIndexCardSkin))
        			break
        			
        		default:
        			Logger.warn("setSkinStyle() unrecognized style :  " + _model.styleName, this)
        	}
        	this.invalidateSkinState()
        	this.invalidateDisplayList()
        	
        	
        }
        
        protected function onTextAreaMouseDown(event:MouseEvent):void
	    { 
			this.invalidateSkinState()
		    event.stopPropagation()    // this allows us to drag to select within the text area without having objecthandles think we want to drag the component!
	    }

        
        
        override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);		 
			
			if( instance == mainTextArea )
			{   
				
				mainTextArea.addEventListener(TextOperationEvent.CHANGE, onTextAreaChange, false, 0, true)				
				mainTextArea.addEventListener(MouseEvent.MOUSE_DOWN, onTextAreaMouseDown, false, 0, true)			
				mainTextArea.addEventListener(MouseEvent.ROLL_OUT, onTextAreaMouseOut, false, 0, true)		
				mainTextArea.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
				if (focusManager)
					focusManager.setFocus(mainTextArea)
			
				if (this.text!="")
					mainTextArea.setStyle("borderVisible", false)
			}	
			else if(instance == backgroundImage)
			{
				backgroundImage.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundClick, false, 0, true)	
			}
				
        }
		
		protected function onFocusOut(event:Event):void
		{
			Logger.info("onTextAreaMouseOut",this);
		}
		
		protected function onTextAreaChange(event:Event):void
		{
			_model.text = mainTextArea.text;
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.DISPATCH_TEXT_AREA_CHANGE);
			rsoEvent.sdID = this.sdID;
			rsoEvent.text = this.text;
			dispatchEvent(rsoEvent);
		}

		protected function onTextAreaMouseOut(event:Event):void
		{
			/*
			if (mainTextArea.focusManager)
			{
				mainTextArea.focusManager.deactivate()
			}
			*/
			
		}
		
		protected function onBackgroundClick(event:Event):void
		{
			Logger.debug("onBackgroundClick!", this)
		}
       
        
        
		public override function destroy():void
		{
			super.destroy()
			mainTextArea.removeEventListener(Event.CHANGE, onTextAreaChange)				
			mainTextArea.removeEventListener(MouseEvent.MOUSE_DOWN, onTextAreaMouseDown)	
			mainTextArea.removeEventListener(MouseEvent.MOUSE_OUT, onTextAreaMouseOut)	
			mainTextArea.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
            _model.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			if (backgroundImage) backgroundImage.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundClick)	
			_model = null
		}
	}
}