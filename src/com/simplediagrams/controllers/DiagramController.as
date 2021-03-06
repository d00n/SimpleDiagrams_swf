package com.simplediagrams.controllers
{
	
	import com.simplediagrams.business.FileManager;
	import com.simplediagrams.commands.AddImageItem;
	import com.simplediagrams.commands.AddLibraryItemCommand;
	import com.simplediagrams.commands.AddLineCommand;
	import com.simplediagrams.commands.AddPencilDrawingCommand;
	import com.simplediagrams.commands.AddTextAreaCommand;
	import com.simplediagrams.commands.AddTextWidgetCommand;
	import com.simplediagrams.commands.ChangeColorCommand;
	import com.simplediagrams.commands.ChangeLinePositionCommand;
	import com.simplediagrams.commands.DeleteSDObjectModelCommand;
	import com.simplediagrams.commands.DeleteSelectedSDObjectModelsCommand;
	import com.simplediagrams.commands.TransformCommand;
	import com.simplediagrams.events.*;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.SDImageModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.model.SettingsModel;
	import com.simplediagrams.model.UndoRedoManager;
	import com.simplediagrams.model.mementos.SDLineMemento;
	import com.simplediagrams.model.mementos.TransformMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.SDBase;
	import com.simplediagrams.view.dialogs.DiagramPropertiesDialog;
	
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.operations.RedoOperation;
	
	import mx.core.UIComponent;
	import mx.graphics.codec.PNGEncoder;
	
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;

	public class DiagramController extends AbstractController 
	{
		
		public function DiagramController()
		{			
		}
		
		[Autowire(bean='diagramModel')]
		public var diagramModel:DiagramModel
		
		[Autowire(bean='libraryManager')]
		public var libraryManager:LibraryManager
		
		[Autowire(bean='fileManager')]
		public var fileManager:FileManager
		
		[Autowire(bean='undoRedoManager')]
		public var undoRedoManager:UndoRedoManager
		
		[Autowire(bean='settingsModel')]
		public var settingsModel:SettingsModel
		
		[Autowire(bean='dialogsController')]
		public var dialogsController:DialogsController	

		[Autowire(bean="remoteSharedObjectController")]
		public var remoteSharedObjectController:RemoteSharedObjectController
		
		private var imageByteArray:ByteArray		
		private var _diagramPropertiesDialog:DiagramPropertiesDialog
		
		
		[Mediate(event='LoadDiagramEvent.DIAGRAM_BUILT')]
		public function diagramBuilt(event:Event):void
		{
			dialogsController.removeDialog()
			
		}
			
		
		
		[Mediate(event='DrawingBoardItemDroppedEvent.LIBRARY_ITEM_ADDED')]
		public function onLibraryItemAdded(event:DrawingBoardItemDroppedEvent):void
		{
			Logger.debug("item added. symbolName: " + event.symbolName +" libraryName: " + event.libraryName, this)
						
			returnToPointerTool()
			
			var cmd:AddLibraryItemCommand = new AddLibraryItemCommand(diagramModel, libraryManager, event.libraryName, event.symbolName)			
			cmd.x = event.dropX
			cmd.y = event.dropY
			cmd.textAlign = settingsModel.defaultTextAlign
			cmd.fontSize = settingsModel.defaultFontSize
			cmd.fontWeight = settingsModel.defaultFontWeight
			cmd.textPosition = settingsModel.defaultTextPosition;
			cmd.color = diagramModel.getColor();
				
			cmd.execute()
			undoRedoManager.push(cmd)		
				
//			remoteSharedObjectController.dispatchUpdate_AddLibraryItemCommand(cmd)
		}
		
		
		
		
		
		[Mediate(event='DrawingBoardItemDroppedEvent.IMAGE_ITEM_ADDED')]
		public function onImageItemAdded(event:DrawingBoardItemDroppedEvent):void
		{
			Logger.debug("image item added.", this)
			returnToPointerTool()						
			var cmd:AddImageItem = new AddImageItem(diagramModel)
			cmd.x = event.dropX
			cmd.y = event.dropY
			cmd.execute()
			undoRedoManager.push(cmd)			
		}
		
		
		
		/*
		[Mediate(event='PictureCreatedEvent.CREATED')]
		public function onPictureCreated(event:PictureCreatedEvent):void
		{
			Logger.debug("onPictureCreated()" , this)
			
			var objModel:SDImageModel = new SDImageModel()
			objModel.x = event.dropX
			objModel.y = event.dropY
			diagramModel.addSDObjectModel(objModel)		
		}
		
		
		[Mediate(event='DrawingBoardItemDroppedEvent.LINE_ITEM_ADDED')]
		public function onLineItemAdded(event:DrawingBoardItemDroppedEvent):void
		{			
			returnToPointerTool()
			var cmd:AddImageItem = new AddImageItem(diagramModel)
			var newObjModel:SDLineModel = new SDLineModel()
			newObjModel.x = event.dropX
			newObjModel.y = event.dropY
			newObjModel.endX = 100
			newObjModel.endY = 100
			newObjModel.bendX = 50
			newObjModel.bendY = 50
			
			newObjModel.init()
			diagramModel.addSDObjectModel(newObjModel)
						
		}
		
		[Mediate(event='DrawingBoardItemDroppedEvent.NAPKIN_ADDED')]
		public function onNapkinItemAdded(event:DrawingBoardItemDroppedEvent):void
		{
		Logger.debug("item added. symbolName: " + event.symbolName +" libraryName: " + event.libraryName, this)
		
		returnToPointerTool()
		
		var newSymbolModel:SDSymbolModel = new SDSymbolModel("Napkin", 50, 50)
		newSymbolModel.x = event.dropX
		newSymbolModel.y = event.dropY
		newSymbolModel.textAlign = settingsModel.defaultTextAlign
		newSymbolModel.fontSize = settingsModel.defaultFontSize
		newSymbolModel.fontWeight = settingsModel.defaultFontWeight
		newSymbolModel.textPosition = settingsModel.defaultTextPosition
		diagramModel.addSDObjectModel(newSymbolModel)
		UIComponent(newSymbolModel.sdComponent).focusManager.getFocus()
		SDSymbol(newSymbolModel.sdComponent).setStyle("skinClass", SDNapkinSkin)
		SDSymbol(newSymbolModel.sdComponent).invalidateSkinState()
		
		
		}
		
		
		
		*/
		
		
		[Mediate(event='DrawingBoardItemDroppedEvent.STICKY_NOTE_ADDED')]
		[Mediate(event='DrawingBoardItemDroppedEvent.INDEX_CARD_ADDED')]
		public function onTextWidgetAdded(event:DrawingBoardItemDroppedEvent):void
		{			
			returnToPointerTool()
			var cmd:AddTextWidgetCommand = new AddTextWidgetCommand(diagramModel)
			cmd.x = event.dropX
			cmd.y = event.dropY
			switch(event.type)
			{
				case DrawingBoardItemDroppedEvent.STICKY_NOTE_ADDED:
					cmd.styleName = SDTextAreaModel.STICKY_NOTE
					cmd.maintainProportion = true
					break
			
				case DrawingBoardItemDroppedEvent.INDEX_CARD_ADDED:					
					cmd.styleName = SDTextAreaModel.INDEX_CARD
					cmd.maintainProportion = true
					break
				
				default:
					Logger.warn("Unrecognized event type: " + event.type,this)
					
			}
			cmd.execute()			
			undoRedoManager.push(cmd)		
				
//			remoteSharedObjectController.dispatchUpdate_TextWidgetAdded(cmd);
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.TEXT_WIDGET_ADDED);	
			Swiz.dispatchEvent(rsoEvent);				
		}
				
		
		[Mediate(event='TextAreaCreatedEvent.CREATED')]
		public function onTextAreaCreated(event:TextAreaCreatedEvent):void
		{
			Logger.debug("onTextAreaCreated()" , this)			
			returnToPointerTool()			
			var cmd:AddTextAreaCommand = new AddTextAreaCommand(diagramModel)
			cmd.x = event.dropX - 5
			cmd.y = event.dropY - 5
			cmd.width = 120
			cmd.height = 50
			cmd.styleName = SDTextAreaModel.NO_BACKGROUND
			cmd.textAlign = settingsModel.defaultTextAlign
			cmd.fontSize = settingsModel.defaultFontSize
			cmd.fontWeight = settingsModel.defaultFontWeight			
			cmd.execute()		
			undoRedoManager.push(cmd)
			
//			remoteSharedObjectController.dispatchUpdate_TextAreaCreated(cmd);
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.TEXT_WIDGET_CREATED);	
			Swiz.dispatchEvent(rsoEvent);				
		}
		
		
		[Mediate(event='PencilDrawingEvent.DRAWING_CREATED')]
		public function onPencilDrawingCreated(event:PencilDrawingEvent):void
		{
			Logger.debug("onPencilDrawingCreated()  color : " + event.color, this)			
			var cmd:AddPencilDrawingCommand = new AddPencilDrawingCommand(diagramModel)
			cmd.linePath = event.path
			cmd.x = event.initialPoint.x
			cmd.y = event.initialPoint.y
			cmd.width = event.width
			cmd.height = event.height
			cmd.color = event.color
			cmd.execute()		
			undoRedoManager.push(cmd)	
				
//			remoteSharedObjectController.dispatchUpdate_PencilDrawingCreated(cmd);
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.PENCIL_DRAWING_CREATED);	
			Swiz.dispatchEvent(rsoEvent);				
		}
			
		
		[Mediate(event='CreateLineComponentEvent.CREATE')]
		public function onCreateLineComponent(event:CreateLineComponentEvent):void
		{
			Logger.debug("onCreateLineComponent()" , this)						
			returnToPointerTool()
			var cmd:AddLineCommand = new AddLineCommand(diagramModel)				
			cmd.x = event.initialX
			cmd.y = event.initialY
			cmd.endX = event.finalX - event.initialX 
			cmd.endY = event.finalY - event.initialY
			cmd.startLineStyle = settingsModel.defaultStartLineStyle
			cmd.endLineStyle = settingsModel.defaultEndLineStyle
			cmd.lineWeight = settingsModel.defaultLineWeight
			cmd.execute()	
			undoRedoManager.push(cmd)
			Logger.debug("onCreateLineComponent() finished" , this)	
				
//			remoteSharedObjectController.dispatchUpdate_CreateLineComponent(cmd);
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.CREATE_LINE_COMPONENT);	
			Swiz.dispatchEvent(rsoEvent);				
		}
		
		
		[Mediate(event="LoadImageEvent.LOAD_IMAGE_FILE")]
		public function loadImageFromFile(event:LoadImageEvent):void 
		{
			// This needs to used FileReference, or some other strategy
			Logger.debug("loadImageFromFile() DISABLED", this)			
							
//			var file:File = event.file
//			
//			var stream:FileStream = new FileStream()
//			stream.open(file, FileMode.READ)
//			
//			var ba:ByteArray = new ByteArray()
//			stream.readBytes(ba,0, stream.bytesAvailable)
//			stream.close();
//						
//			var objModel:SDImageModel = new SDImageModel()
//			objModel.x = event.dropX
//			objModel.y = event.dropY
//			objModel.imageData = ba
//						
//			diagramModel.addSDObjectModel(objModel)
												
 		}
				
		
		[Mediate(event='DeleteSDObjectModelEvent.DELETE_SELECTED_FROM_MODEL')]
		public function onDeleteSelectedSDObjectModel(event:DeleteSDObjectModelEvent):void
		{
			Logger.info("onDeleteSelectedSDObjectModel()" , this)
			var cmd:DeleteSelectedSDObjectModelsCommand = new DeleteSelectedSDObjectModelsCommand(diagramModel)
			
			var sdIDArray:Array = new Array();	
			for each (var sdObjectModel:SDObjectModel in diagramModel.selectedArray)
			{
				sdIDArray.push(sdObjectModel.sdID);
				
			}
			
//			remoteSharedObjectController.dispatchUpdate_DeleteSelectedSDObjectModel(sdIDArray);	

			cmd.execute()
			undoRedoManager.push(cmd);
			
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.DELETE_SELECTED_SD_OBJECT_MODEL);	
			Swiz.dispatchEvent(rsoEvent);
		}
		
// Doon - commented out on 4/21/10		
//		[Mediate(event='DeleteSDObjectModelEvent.DELETE_FROM_MODEL')]
//		public function onDeleteSDObjectModel(event:DeleteSDObjectModelEvent):void
//		{
//			Logger.info("onDeleteSDObjectModel()" , this)
//			var sdObjectModel:SDObjectModel = event.sdObjectModel
//			var cmd:DeleteSDObjectModelCommand = new DeleteSDObjectModelCommand(diagramModel, sdObjectModel)
//			cmd.execute()
//			undoRedoManager.push(cmd)		
//		}
				
		 
		/* Users connect SD objects by shift clicking them. When ObjectHandles gets a shift-clicked SD Object, it
		*  dispatches a SWIZ event and has nothing more to do with the event. Instead, the event should get picked up here
		*  and the whole connection process managed from this point forward
     	
		[Mediate(event='ConnectionEvent.START_CONNECTION_DRAG')]
		public function onStartConnectionDrag(event:ConnectionEvent):void
		{
			Logger.debug("onStartConnectionDrag()" , this)
			
			//FOR NOW, WE'RE NOT DOING CONNECTORS
			//var oc:ObjectConnectors = diagramModel.objectConnectors
			//oc.startConnectionDrag(event.startingComponent)					
		}
		
		[Mediate(event='ConnectionEvent.FINISH_CONNECTION_DRAG')]
		public function onFinishConnectionDrag(event:ConnectionEvent):void
		{			
			Logger.debug("onStartConnectionDrag()" , this)
			
			var oc:ObjectConnectors = diagramModel.objectConnectors
			oc.finishConnectionDrag(event.endingComponent)
		}
		 */ 
		
		
		[Mediate(event='ExportDiagramEvent.EXPORT_TO_FILE')]
		public function exportDiagramToFile(event:ExportDiagramEvent):void
		{
			// This needs to used FileReference, or some other strategy
			Logger.debug("exportDiagram() DISABLED", this)
//						
//			//flip to 100 percent zoom before exporting, otherwise the exported image will reflect the zoom width and height
//			
//			var currScaleX:Number = diagramModel.scaleX
//			var currScaleY:Number = diagramModel.scaleY
//				
//			diagramModel.scaleX = 1
//			diagramModel.scaleY = 1
//				
//			var view:UIComponent = event.view 
//			var bd:BitmapData = new BitmapData(diagramModel.width, diagramModel.height)
//			bd.draw(view)
//			imageByteArray = new PNGEncoder().encode(bd)		
//												
//			var f:File = File.desktopDirectory.resolvePath("my_diagram.png")     
//			f.addEventListener(Event.SELECT,  onSaveAsSelected);
//			f.browseForSave("Save as .PNG")
//				
//			//now set back the zoom to what the user had selected
//			diagramModel.scaleX = currScaleX
//			diagramModel.scaleY = currScaleY
		}	
								
		private function onSaveAsSelected(e:Event):void
		{
//			Logger.debug("onSaveAsSelected()", this)
//			var saveFileRef:File =  e.target as File    			
//		    var stream:FileStream  = new FileStream()
//		    stream.open(saveFileRef,  FileMode.WRITE)
//		    stream.writeBytes(imageByteArray, 0, imageByteArray.length)
//		    stream.close()			
		    
		}
		
		
		
		[Mediate(event='PropertiesEvent.EDIT_PROPERTIES')]
		public function editProperties(event:PropertiesEvent):void
		{
			Logger.debug("editProperties()", this)
			_diagramPropertiesDialog = dialogsController.showDiagramPropertiesDialog()
			_diagramPropertiesDialog.diagramModel = diagramModel
			_diagramPropertiesDialog.addEventListener("OK", onSaveDiagramProperties)
			_diagramPropertiesDialog.addEventListener(Event.CANCEL, onCancelDiagramProperties)	
		}	
	
		protected function onSaveDiagramProperties(event:Event):void
		{
			var evt:PropertiesEvent = new PropertiesEvent(PropertiesEvent.PROPERTIES_EDITED, true)
			Swiz.dispatchEvent(evt)
			dialogsController.removeDialog(_diagramPropertiesDialog)
			_diagramPropertiesDialog.removeEventListener("OK", onSaveDiagramProperties)
			_diagramPropertiesDialog.removeEventListener(Event.CANCEL, onCancelDiagramProperties)	
		}
		
		protected function onCancelDiagramProperties(event:Event):void
		{
			
			dialogsController.removeDialog(_diagramPropertiesDialog)
			_diagramPropertiesDialog.removeEventListener("OK", onSaveDiagramProperties)
			_diagramPropertiesDialog.removeEventListener(Event.CANCEL, onCancelDiagramProperties)	 
		}
		
			
		[Mediate(event='ZoomEvent.ZOOM_IN')]
  		public function onZoomIn():void
  		{
  			diagramModel.scaleX += .25
  			diagramModel.scaleY += .25
  			
  			if (diagramModel.scaleX > 2) diagramModel.scaleX = 2
  			if (diagramModel.scaleY > 2) diagramModel.scaleY = 2
  			
//			remoteSharedObjectController.dispatchUpdate_RefreshZoom();
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_ZOOM);	
			Swiz.dispatchEvent(rsoEvent);
  		}

		[Mediate(event='ZoomEvent.ZOOM_OUT')]
		public function onZoomOut():void
  		{
  			diagramModel.scaleX -= .25
  			diagramModel.scaleY -= .25
  			
  			if (diagramModel.scaleX < .25) diagramModel.scaleX = .25
  			if (diagramModel.scaleY < .25) diagramModel.scaleY = .25
				
//			remoteSharedObjectController.dispatchUpdate_RefreshZoom();
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_ZOOM);	
			Swiz.dispatchEvent(rsoEvent);
  		}
  		
  		[Mediate(event='ColorEvent.CHANGE_COLOR')]
		public function onChangeColor(event:ColorEvent):void
  		{	
  			diagramModel.setColor(event.color);
						
			//update all selected symbols 
			var selectedArr:Array = diagramModel.selectedArray
			for each (var objModel:SDObjectModel in selectedArr)
			{
				var cmd:ChangeColorCommand = new ChangeColorCommand(diagramModel, objModel);
				cmd.color = event.color;
				cmd.execute();
				undoRedoManager.push(cmd);
				
				var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.CHANGE_COLOR, true, true);
				Swiz.dispatchEvent(rsoEvent);
			}
			
			
			
  		}
  		
  		protected var _currModelForImageLoad:SDImageModel
		protected var _fileReference:FileReference;	
//  		protected var _imageFile:File
  		
		[Mediate(event='LoadImageEvent.ADD_IMAGE_FROM_MENU')]
		public function onAddImageFromMenu(event:LoadImageEvent):void
		{			
			_currModelForImageLoad = new SDImageModel();
			_currModelForImageLoad.x = 10;
			_currModelForImageLoad.y = 10;
			
			diagramModel.addSDObjectModel(_currModelForImageLoad);
			
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.SELECT, onFileSelect);
			_fileReference.addEventListener(Event.CANCEL, onCancelFileSelect);
			var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png;");
//			setTimeout( function():void{_fileReference.load();}, 1);
			_fileReference.browse([imagesFilter]);
			
		}

		
//		[Mediate(event='LoadImageEvent.BROWSE_FOR_IMAGE')]
//  		public function onBrowseForImage(event:LoadImageEvent):void
//  		{
//  			_currModelForImageLoad = event.model  		
//  			
//			_imageFile = new File()			
//			_imageFile.addEventListener(Event.SELECT, onLoadImage)
//			_imageFile.addEventListener(Event.CANCEL, onCancelLoadImage)
//			var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png;*.swf;");
//			_imageFile.browseForOpen("Select an image to import.", [imagesFilter])
//				
//		}
		
		private function onFileSelect(event:Event):void
		{
			_fileReference.addEventListener(Event.COMPLETE, onLoadComplete);
			_fileReference.load()
		}
		
		public function onLoadComplete(event:Event):void
		{				
			_currModelForImageLoad.imageData = _fileReference.data;		
				
			var remoteSharedObjectEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.LOAD_IMAGE, true, true);
			remoteSharedObjectEvent.imageData = _fileReference.data;
			remoteSharedObjectEvent.sdImageModel = _currModelForImageLoad;
			Swiz.dispatchEvent(remoteSharedObjectEvent);	
		}
		
		protected function onCancelFileSelect(event:Event):void
		{			
			_fileReference.removeEventListener(Event.SELECT, onFileSelect)
			_fileReference.removeEventListener(Event.CANCEL, onCancelFileSelect)
		}
  		
  		protected function returnToPointerTool():void
		{
			if (diagramModel.currToolType!=DiagramModel.POINTER_TOOL)
			{
				var evt:ToolPanelEvent = new ToolPanelEvent(ToolPanelEvent.TOOL_SELECTED, true)
				evt.toolTypeSelected = DiagramModel.POINTER_TOOL
				Swiz.dispatchEvent(evt)	
			}	
		}
		
		
		[Mediate(event='MultiSelectEvent.DRAG_MULTI_SELECTION_MADE')]
		public function onMultiSelect(event:MultiSelectEvent):void
		{
			Logger.debug("onMultiSelect()",this)
			if (event.selectedArr.length<1) return
			
			for each (var sdBase:SDBase in event.selectedArr)
			{
				var model:SDObjectModel = diagramModel.findModel(sdBase)
				Logger.debug("adding model:"+ model, this)
				if( ! model ) { continue; }
				diagramModel.addToSelected(model)
			}			
			
			var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.DRAG_MULTI_SELECTION_FINISHED, true)
			Swiz.dispatchEvent(evt)
			
		}
		
		
		[Mediate(event='SelectionEvent.SELECT_ALL')]
		public function onSelectAll(event:SelectionEvent):void
		{
			Logger.debug("onSelectAll()",this)
						
			for each (var sdObjectModel:SDObjectModel in diagramModel.sdObjectModelsAC)
			{
				diagramModel.addToSelected(sdObjectModel)
			}									
		}
		
		
		
		[Mediate(event='AlignEvent.ALIGN_TOP')]
		[Mediate(event='AlignEvent.ALIGN_BOTTOM')]
		[Mediate(event='AlignEvent.ALIGN_MIDDLE')]
		[Mediate(event='AlignEvent.ALIGN_LEFT')]
		[Mediate(event='AlignEvent.ALIGN_RIGHT')]
		[Mediate(event='AlignEvent.ALIGN_CENTER')]
		public function onAlign(event:AlignEvent):void
		{
			Logger.debug("onAlign() : " + event.type,this)
			
			var xPos:Number = -1
			var yPos:Number = -1				
			var sdObjectsArr:Array = diagramModel.selectedArray	
			
			if (sdObjectsArr.length==0) return
								
			switch(event.type)
			{
				
				case AlignEvent.ALIGN_TOP:
					for each (sdObjectModel in sdObjectsArr)
					{
						if (yPos == -1) 
						{
							yPos = sdObjectModel.y
						}
						else
						{
							if (sdObjectModel.y<yPos) yPos = sdObjectModel.y
						}
					}
					if (yPos<0) yPos = 0
					break
				
				case AlignEvent.ALIGN_LEFT:			
					for each (sdObjectModel in sdObjectsArr)
					{
						if (xPos == -1) 
						{
							xPos = sdObjectModel.x
						}
						else
						{
							if (sdObjectModel.x<xPos) xPos = sdObjectModel.x
						}
					}
					if (xPos<0) xPos = 0					
					break
				
				case AlignEvent.ALIGN_CENTER:
					var avg:Number = 0
					for each (sdObjectModel in sdObjectsArr)
					{
						avg += uint(sdObjectModel.x + (sdObjectModel.width/2))						
					}
					xPos = uint(avg/sdObjectsArr.length)
					break
				
				case AlignEvent.ALIGN_RIGHT:
					for each (sdObjectModel in sdObjectsArr)
					{
						if (xPos == -1) 
						{
							xPos = (sdObjectModel.x + sdObjectModel.width)
						}
						else
						{
							if ((sdObjectModel.x + sdObjectModel.width)>xPos) xPos = sdObjectModel.x + sdObjectModel.width
						}
					}						
					break
				
				case AlignEvent.ALIGN_BOTTOM:
					for each (sdObjectModel in sdObjectsArr)
					{
						if (yPos == -1) 
						{
							yPos = sdObjectModel.y + sdObjectModel.height
						}
						else
						{
							if (sdObjectModel.y + sdObjectModel.height>yPos) yPos = sdObjectModel.y + sdObjectModel.height
						}
					}							
					break
				
				case AlignEvent.ALIGN_MIDDLE:
					avg = 0
					for each (sdObjectModel in sdObjectsArr)
					{
						avg += uint(sdObjectModel.y + (sdObjectModel.height/2))					
					}
					yPos = uint(avg/sdObjectsArr.length)
					break
				
				default:
					Logger.error("onAlign() Unrecognized event type: "+ event.type,this)
					return
			}
			
			
			if (yPos>0)
			{
				for each (var sdObject:SDObjectModel in sdObjectsArr)
				{
					Logger.debug("before capture -- object : " +sdObject.symbolClass + " y: " + sdObject.y ,this)
					sdObject.captureStartState()
					sdObject.y = yPos
					Logger.debug("now setting y to : " + yPos ,this)
					if (event.type==AlignEvent.ALIGN_MIDDLE)
					{
						sdObject.y -= uint(sdObject.height / 2)
					}
					else if (event.type==AlignEvent.ALIGN_BOTTOM)
					{
						sdObject.y -= sdObject.height
					}
				}
			}
			if (xPos>0)
			{
				for each (sdObject in sdObjectsArr)
				{
					sdObject.captureStartState()
					sdObject.x = xPos
					if (event.type==AlignEvent.ALIGN_CENTER)
					{
						sdObject.x -= uint(sdObject.width / 2)
					}
					else if (event.type==AlignEvent.ALIGN_RIGHT)
					{
						sdObject.x -= sdObject.width
					}
				}
			}
			
			var transformedObjectsInfoArr:Array = []
			for each (var sdObjectModel:SDObjectModel in sdObjectsArr)
			{
				var from:TransformMemento = sdObjectModel.getStartTransformState()
				var to:TransformMemento = sdObjectModel.getTransformState()
				var o:Object = {sdID:sdObjectModel.sdID, fromState:from, toState:to}
				transformedObjectsInfoArr.push(o)
			}
			
			var cmd:TransformCommand = new TransformCommand(diagramModel, transformedObjectsInfoArr)			
			cmd.execute()
			undoRedoManager.push(cmd)
				
			//remoteSharedObjectController.dispatchUpdate_ObjectChanged(cmd);											
		}
		
		
		
		
		
  		// *****************************
		// Track events for undo/redo
		// *****************************
		
		
		//Dragging drag circles on lines is captured here
		//The line is already changed when the user mouses up on a circle
		//so we just capture the change in a command but don't actually execute the command
		[Mediate(event='DragCircleEvent.DRAG_CIRCLE_DOWN')]
		public function dragCircleDown(event:DragCircleEvent):void
		{
			Logger.debug("dragCircleDown()",this)
			var sdLineModel:SDLineModel = event.sdLineModel
			sdLineModel.captureLineStartState()
		}
		
		[Mediate(event='DragCircleEvent.DRAG_CIRCLE_UP')]
		public function dragCircleUp(event:DragCircleEvent):void
		{
			Logger.debug("dragCircleUp()",this)
			var cmd:ChangeLinePositionCommand = new ChangeLinePositionCommand(diagramModel)
			cmd.sdID = event.sdLineModel.sdID
			cmd.fromState = event.sdLineModel.getLineStartState()
			cmd.toState = event.sdLineModel.getMemento() as SDLineMemento
			//don't execute command since transformation has already happened
			undoRedoManager.push(cmd)
				
//			remoteSharedObjectController.dispatchUpdate_ChangeLinePosition(cmd)
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.CHANGE_LINE_POSITION);	
			Swiz.dispatchEvent(rsoEvent);
		}
		
		[Mediate(event='ChangeDepthEvent.MOVE_TO_BACK')]		
		public function moveToBack(event:ChangeDepthEvent):void
		{
			var target_sdObjectModel:SDObjectModel = diagramModel.getModelByID(event.sdID);			
			if (target_sdObjectModel == null || target_sdObjectModel.depth == 0)
				return;

			target_sdObjectModel.depth = 0;
			var numElements:uint = diagramModel.sdObjectModelsAC.length;			
			for (var i:uint = 0; i<numElements; i++)
			{
				var sdObjectModel:SDObjectModel = diagramModel.sdObjectModelsAC.getItemAt(i) as SDObjectModel;
				if (sdObjectModel != target_sdObjectModel) 
				{
					sdObjectModel.depth ++
				}
			}					
//			remoteSharedObjectController.dispatchUpdate_RefreshZOrder();
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_Z_ORDER);	
			Swiz.dispatchEvent(rsoEvent);
		}
		
		[Mediate(event='ChangeDepthEvent.MOVE_TO_FRONT')]		
		public function moveToFront(event:ChangeDepthEvent):void
		{				
			var target_sdObjectModel:SDObjectModel = diagramModel.getModelByID(event.sdID);			
			var numElements:uint = diagramModel.sdObjectModelsAC.length;				
			if (target_sdObjectModel == null || target_sdObjectModel.depth == numElements -1)
				return;

			target_sdObjectModel.depth = numElements - 1
			for (var i:uint = 0; i<numElements; i++)
			{
				var sdObjectModel:SDObjectModel = diagramModel.sdObjectModelsAC.getItemAt(i) as SDObjectModel;
				if (sdObjectModel != target_sdObjectModel) 
				{
					sdObjectModel.depth --
				}				
			}				
//			remoteSharedObjectController.dispatchUpdate_RefreshZOrder();			
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_Z_ORDER);	
			Swiz.dispatchEvent(rsoEvent);
		}
		

		[Mediate(event='ChangeDepthEvent.MOVE_BACKWARD')]		
		public function moveBackward(event:ChangeDepthEvent):void
		{			
			var target_sdObjectModel:SDObjectModel = diagramModel.getModelByID(event.sdID);
			var numElements:uint = diagramModel.sdObjectModelsAC.length;				
			if (target_sdObjectModel == null || target_sdObjectModel.depth == 0)
				return;
			
			for (var i:uint = 0; i<numElements; i++)
			{
				var sdObjectModel:SDObjectModel = diagramModel.sdObjectModelsAC.getItemAt(i) as SDObjectModel;
				if (target_sdObjectModel.depth == sdObjectModel.depth + 1) 
				{
					target_sdObjectModel.depth --;
					sdObjectModel.depth ++;
						
//					remoteSharedObjectController.dispatchUpdate_RefreshZOrder();		
					var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_Z_ORDER);	
					Swiz.dispatchEvent(rsoEvent);
					break
				}				
			}		

		}
		
		[Mediate(event='ChangeDepthEvent.MOVE_FORWARD')]		
		public function moveForward(event:ChangeDepthEvent):void
		{
			var numElements:uint = diagramModel.sdObjectModelsAC.length;				
			var target_sdObjectModel:SDObjectModel = diagramModel.getModelByID(event.sdID);
			
			if (target_sdObjectModel == null || target_sdObjectModel.depth == numElements-1)
				return;
			
			for (var i:uint = 0; i<numElements; i++)
			{
				var sdObjectModel:SDObjectModel = diagramModel.sdObjectModelsAC.getItemAt(i) as SDObjectModel;
				if (target_sdObjectModel.depth == sdObjectModel.depth - 1) 
				{
					target_sdObjectModel.depth ++;
					sdObjectModel.depth --;
					
//					remoteSharedObjectController.dispatchUpdate_RefreshZOrder();		
					var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.REFRESH_Z_ORDER);	
					Swiz.dispatchEvent(rsoEvent);
					break
				}				
			}		
			
		}
		
		
		
	}
}