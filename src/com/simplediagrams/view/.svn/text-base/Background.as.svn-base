package com.simplediagrams.view
{
	import com.simplediagrams.events.LoadDiagramEvent;
	import com.simplediagrams.events.StyleEvent;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.DiagramStyleManager;
	import com.simplediagrams.events.PropertiesEvent
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.skins.backgroundSkins.*;
	
	import flash.events.Event;
	
	import mx.styles.StyleManager;
	
	import org.swizframework.Swiz;
	
	import spark.components.supportClasses.SkinnableComponent;


	[SkinState("normal")]
	[SkinState("disabled")]
	[Bindable]
	public class Background extends SkinnableComponent 
	{		
		
		public var diagramModel:DiagramModel
		
		public var fillColor:Number = 0xFFFFFF;
				
		public function Background()
		{
			super();
			
			diagramModel = Swiz.getBean("diagramModel") as DiagramModel
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			
			this.setStyle("skinClass",Class(ChalkboardSkin))
			Swiz.addEventListener(StyleEvent.STYLE_CHANGED, onStyleChange)
			Swiz.addEventListener(LoadDiagramEvent.DIAGRAM_LOADED, onDiagramLoaded)
			Swiz.addEventListener(PropertiesEvent.PROPERTIES_EDITED, onDiagramPropertiesEdited)
		}
		
		protected function onDiagramPropertiesEdited(event:Event):void
		{
			fillColor = diagramModel.baseBackgroundColor			
		}
				
		protected function onDiagramLoaded(event:Event):void
		{
			fillColor = diagramModel.baseBackgroundColor	
		    
		}
				
		
		protected function onAddedToStage(event:Event):void
		{
			var diagramStyleManager:DiagramStyleManager = Swiz.getBean("diagramStyleManager") as DiagramStyleManager
			setBackgroundStyle(diagramStyleManager.currStyle)
		}			
				
		protected function onStyleChange(event:StyleEvent):void
		{
			Logger.debug("changing style to : " + event.styleName, this)
			setBackgroundStyle(event.styleName)
		}
		
		protected function setBackgroundStyle(styleName:String):void
		{
			switch(styleName)
			{
				case DiagramStyleManager.CHALKBOARD_STYLE:
					this.setStyle("skinClass",Class(ChalkboardSkin))
					break
				
				case DiagramStyleManager.WHITEBOARD_STYLE:
					this.setStyle("skinClass",Class(WhiteboardSkin))				
					break
										
				case DiagramStyleManager.BASIC_STYLE:
					Logger.debug("setting fill Color to : " + fillColor, this)				
					fillColor = diagramModel.baseBackgroundColor
					this.setStyle("skinClass",Class(BasicSkin))					
					break
					
			}
		}
	
		
		
	}
}