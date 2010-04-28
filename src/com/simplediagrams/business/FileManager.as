package com.simplediagrams.business
{
	
	import com.simplediagrams.events.LoadDiagramEvent;
	import com.simplediagrams.events.SaveDiagramEvent;
	import com.simplediagrams.model.*;
	import com.simplediagrams.util.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.filesystem.*;
	import flash.net.FileFilter;
	import flash.display.Sprite
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	import org.swizframework.Swiz;

	public class FileManager extends EventDispatcher
	{
		
		[Autowire(bean="applicationModel")]
		public var appModel:ApplicationModel;
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;
		
		[Autowire(bean="libraryManager")]
		public var libraryManager:LibraryManager;
		
		
//		protected var _diagramFile:File
		protected var _diagramFileXML:XML //the file's contents converted to an XML object
//		protected var _imageFile:File

		public function FileManager() 
		{
		}
		
		public function clear():void
		{
//			if (_diagramFile)
//			{
//				_diagramFile.removeEventListener(Event.SELECT, onOpenFile)
//				_diagramFile.removeEventListener(Event.SELECT, onSaveFile)
//				_diagramFile = null
//			}
		}
		
		/* LOADING DIAGRAM */
		
		public function loadSimpleDiagramFromFile(nativePath:String=null):void
		{
//			_diagramFile = new File()
//			if (nativePath!=null)
//			{
//				_diagramFile.nativePath = nativePath
//				onOpenFile(null)
//				return
//			}
//			else
//			{
//				_diagramFile.addEventListener(Event.SELECT, onOpenFile)
//				var sdFilter:FileFilter = new FileFilter("SimpleDiagram XML File", "*.xml");
//				_diagramFile.browseForOpen("Select a SimpleDiagram file to open.", [sdFilter])
//			}
		}
		
		protected function onOpenFile(event:Event):void
		{
//			Logger.debug("onOpenFile event: " + event, this)
//			
//			diagramModel.initDiagramModel()
//			
//			_diagramFile.removeEventListener(Event.SELECT, onOpenFile)
//			
//			var fileStream:FileStream = new FileStream()
//			fileStream.open(_diagramFile, FileMode.READ)
//			var diagramText:String = fileStream.readUTFBytes(fileStream.bytesAvailable)
//			fileStream.close()
//			_diagramFileXML = XML(diagramText)
//				
//			//check whether we have all the libraries we need to render this diagram
//			var unavailableLibrariesUsedArr:Array = getUnavailableLibrariesUsed(_diagramFileXML)
//						
//			if (unavailableLibrariesUsedArr.length>0)
//			{
//				if (unavailableLibrariesUsedArr.length>1)
//				{
//					var missingLibraries:String = unavailableLibrariesUsedArr.join(", ").slice(0,-2)
//				}	
//				else
//				{
//					missingLibraries = unavailableLibrariesUsedArr[0]
//				}
//				var msg:String = "This file uses library plugins that you haven't installed, so it won't render correctly if you load it."
//				msg +="\n\nMissing libraries: " + missingLibraries 
//				msg += "\n\nContinue Loading?"
//				Alert.show(msg, "Missing Library Plugins", Alert.OK | Alert.CANCEL, FlexGlobals.topLevelApplication as Sprite, onContinueLoading)
//			}
//			else
//			{
//				loadDiagramFromXML(_diagramFileXML)
//			}
//			
		}
		
		protected function onContinueLoading(event:CloseEvent):void
		{
			if (event.detail == Alert.OK)
			{
				loadDiagramFromXML(_diagramFileXML)
			}
			else
			{
				var evt:LoadDiagramEvent = new LoadDiagramEvent(LoadDiagramEvent.DIAGRAM_LOAD_CANCELED, true)	
				Swiz.dispatchEvent(evt)	
			}
		}
		
		protected function loadDiagramFromXML(xml:XML):void
		{
			diagramModel.initDiagramModel()
			
			try
			{				
				loadXMLIntoDiagramModel(xml)		
				
				var evt:LoadDiagramEvent = new LoadDiagramEvent(LoadDiagramEvent.DIAGRAM_LOADED, true)							
//				evt.nativePath = _diagramFile.nativePath
//				evt.fileName = _diagramFile.name
				evt.success = true
				Swiz.dispatchEvent(evt)		
					
			}
			catch(err:Error)
			{
				Logger.error("Error loading diagram file: Error: " + err, this)				
				evt = new LoadDiagramEvent(LoadDiagramEvent.DIAGRAM_LOAD_ERROR, true)	
				evt.errorMessage = "There was an error loading this diagram file. The file appears corrupted. Please contact support for help."
				Swiz.dispatchEvent(evt)					
			}
			
						
		}
		
		protected function getUnavailableLibrariesUsed(fileXML:XML):Array
		{
			var librariesUsedArr:Array = []
			for each (var sdXML:XML in fileXML.sdObjects.*)
			{				
				var sdObjModel:SDObjectModel
				
				if (sdXML.name() == "SDSymbol")
				{								
					librariesUsedArr[sdXML.@libraryName] = true
				}
			}
			
			var unavailableLibrariesArr:Array = []
			for (var libraryName:String in librariesUsedArr)
			{
				if (libraryManager.libraryExists(libraryName)==false)
				{
					//we only want the last part of the qualified name
					unavailableLibrariesArr.push(libraryName.split(".").pop())
				}
			}
						
			return unavailableLibrariesArr
		}
		
		/* SAVING DIAGRAM */
		
		
		public function saveSimpleDiagram():void
		{	
//			Logger.debug("saveSimpleDiagram()", this)
//			
//			if(_diagramFile)
//			{
//				Logger.debug("Saving file to : "+ _diagramFile.nativePath,this)
//				onSaveFile(null)
//			}
//			else
//			{
//				//if the user doesn't have a file currently open, then this is a new diagram and they need to save as
//				saveSimpleDiagramAs()
//			}
		}
		
		protected function onCancelSave(event:Event):void
		{			
//			Logger.debug("onCancelSave()",this)
//			_diagramFile.removeEventListener(Event.SELECT, onSaveFile)
//			_diagramFile.removeEventListener(Event.CANCEL, onCancelSave)
		}
		
		public function saveSimpleDiagramAs():void
		{	
//			Logger.debug("saveSimpleDiagramAs()", this)
//			_diagramFile = File.documentsDirectory		
//			_diagramFile.nativePath = appModel.defaultFileDirectory.nativePath
//			_diagramFile.addEventListener(Event.SELECT, onSaveFile)
//			_diagramFile.addEventListener(Event.CANCEL, onCancelSaveAs)
//			_diagramFile.browseForSave("Save Simple Diagram")
		}
		
		protected function onCancelSaveAs(event:Event):void
		{
//			Logger.debug("onCancelSaveAs()",this)
//			_diagramFile.removeEventListener(Event.SELECT, onSaveFile)
//			_diagramFile.removeEventListener(Event.CANCEL, onCancelSaveAs)
		}
		
		protected function onSaveFile(event:Event):void
		{
//			Logger.debug("onSaveFile() event: " + event, this)
//			_diagramFile.removeEventListener(Event.SELECT, onSaveFile)
//			_diagramFile.removeEventListener(Event.CANCEL, onCancelSave)
//			_diagramFile.removeEventListener(Event.CANCEL, onCancelSaveAs)
//							
//			if(!_diagramFile.extension || _diagramFile.extension != "xml")
//			{
//				_diagramFile.url = _diagramFile.url + ".xml";
//			}
//			
//			diagramModel.updateUpdatedAt()
//			
//			var output:String = convertDiagramToXML()
//						
//			var stream:FileStream = new FileStream()
//			stream.open(_diagramFile, FileMode.WRITE)
//			stream.writeUTFBytes(output)
//			
//			diagramModel.isDirty = false
//			
//			Logger.debug("sending DIAGRAM_SAVED event",this)
//			var savedEvent:SaveDiagramEvent = new SaveDiagramEvent(SaveDiagramEvent.DIAGRAM_SAVED, true)
//			savedEvent.nativePath = _diagramFile.nativePath
//			savedEvent.fileName = _diagramFile.name
//			Swiz.dispatchEvent(savedEvent)	
//		
		}
		
		
		/* CONVERTING FUNCTIONS */
		
		
		public function convertDiagramToXML():XML
		{			
			var s:XML = sdTemplateXML()	
			s.diagram.@version = appModel.version
			s.diagram.@createdAt = diagramModel.createdAt
			s.diagram.@updatedAt = diagramModel.updatedAt	
			s.diagram.@styleName = diagramModel.styleName
			s.diagram.@width = diagramModel.width
			s.diagram.@height = diagramModel.height	
			s.diagram.@baseBackgroundColor = diagramModel.baseBackgroundColor
			s.diagram.name = diagramModel.name
			s.diagram.description = diagramModel.description
		
			
			//save each of the SD objects
			for each (var sdObjModel:SDObjectModel in diagramModel.sdObjectModelsAC)
			{
								
				if (sdObjModel is SDLineModel)
				{
					var o:XML = <SDLine/>
					var lm:SDLineModel = SDLineModel(sdObjModel)
					o.startX = lm.startX
					o.startY = lm.startY
					o.endX = lm.endX
					o.endY = lm.endY
					o.bendX = lm.bendX
					o.bendY = lm.bendY
					o.lineWeight = lm.lineWeight
					o.startLineStyle = lm.startLineStyle
					o.endLineStyle = lm.endLineStyle
				}
				else if (sdObjModel is SDSymbolModel)
				{
					o = <SDSymbol/>
					var sm:SDSymbolModel = SDSymbolModel(sdObjModel)
					o.@libraryName = sm.libraryName
					o.@symbolName = sm.symbolName
					o.text = sm.text				
					o.textAlign = sm.textAlign	
					o.fontWeight = sm.fontWeight		
					o.textPosition = sm.textPosition	
					o.fontSize = sm.fontSize				
				}
				else if (sdObjModel is SDPencilDrawingModel)
				{
					o = <SDPencilDrawing/>
					var pdm:SDPencilDrawingModel = SDPencilDrawingModel(sdObjModel)
					o.linePath = pdm.linePath
					o.lineWeight = pdm.lineWeight				
				}
				else if (sdObjModel is SDTextAreaModel)
				{
					o = <SDTextArea/>
					var tm:SDTextAreaModel = SDTextAreaModel(sdObjModel)
					o.styleName = tm.styleName
					o.text = tm.text
					o.fontWeight = tm.fontWeight
					o.fontSize = tm.fontSize
					o.textAlign = tm.textAlign
				}
				else if (sdObjModel is SDImageModel)
				{
					o = <SDImage/>
					var im:SDImageModel = SDImageModel(sdObjModel)
					var enc:PNGEncoder = new PNGEncoder()
					var b:Base64Encoder = new Base64Encoder()
					
					//enc.encodeByteArray(im.imageData, im.width, im.height, false)			
					b.encodeBytes(im.imageData)
					o.imageData = b.toString()
					o.styleName = im.styleName		
				}
				else
				{
					o = <SDObject/>
				}
				
				//o.@id = sdObjModel.id
				o.@x = sdObjModel.x
				o.@y = sdObjModel.y
				o.@height = sdObjModel.height
				o.@width = sdObjModel.width
				o.@rotation = sdObjModel.rotation
				o.@zIndex = sdObjModel.zIndex
				o.@color = sdObjModel.color
				o.@colorizable = sdObjModel.colorizable.toString()
				
				s.sdObjects.appendChild(o)
					
				
			}
				
			return s
			
		}
		
		public function loadXMLIntoDiagramModel(s:XML):void
		{	
			
			var fileVersion:String =  s.diagram.@version 
			var isEarlyVersion:Boolean = (fileVersion=="")
			
			//TODO: handle different versions 
			
			diagramModel.createdAt = new Date(s.diagram.@createdAt)
			diagramModel.updatedAt= new Date(s.diagram.@updatedAt)
			diagramModel.styleName = s.diagram.@styleName
			diagramModel.width = s.diagram.@width
			diagramModel.height = s.diagram.@height
			diagramModel.baseBackgroundColor = s.diagram.@baseBackgroundColor
			diagramModel.name = s.diagram.name 
			diagramModel.description = s.diagram.description 
		
			var dec:Base64Decoder = new Base64Decoder()
		
			for each (var sdXML:XML in s.sdObjects.*)
			{				
				var sdObjModel:SDObjectModel
				
			    if (sdXML.name() == "SDSymbol")
				{					
					Logger.debug("Adding symbol: " + sdXML.templateName, this)
					sdObjModel = new SDSymbolModel()
					var sdSymbolModel:SDSymbolModel = SDSymbolModel(sdObjModel)
					sdSymbolModel.libraryName = sdXML.@libraryName
					sdSymbolModel.symbolName = sdXML.@symbolName
						
					var txt:String = sdXML.text	
					Logger.debug ("txt: " + txt,this)
					Logger.debug("isEarlyVersion: " + isEarlyVersion.toString(),this)
					if (isEarlyVersion && txt == "( add text )")
					{
						sdSymbolModel.text = ""
					}
					else
					{
						sdSymbolModel.text = txt
					}
					
					sdSymbolModel.textAlign = sdXML.textAlign	
					sdSymbolModel.fontWeight = sdXML.fontWeight	
					sdSymbolModel.textPosition = sdXML.textPosition	
					sdSymbolModel.fontSize = sdXML.fontSize	
				}
				else if (sdXML.name() == "SDLine")
				{
					sdObjModel = new SDLineModel()
					var lm:SDLineModel = SDLineModel(sdObjModel)
					lm.startX = sdXML.startX
					lm.startY = sdXML.startY 
					lm.endX = sdXML.endX 
					lm.endY = sdXML.endY 
					lm.bendX = sdXML.bendX
					lm.bendY = sdXML.bendY
					lm.lineWeight = sdXML.lineWeight 
					lm.startLineStyle = sdXML.startLineStyle
					lm.endLineStyle	= sdXML.endLineStyle 
				}				
				else if (sdXML.name() == "SDPencilDrawing")
				{
					sdObjModel = new SDPencilDrawingModel()
					var pdm:SDPencilDrawingModel = SDPencilDrawingModel(sdObjModel)
					pdm.linePath = sdXML.linePath
					pdm.lineWeight = sdXML.lineWeight				
				}
				else if (sdXML.name() == "SDTextArea")
				{
					sdObjModel = new SDTextAreaModel()
					var tm:SDTextAreaModel = SDTextAreaModel(sdObjModel)
					tm.styleName = sdXML.styleName
					tm.text = sdXML.text
					tm.fontSize = sdXML.fontSize
					tm.fontWeight = sdXML.fontWeight	
					tm.textAlign = sdXML.textAlign
				}
				else if (sdXML.name() == "SDImage")
				{
					sdObjModel = new SDImageModel()
					var im:SDImageModel = SDImageModel(sdObjModel)					
					dec.decode(sdXML.imageData)
					Logger.debug("im.imageData = " + im.imageData, this)
					Logger.debug("dec = " + dec, this)
					im.imageData = dec.toByteArray()
					im.styleName = sdXML.styleName		
				}
				else
				{
					Logger.warn("unrecognized xml fragment: " + sdXML.toXMLString(), this)
				}
				
				//all models share these attributes				
				//sdObjModel.id = sdXML.@id 
				sdObjModel.x = sdXML.@x 
				sdObjModel.y = sdXML.@y 
				sdObjModel.height = sdXML.@height 
				sdObjModel.width = sdXML.@width 
				sdObjModel.rotation = sdXML.@rotation 
				sdObjModel.zIndex = sdXML.@zIndex 
				sdObjModel.color = sdXML.@color 
				sdObjModel.colorizable = (sdXML.@colorizable=="true")
			
				diagramModel.sdObjectModelsAC.addItem(sdObjModel)	
				
				Logger.debug("	diagramModel.sdObjectModelsAC.length: " + diagramModel.sdObjectModelsAC.length, this)
			}					
		}
		
		protected function sdTemplateXML():XML
		{
			var xml:XML = <SimpleDiagram>
							<diagram/>
							<sdObjects/>
						  </SimpleDiagram>
			return xml
			
						 
		}
		
		
		
		
		
	}
}