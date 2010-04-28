package com.simplediagrams.view.components
{
    
    import mx.controls.ComboBox;
    import mx.controls.Image;

    /**
    * Adapted from code by Greg Jastrab
    * 
     * ComboBox extended to allow an Image to appear when collapsed.
     * 
     * @langversion ActionScript 3.0
     * @author Greg Jastrab &lt;greg&#64;smartlogicsolutions.com&gt;
     * @date 11/26/08
     * @version 1.0
     */
    public class ImageComboBox extends ComboBox 
    {
        
        
        protected var image:Image;
       
        protected var imageMeasuredWidth:Number;
        
        protected var imageMeasuredHeight:Number;
              
        override protected function createChildren():void 
        {
            super.createChildren();
            
            if(!image) 
            {
                image = new Image();
                image.focusEnabled = false;                
                addChild(image);
            }
        }
        
        override protected function measure():void 
        {
        	super.measure();
        	
        	imageMeasuredHeight = getExplicitOrMeasuredHeight() - getStyle("paddingTop") - getStyle("paddingBottom");
            imageMeasuredWidth  = getExplicitOrMeasuredWidth() - getStyle("paddingLeft") - getStyle("paddingRight") - getStyle("arrowButtonWidth");
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {
        	
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if(selectedItem) 
            {
            	image.source = selectedItem.lineImage;
                
                // TODO: include text placement here
                var leftPadding:Number = getStyle("paddingLeft");
                
                image.setActualSize(imageMeasuredWidth, imageMeasuredHeight);
                image.move(leftPadding, (unscaledHeight - imageMeasuredHeight) / 2);
                
            }
        }
        
        
    }
    
}