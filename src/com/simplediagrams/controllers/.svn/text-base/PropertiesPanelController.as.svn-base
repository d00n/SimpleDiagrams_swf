package com.simplediagrams.controllers
{
	
	import com.simplediagrams.commands.ChangeLineStyleCommand;
	import com.simplediagrams.events.LineStyleEvent;
	import com.simplediagrams.events.MultiSelectEvent;
	import com.simplediagrams.events.SelectionEvent;
	import com.simplediagrams.events.TextPropertyChangeEvent;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.PropertiesPanelModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.model.SettingsModel;
	import com.simplediagrams.model.UndoRedoManager;
	import com.simplediagrams.util.Logger;
	
	import flash.events.Event;
	
	import org.swizframework.controller.AbstractController;

	public class PropertiesPanelController extends AbstractController
	{
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel
		
		[Autowire(bean="settingsModel")]
		public var settingsModel:SettingsModel
		
		[Autowire(bean="propertiesPanelModel")]
		public var propertiesPanelModel:PropertiesPanelModel
		
		[Autowire(bean="undoRedoManager")]
		public var undoRedoManager:UndoRedoManager
		
		public function PropertiesPanelController()
		{
		}
		
		  		
  		/* Watch which objects are selected within ObjectHandles so we know what properties panel to show */
  		    		 		
  		[Mediate(event="SelectionEvent.ADDED_TO_SELECTION")]
  		public function onAddedToSelection(event:SelectionEvent):void
  		{
  			setPropertiesPanel()
  		}
  		
  		
  		[Mediate(event="SelectionEvent.REMOVED_FROM_SELECTION")]
  		public function onRemovedFromSelection(event:SelectionEvent):void
  		{
  			setPropertiesPanel()
  		}
  		
  		[Mediate(event="SelectionEvent.SELECTION_CLEARED")]
  		public function onSelectionCleared(event:SelectionEvent):void
  		{
  			propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_NONE
  		}	
		
		[Mediate(event="MultiSelectEvent.DRAG_MULTI_SELECTION_FINISHED")]
		public function onSelectionChanged(event:MultiSelectEvent):void
		{
			setPropertiesPanel()
		}	
		
		
  		
  		protected function setPropertiesPanel():void
  		{
  			var selectedArr:Array = diagramModel.selectedArray		
  			
  			if (selectedArr.length==0) 
  			{  				
  				propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_NONE  
  				return
  			}
			
			if (selectedArr.length==1)
			{				
				if (selectedArr[0] is SDSymbolModel) 
				{
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_SYMBOL
					return
				}
				else if (selectedArr[0] is SDTextAreaModel)
				{
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_TEXT
					return					
				}
				else if (selectedArr[0] is SDLineModel)
				{					
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_LINE 
					return
				}
			}
  			
  			var allText:Boolean = true
  			var allLines:Boolean = true  
			var allSymbols:Boolean = true  			
  			for each (var obj:Object in selectedArr)
  			{
  				if (obj is SDTextAreaModel == false)
  				{
  					allText = false
  				}
  				if (obj is SDLineModel == false)
  				{
  					allLines = false
  				}
				if (obj is SDSymbolModel == false)
				{
					allSymbols = false
				}
  			}	
  				
			
  			if (allText)
  			{
				if (propertiesPanelModel.viewing == PropertiesPanelModel.PROPERTIES_TEXT)
				{
					propertiesPanelModel.dispatchEvent(new Event(PropertiesPanelModel.SELECTION_CHANGED))
				}
				else
				{
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_TEXT
				}
  				
  			}
  			else if (allLines)
  			{
				if (propertiesPanelModel.viewing == PropertiesPanelModel.PROPERTIES_LINE)
				{
					propertiesPanelModel.dispatchEvent(new Event(PropertiesPanelModel.SELECTION_CHANGED))
				}
				else
				{
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_LINE
				}			
  			}
			else if (allSymbols)
			{
				if (propertiesPanelModel.viewing == PropertiesPanelModel.PROPERTIES_SYMBOL)
				{
					propertiesPanelModel.dispatchEvent(new Event(PropertiesPanelModel.SELECTION_CHANGED))
				}
				else
				{
					propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_SYMBOL
				}						
			}
  			else
  			{
  				propertiesPanelModel.viewing = PropertiesPanelModel.PROPERTIES_NONE  	
  			}
  		}
  		
  		
  		protected function clearPropertiesPanel():void
  		{
  			
  		}
  		
  		
  		[Mediate(event="TextPropertyChangeEvent.CHANGE_FONT_SIZE")]
  		public function onFontSizeChange(event:TextPropertyChangeEvent):void
  		{
  			var selectedArr:Array = diagramModel.selectedArray		
  			
  			for each (var obj:Object in selectedArr)
  			{
  				if (obj is SDTextAreaModel)
  				{
  					SDTextAreaModel(obj).fontSize = event.fontSize
  				}
				else if (obj is SDSymbolModel)
				{
					SDSymbolModel(obj).fontSize = event.fontSize
				}
  			}
			
			settingsModel.defaultFontSize = event.fontSize
				
  		}
		
		[Mediate(event="TextPropertyChangeEvent.CHANGE_FONT_WEIGHT")]
		public function onChangeFontWeight(event:TextPropertyChangeEvent):void
		{
			var selectedArr:Array = diagramModel.selectedArray		
			
			for each (var obj:Object in selectedArr)
			{
				if (obj is SDTextAreaModel)
				{
					SDTextAreaModel(obj).fontWeight = event.fontWeight
				}
				else if (obj is SDSymbolModel)
				{
					SDSymbolModel(obj).fontWeight = event.fontWeight
				}
			}
			
			settingsModel.defaultFontWeight = event.fontWeight
			
		}
		
		[Mediate(event="TextPropertyChangeEvent.CHANGE_TEXT_ALIGN")]
		public function onTextAlignChange(event:TextPropertyChangeEvent):void
		{
			var selectedArr:Array = diagramModel.selectedArray		
			
			for each (var obj:Object in selectedArr)
			{
				if (obj is SDTextAreaModel)
				{
					SDTextAreaModel(obj).textAlign = event.textAlign
				}
				else if (obj is SDSymbolModel)
				{
					SDSymbolModel(obj).textAlign = event.textAlign
				}
			}
			
			settingsModel.defaultTextAlign=event.textAlign
			
		}
		
		[Mediate(event="TextPropertyChangeEvent.CHANGE_TEXT_POSITION")]
		public function onTextPositionChange(event:TextPropertyChangeEvent):void
		{
			var selectedArr:Array = diagramModel.selectedArray		
			
				
			for each (var obj:Object in selectedArr)
			{
				if (obj is SDSymbolModel)
				{
					SDSymbolModel(obj).textPosition = event.textPosition
				}
			}
			
			settingsModel.defaultTextPosition=event.textPosition
			
		}
		
		
  		
  		[Mediate(event="LineStyleEvent.LINE_START_STYLE_CHANGE")]
  		public function onLineStartStyleChange(event:LineStyleEvent):void
  		{  			
			Logger.debug("onLineStartStyleChange() setting startLineStyle to: " + event.lineStyle,this)
			var cmd:ChangeLineStyleCommand = new ChangeLineStyleCommand(diagramModel)	
			cmd.startLineStyle = event.lineStyle
			cmd.execute()
			undoRedoManager.push(cmd)	
  			
			settingsModel.defaultStartLineStyle = event.lineStyle
  		
  		}
  		
  		[Mediate(event="LineStyleEvent.LINE_END_STYLE_CHANGE")]
  		public function onLineEndStyleChange(event:LineStyleEvent):void
  		{			
			var cmd:ChangeLineStyleCommand = new ChangeLineStyleCommand(diagramModel)
			cmd.endLineStyle = event.lineStyle
			cmd.execute()
			undoRedoManager.push(cmd)	
  			  			
			settingsModel.defaultEndLineStyle = event.lineStyle  		
  		}
  		
  		
  		[Mediate(event="LineStyleEvent.LINE_WEIGHT_CHANGE")]
  		public function onLineWeightChange(event:LineStyleEvent):void
  		{
			var cmd:ChangeLineStyleCommand = new ChangeLineStyleCommand(diagramModel)	
			cmd.lineWeight = event.lineWeight
			cmd.execute()
			undoRedoManager.push(cmd)	
  		
			settingsModel.defaultLineWeight = event.lineWeight
  		}
  
		
	}
}