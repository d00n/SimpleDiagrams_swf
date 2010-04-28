package com.simplediagrams.model
{;
	import com.roguedevelopment.objecthandles.*;
	import com.simplediagrams.events.SelectionEvent;
	import com.simplediagrams.view.SDComponents.SDLine;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	import mx.events.PropertyChangeEvent;
	import mx.events.ScrollEvent;
	
	import spark.components.Group;
	

	public class SDObjectHandles extends ObjectHandles
	{

		[Autowire]
		public var undoRedoManager:UndoRedoManager
		
		
		//public var objectConnectors:ObjectConnectors 
		
		public function SDObjectHandles( selectionManager:ObjectHandlesSelectionManager = null, handleFactory:IFactory = null)
		{
			//we pass in a blank sprite here since we'll set the container explicitly later on
			super(new Group(), selectionManager, handleFactory)	
		}
		
		public function setContainer(s:Group):void
		{
			if (container)
			{
            	container.removeEventListener( ScrollEvent.SCROLL, onContainerScroll );
			}
			container = s
			container.addEventListener( ScrollEvent.SCROLL, onContainerScroll );
		}
		
		/* Making a separate group to hold the handles so the don't get in the way of re-ordering the actual SD objects*/
		public function setHandlesContainer(s:Group):void
		{
				handlesContainer = s
		}
		
		/** Overriding object handles registerComponent so we can apply some standard settings for different types of SDObjects */
		
		override public function registerComponent(dataModel:Object, visualDisplay:EventDispatcher, handleDescriptions:Array=null, captureKeyEvents:Boolean=true) : void
		{
			if (visualDisplay is SDLine)
			{
				handleDescriptions = []
			}									
			super.registerComponent(dataModel, visualDisplay, handleDescriptions, captureKeyEvents)				
		}
				
				
		public function unregisterComponentByModel( dataModel:Object ) : EventDispatcher
		{			
			var visualDisplay:EventDispatcher = visuals[dataModel]
			if( !visualDisplay) return null 
				
		    visualDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, onComponentMouseDown);
			visualDisplay.removeEventListener( SelectionEvent.SELECTED, handleSelection );
			visualDisplay.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			dataModel.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			
			delete visuals[dataModel]
			delete models[visualDisplay]
			
			return visualDisplay
		}
		
				
        
        public function removeAll():void
		{
			selectionManager.clearSelection()			
			//clear out all objects currently registered in ObjectHandles
			for each (var obj:EventDispatcher in this.visuals)
			{
				this.unregisterComponent(obj)
			}			
		}
		
		
		
		
	}
}