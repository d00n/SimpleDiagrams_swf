package com.simplediagrams.util
{
	
	//this code is derived from http://www.iloveflex.com/dragpanel/
	
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.containers.TitleWindow;
    import mx.core.SpriteAsset;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    

	[Event(name="panelMinimized",type="flash.events.Event")]
	[Event(name="panelRestored",type="flash.events.Event")]
	[Event(name="panelClosed",type="flash.events.Event")]
	
	

    public class DragPanel extends TitleWindow
    {
    	
    	
        // Add the creationCOmplete event handler.
        public function DragPanel()
        {
            super();
       		isPopUp = true;
        	addEventListener(Event.CLOSE,closeHandler);
            addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            this.showCloseButton = true
            
        }
        
        private function closeHandler(event:Event):void
    	{
        	//DMcQ: launch event to tell panels like movie view to close up
            var e:Event = new Event("panelMinimized")
            dispatchEvent(e)
            
            //clear out any handlers that are hanging around
            stopResizePanel(new MouseEvent(MouseEvent.MOUSE_MOVE))
             
        	PopUpManager.removePopUp(this)
        	event.stopPropagation();
        	
    	}
        
        private var myTitleBar:UIComponent;
                    
        private function creationCompleteHandler(event:Event):void
        {
            myTitleBar = titleBar;            
            // Add the resizing event handler.    
            addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
            //myTitleBar.addEventListener(MouseEvent.MOUSE_DOWN, tbMouseDownHandler);
            //myTitleBar.addEventListener(MouseEvent.MOUSE_UP, tbMouseUpHandler);
            titleBar.styleName="glassLabels"
            
            
            
        }
        
        private var xOff:Number;
        private var yOff:Number;
            
        private function tbMouseDownHandler(event:MouseEvent):void {
            
                xOff = event.currentTarget.mouseX;
                yOff = event.currentTarget.mouseY;
                parent.addEventListener(MouseEvent.MOUSE_MOVE, tbMouseMoveHandler);
                parent.setChildIndex(this,parent.numChildren-1); 
                
            }
            
       private function tbMouseMoveHandler(event:MouseEvent):void {
            
            // Compensate for the mouse pointer's location in the title bar.
            
            var tempX:int = parent.mouseX - xOff;
            x = tempX;
            
            var tempY:int = parent.mouseY - yOff;
            y = tempY;    
                    
        }
        
        private function tbMouseUpHandler(event:MouseEvent):void 
        {
        	try
        	{
        		parent.removeEventListener(MouseEvent.MOUSE_MOVE, tbMouseMoveHandler);
        	}
            catch(e:Error)
            {
            	Logger.error("#DragPanel: tbMouseUpHandler() error: "  + e.message )
            } 
        }
        
        protected var minShape:SpriteAsset;
        protected var restoreShape:SpriteAsset;
        protected var closeShape:SpriteAsset;

        override protected function createChildren():void
        {
            super.createChildren();
            
            // Create the SpriteAsset's for the min/restore icons and 
            // add the event handlers for them.
            /*
            minShape = new icoMin();
            minShape.addEventListener(MouseEvent.MOUSE_DOWN, minPanelSizeHandler);
            titleBar.(minShape);

            restoreShape = new icoMax();
            restoreShape.addEventListener(MouseEvent.MOUSE_DOWN, restorePanelSizeHandler);
            titleBar.addChild(restoreShape);
            */
        }
            
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
                        
			// Draw resize graphics if not minimzed.                
            graphics.clear()
            if (isMinimized == false)
            {
                graphics.lineStyle(2);
                graphics.moveTo(unscaledWidth - 6, unscaledHeight - 1)
                graphics.curveTo(unscaledWidth - 3, unscaledHeight - 3, unscaledWidth - 1, unscaledHeight - 6);                        
                graphics.moveTo(unscaledWidth - 6, unscaledHeight - 4)
                graphics.curveTo(unscaledWidth - 5, unscaledHeight - 5, unscaledWidth - 4, unscaledHeight - 6);                        
            }
        }
        
        private var myRestoreHeight:int;
        private var isMinimized:Boolean = false; 
                    
        // Minimize panel event handler.
        /*
        private function minPanelSizeHandler(event:Event):void
        {
            if (isMinimized != true)
            {
                myRestoreHeight = height;    
                height = titleBar.height;
                isMinimized = true;    
                // Don't allow resizing when in the minimized state.
                removeEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
                //DMcQ: launch event
                var e:Event = new Event("panelMinimized")
                dispatchEvent(e)
                
            }                
        }
        */
        
        // Restore panel event handler.
        /*
        private function restorePanelSizeHandler(event:Event):void
        {
            if (isMinimized == true)
            {
                height = myRestoreHeight;
                isMinimized = false;    
                // Allow resizing in restored state.                
                addEventListener(MouseEvent.MOUSE_DOWN, resizeHandler);
            	//DMcQ: launch event
            	var e:Event = new Event("panelRestored")
            	dispatchEvent(e)
            }
        }
		*/
		
        // Define static constant for event type.
        //public static const RESIZE_CLICK:String = "resizeClick";

        // Resize panel event handler.
        private var origWidth:int;
        private var origHeight:int;
        
        public  function resizeHandler(event:MouseEvent):void
        {
            // Determine if the mouse pointer is in the lower right 7x7 pixel
            // area of the panel. Initiate the resize if so.
            
            // Lower left corner of panel
            var lowerLeftX:Number = x + width; 
            var lowerLeftY:Number = y + height;
                
            // Upper left corner of 7x7 hit area
            var upperLeftX:Number = lowerLeftX-7;
            var upperLeftY:Number = lowerLeftY-7;
                
            // Mouse positionin Canvas
            var panelRelX:Number = event.localX + x;
            var panelRelY:Number = event.localY + y;

            // See if the mousedown is in the lower right 7x7 pixel area
            // of the panel.
            if (upperLeftX <= panelRelX && panelRelX <= lowerLeftX)
            {
                if (upperLeftY <= panelRelY && panelRelY <= lowerLeftY)
                {    
                
                    
                    event.stopPropagation();        
                    
                    origWidth = width;
                    origHeight = height;
                    xOff = parent.mouseX;
                    yOff = parent.mouseY;
                    parent.addEventListener(MouseEvent.MOUSE_MOVE, resizePanel);
                    parent.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
                    
                }
            }                
        }
        
        private function resizePanel(event:MouseEvent):void {
            
            if ((origWidth + (parent.mouseX - xOff)) > 250){
                width = origWidth + (parent.mouseX - xOff);    
            }
            
            if ((origHeight + (parent.mouseY - yOff)) > titleBar.height){
                height = origHeight + (parent.mouseY - yOff);
            }
                    
        }
        
        private function stopResizePanel(event:MouseEvent):void {
        	try
        	{
        		parent.removeEventListener(MouseEvent.MOUSE_MOVE, resizePanel);
        	}
            catch(e:Error)
            {
            	//do nothing...not sure why this error starts happening...
            }
        }	
        
                
    }
}