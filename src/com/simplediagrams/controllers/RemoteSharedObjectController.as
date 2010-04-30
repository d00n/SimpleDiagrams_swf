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
	import com.simplediagrams.commands.CutCommand;
	import com.simplediagrams.commands.DeleteSDObjectModelCommand;
	import com.simplediagrams.commands.DeleteSelectedSDObjectModelsCommand;
	import com.simplediagrams.commands.PasteCommand;
	import com.simplediagrams.commands.TransformCommand;
	import com.simplediagrams.events.*;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.DiagramStyleManager;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.SDImageModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.model.SettingsModel;
	import com.simplediagrams.model.UndoRedoManager;
	import com.simplediagrams.model.mementos.*;
	import com.simplediagrams.model.mementos.SDLineMemento;
	import com.simplediagrams.model.mementos.TransformMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.SDBase;
	import com.simplediagrams.view.SDComponents.SDLine;
	import com.simplediagrams.view.SDComponents.SDTextArea;
	import com.simplediagrams.view.dialogs.DiagramPropertiesDialog;
	
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
//	import flash.filesystem.File;
//	import flash.filesystem.FileMode;
//	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import mx.core.UIComponent;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.object_proxy;
	
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;
	
	import spark.components.Group;
	
	public class RemoteSharedObjectController extends AbstractController 
	{

		/** A value of "success" means the client changed the shared object */
		private static const SUCCESS : String = "success";
		
		/** A value of "change" means another client changed the object or the server resynchronized the object. */
		private static const CHANGE : String = "change";
		
		private static const WOWZA_SERVER:String = "rtmp://gold/foo";
		//private static const WOWZA_SERVER:String = "rtmp://kai/foo";
		
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var _remoteSharedObject:SharedObject;
		
		[Autowire(bean='diagramController')]
		public var diagramController:DiagramController
		
		[Autowire(bean='diagramModel')]
		public var diagramModel:DiagramModel
		
		[Autowire(bean='objectHandlesController')]
		public var objectHandlesController:ObjectHandlesController
		
		[Autowire(bean='libraryManager')]
		public var libraryManager:LibraryManager;
		
		[Autowire(bean='diagramStyleManager')]
		public var diagramStyleManager:DiagramStyleManager
		
		public function RemoteSharedObjectController() {			
			connect();
		}

		[Mediate(event="RemoteSharedObjectEvent.START")]
		private function connect():void{
			_netConnection = new NetConnection();
			_netConnection.objectEncoding = ObjectEncoding.AMF3;
			_netConnection.client = this; 
			
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_netConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var clientObj:Object = new Object();
			clientObj.receiveJPG = function(params) : void
			{
				var sdImageModel:SDImageModel = new SDImageModel();
				sdImageModel.imageData	 	= params["image"];
				sdImageModel.sdID 			= parseInt(params["sdID"]);
				sdImageModel.x 				= parseInt(params["x"]);
				sdImageModel.y 				= parseInt(params["y"]);
				sdImageModel.width 			= parseInt(params["width"]);
				sdImageModel.height	 		= parseInt(params["height"]);
				sdImageModel.zIndex 		= parseInt(params["zIndex"]);
//				sdImageModel.orig_height	= parseInt(params["orig_height"]);
//				sdImageModel.orig_width 	= parseInt(params["orig_width"]);
				sdImageModel.styleName 		= params["styleName"];

				diagramModel.addSDObjectModel(sdImageModel);
			}
			
			_netConnection.client = clientObj;
			
			_netConnection.connect(WOWZA_SERVER);     
			
			//_netConnection.call("doSomething",null,null);
			
			
		}
		
		public function onStatus( event : NetStatusEvent) : void {
			Logger.info("onStatus()" + event,this);	
			if (event.info !== '' || event.info !== null) {  
				switch (event.info.code) {
					case "NetConnection.Connect.Success":   createSharedObject();  break;
					case "NetConnection.Connect.Closed":  trace("Disconnected");  break;
				}      
			}
		}
		
		private function createSharedObject() : void {
			Logger.info("createSharedObject()",this);	
			_netStream = new NetStream(_netConnection);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_netStream.client = this;    
			
			
			
			_remoteSharedObject = SharedObject.getRemote("myDataObj", _netConnection.uri, false);
			_remoteSharedObject.client = this;
			_remoteSharedObject.addEventListener(SyncEvent.SYNC, onSyncEventHandler);
			_remoteSharedObject.connect(_netConnection); 
		}
		
		public function securityErrorHandler(event : SecurityErrorEvent) : void {  trace('Security Error: '+event);  }
		public function ioErrorHandler(event : IOErrorEvent) : void {  trace('IO Error: '+event);  }
		public function asyncErrorHandler(event : AsyncErrorEvent) : void {  trace('Async Error: '+event);  }  
		
		
		private function onSyncEventHandler(event : SyncEvent):void {
			Logger.info("onSyncEventHandler code:" + event.changeList[0].code,this);	
			switch(event.changeList[0].code) {
				case SUCCESS:     
					break;
				case CHANGE:  
					processUpdate(event);    
					break;
			}    
		}

		[Mediate(event="RemoteSharedObjectEvent.RESET")]
		public function reset():void
		{
			stop();			
			connect();
		}

		[Mediate(event="RemoteSharedObjectEvent.STOP")]
		public function stop():void
		{
			_remoteSharedObject.close();
			_remoteSharedObject = null;
			_netConnection.close();
			_netConnection = null;
			_netStream.close();
			_netStream = null;

		}
		
		private function processUpdate( event : SyncEvent ) : void {
			switch (event.target.data["commandName"]) {
				case "AddLibraryItemCommand": {
					processUpdate_AddLibraryItemCommand(event);
					break;
				}
				case "DeleteSelectedSDObjectModel": {
					processUpdate_DeleteSelectedSDObjectModel(event);
					break;
				}
				case "ObjectChanged": {
					processUpdate_ObjectChanged(event);
					break;
				}
				case "ClearDiagram": {
					processUpdate_ClearDiagram(event);
					break;
				}
				case "CutEvent": {
					processUpdate_CutEvent(event);
					break;
				}
				case "PasteEvent": {
					processUpdate_PasteEvent(event);
					break;
				}
				case "RefreshZOrder": {
					processUpdate_RefreshZOrder(event);
					break;
				}
				case "TextWidgetAdded": {
					processUpdate_TextWidgetAdded(event);
					break;
				}
				case "TextAreaCreated": {
					processUpdate_TextAreaCreated(event);
					break;
				}
				case "PencilDrawingCreated": {
					processUpdate_PencilDrawingCreated(event);
					break;
				}
				case "CreateLineComponent": {
					processUpdate_CreateLineComponent(event);
					break;
				}
				case "RefreshZoom": {
					processUpdate_RefreshZoom(event);
					break;
				}
				case "ChangeLinePosition": {
					processUpdate_ChangeLinePosition(event);
					break;
				}
				case "SymbolTextEdit": {
					processUpdate_SymbolTextEdit(event);
					break;
				}
				case "SDTextAreaModel_Text": {
					processUpdate_SDTextAreaModel_Text(event);
					break;
				}
				case "StyleChanged": {
					processUpdate_StyleChanged(event);
					break;
				}
				case "ChangeAllShapesToDefaultColor": {
					processUpdate_ChangeAllShapesToDefaultColor(event);
					break;
				}
				case "ChangeColor": {
					processUpdate_ChangeColor(event);
					break;
				}
					}
		}
		
		public function dispatchUpdate_AddLibraryItemCommand(cmd:AddLibraryItemCommand) : void 
		{
			_remoteSharedObject.setProperty("commandName", "AddLibraryItemCommand");
			_remoteSharedObject.setProperty("libraryName", cmd.libraryName);				
			_remoteSharedObject.setProperty("symbolName", cmd.symbolName);							
			_remoteSharedObject.setProperty("sdID", cmd.sdID);							
			
			_remoteSharedObject.setProperty("x", cmd.x);
			_remoteSharedObject.setProperty("y", cmd.y);
			_remoteSharedObject.setProperty("textAlign", cmd.textAlign);
			_remoteSharedObject.setProperty("fontSize", cmd.fontSize);
			_remoteSharedObject.setProperty("fontWeight", cmd.fontWeight);
			_remoteSharedObject.setProperty("textPosition", cmd.textPosition);			
			_remoteSharedObject.setProperty("color", cmd.color);	
		}
		
		private function processUpdate_AddLibraryItemCommand( event : SyncEvent ) : void 
		{	
			var libraryName:String = event.target.data["libraryName"];
			var symbolName:String = event.target.data["symbolName"];
			
			var cmd:AddLibraryItemCommand = new AddLibraryItemCommand(diagramModel, libraryManager, libraryName, symbolName);	
			
			cmd.sdID		= parseInt(event.target.data["sdID"]);
			cmd.fontSize 	= parseInt(event.target.data["fontSize"]);
			cmd.color	 	= parseInt(event.target.data["color"]);
			cmd.x 			= parseFloat(event.target.data["x"]);
			cmd.y 			= parseFloat(event.target.data["y"]);
			cmd.textAlign 	= event.target.data["textAlign"];
			cmd.fontWeight 	= event.target.data["fontWeight"];
			cmd.textPosition = event.target.data["textPosition"];
			
			cmd.execute();
		}
		
		public function dispatchUpdate_DeleteSelectedSDObjectModel(sdIDArray:Array) : void 
		{
			_remoteSharedObject.setProperty("commandName", "DeleteSelectedSDObjectModel");
			_remoteSharedObject.setProperty("sdIDArray", sdIDArray);
		}	

		public function processUpdate_DeleteSelectedSDObjectModel(event:SyncEvent):void
		{
			Logger.info("processUpdate_DeleteSelectedSDObjectModel()",this);
			var sdIDArray:Array = event.target.data["sdIDArray"]
			
			for each (var sdID:Number in sdIDArray) {
				var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
				var cmd:DeleteSDObjectModelCommand = new DeleteSDObjectModelCommand(diagramModel, sdObjectModel);
				cmd.execute();
			}
		}		
			
		public function dispatchUpdate_ObjectChanged(cmd:TransformCommand) : void
		{
			Logger.info("dispatchUpdate_ObjectChanged()",this)
			_remoteSharedObject.setProperty("commandName", "ObjectChanged");
			
			var transformArray:Array = new Array();
			var i:Number = 0;
			for each (var obj:Object in cmd.TransformedObjectsArray)
			{
				var transformMemento:TransformMemento = obj.toState;
				transformArray[i] = new Array();
				transformArray[i]["sdID"] = obj.sdID;
				transformArray[i]["color"] = transformMemento.color;
				transformArray[i]["height"] = transformMemento.height;
				transformArray[i]["width"] = transformMemento.width;
				transformArray[i]["rotation"] = transformMemento.rotation;
				transformArray[i]["x"] = transformMemento.x;
				transformArray[i]["y"] = transformMemento.y;
				i++;
			}
			
			_remoteSharedObject.setProperty("transformArray", transformArray);
		}
		
		public function processUpdate_ObjectChanged(event : SyncEvent) : void 
		{
			Logger.info("processUpdate_ObjectChanged()",this);
			
			var transformArray:Array = event.target.data["transformArray"];
			var transformedObjectsArr:Array = new Array();
			var i:Number = 0;
			for each (var transform:Array in transformArray)
			{
				var sdID:Number = parseInt(transform["sdID"]);
				var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
				
				var to:TransformMemento = new TransformMemento();
				to.color  	= parseInt(transformArray[i]["color"]);
				to.height 	= parseFloat(transformArray[i]["height"]);
				to.width 	= parseFloat(transformArray[i]["width"]);
				to.rotation = parseFloat(transformArray[i]["rotation"]);
				to.x 		= parseFloat(transformArray[i]["x"]);
				to.y 		= parseFloat(transformArray[i]["y"]);	
				
				//var from:TransformMemento = to.clone();
				// from state is not relevant, because we're not pushing this command on the redo stack
				var o:Object = {sdID:sdObjectModel.sdID, fromState:to, toState:to};
				transformedObjectsArr.push(o);
				i++;
			}
			var cmd:TransformCommand = new TransformCommand(diagramModel, transformedObjectsArr);
			cmd.execute();				
		}	
		
		//[Mediate(event="CreateNewDiagramEvent.NEW_DIAGRAM_CREATED")]
		public function dispatchUpdate_ClearDiagram(event:CreateNewDiagramEvent) : void
		{
			Logger.info("dispatchUpdate_ClearDiagram()",this);
			_remoteSharedObject.setProperty("commandName", "ClearDiagram");
		}
		
		public function processUpdate_ClearDiagram(event:SyncEvent):void
		{
			Logger.info("processUpdate_ClearDiagram()",this);
			diagramModel.initDiagramModel();		
		}
		
		public function dispatchUpdate_CutEvent(cmd:CutCommand) : void
		{
			Logger.info("dispatchUpdate_CutEvent()",this);
			_remoteSharedObject.setProperty("commandName", "CutEvent");
			var sdIDArray:Array = new Array();
			for each (var sdObjectModel:SDObjectModel in cmd.clonesArr)
			{			
				sdIDArray.push(sdObjectModel.sdID);
			}
			_remoteSharedObject.setProperty("sdIDArray", sdIDArray);
		}

		public function processUpdate_CutEvent(event:SyncEvent):void
		{
			Logger.info("processUpdate_CutEvent()",this);
			var sdIDArray:Array = event.target.data["sdIDArray"]
			
			for each (var sdID:Number in sdIDArray) {
				var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
				var cmd:DeleteSDObjectModelCommand = new DeleteSDObjectModelCommand(diagramModel, sdObjectModel);
				cmd.execute();
			}
		}
		
		public function dispatchUpdate_PasteEvent(cmd:PasteCommand) : void
		{
			Logger.info("dispatchUpdate_PasteEvent()",this);
			_remoteSharedObject.setProperty("commandName", "PasteEvent");
			var pasteArray:Array = new Array();
			var i:Number = 0;
			for each (var obj:SDObjectModel in cmd.pastedObjectsArr)
			{			
				pasteArray[i] = new Array();
				var symbolModelObj:SDSymbolModel = obj as SDSymbolModel;
				if (symbolModelObj != null) {
					pasteArray[i]["is_LibraryItem"] = "true";
					pasteArray[i]["libraryName"] = symbolModelObj.libraryName;
					pasteArray[i]["symbolName"] = symbolModelObj.symbolName;								
					pasteArray[i]["text"] = symbolModelObj.text;
					pasteArray[i]["textAlign"] = symbolModelObj.textAlign;
					pasteArray[i]["textPosition"] = symbolModelObj.textPosition;
				}
				
				pasteArray[i]["classInfo"] = describeType(obj);
				pasteArray[i]["sdID"] = obj.sdID;
				pasteArray[i]["color"] = obj.color;
				pasteArray[i]["height"] = obj.height;
				pasteArray[i]["width"] = obj.width;
				pasteArray[i]["rotation"] = obj.rotation;
				pasteArray[i]["x"] = obj.x;
				pasteArray[i]["y"] = obj.y;
				i++;
			}		
			_remoteSharedObject.setProperty("pasteArray", pasteArray);
		}
		
		public function processUpdate_PasteEvent(event:SyncEvent):void
		{
			Logger.info("processUpdate_PasteEvent()",this);
			
			var pasteArray:Array = event.target.data["pasteArray"];
			for each (var pasteObj:Array in pasteArray)
			{
				if (pasteObj["is_LibraryItem"] == "true")
				{
					var libraryName:String = pasteObj["libraryName"];
					var symbolName:String = pasteObj["symbolName"];
					
					var cmd:AddLibraryItemCommand = new AddLibraryItemCommand(diagramModel, libraryManager, libraryName, symbolName);	
					
					cmd.sdID			= parseInt(pasteObj["sdID"]);
					cmd.fontSize 		= parseInt(pasteObj["fontSize"]);
					//cmd.color		 	= parseInt(pasteObj["color"]);
					cmd.x 				= parseFloat(pasteObj["x"]);
					cmd.y	 			= parseFloat(pasteObj["y"]);
					cmd.fontWeight 		= pasteObj["fontWeight"];
					//cmd.text		 	= pasteObj["text"];
					cmd.textAlign		= pasteObj["textAlign"];
					cmd.textPosition	= pasteObj["textPosition"];
					
					cmd.execute();
				}
			}			
		}
		
		public function dispatchUpdate_RefreshZOrder() : void
		{
			Logger.info("dispatchUpdate_RefreshZOrder()",this);
			
			var zOrderArray:Array = new Array();
			var numElements:uint = diagramModel.sdObjectModelsAC.length;
			for (var i:uint = 0; i<numElements; i++)
			{
				var sdObjectModel:SDObjectModel = diagramModel.sdObjectModelsAC.getItemAt(i) as SDObjectModel;

				zOrderArray[i] = new Array();
				
				if (sdObjectModel != null) {
					zOrderArray[i]["sdID"] = sdObjectModel.sdID;
					zOrderArray[i]["depth"] = sdObjectModel.depth;
				}
			}
			
			_remoteSharedObject.setProperty("commandName", "RefreshZOrder");			
			_remoteSharedObject.setProperty("zOrderArray", zOrderArray);			
		}
		
		public function processUpdate_RefreshZOrder(event:SyncEvent) : void
		{
			Logger.info("processUpdate_RefreshZOrder()",this);			
			
			var zOrderArray:Array = event.target.data["zOrderArray"];
			for each (var zOrder:Array in zOrderArray)
			{
				var sdID:Number = parseInt(zOrder["sdID"]);
				var depth:Number = parseInt(zOrder["depth"]);
				
				var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
								
				if (sdObjectModel != null) {
					Logger.info("processUpdate_RefreshZOrder() sdObjectModel.depth = " + sdObjectModel.depth.toString(),this);	
					sdObjectModel.depth = depth;	
				}				
			}			
		}
		
		public function dispatchUpdate_TextWidgetAdded(cmd:AddTextWidgetCommand) : void
		{
			Logger.info("dispatchUpdate_TextWidgetAdded()",this);
			
			_remoteSharedObject.setProperty("commandName", "TextWidgetAdded");
			_remoteSharedObject.setProperty("sdID", cmd.sdID);
			_remoteSharedObject.setProperty("styleName", cmd.styleName);
			_remoteSharedObject.setProperty("x", cmd.x);
			_remoteSharedObject.setProperty("y", cmd.y);			
		}
		
		public function processUpdate_TextWidgetAdded(event:SyncEvent) : void
		{
			Logger.info("processUpdate_TextWidgetAdded()",this);		
			
			var cmd:AddTextWidgetCommand = new AddTextWidgetCommand(diagramModel)
			cmd.sdID		= parseInt(event.target.data["sdID"]);
			cmd.x 			= parseFloat(event.target.data["x"]);
			cmd.y 			= parseFloat(event.target.data["y"]);
			cmd.styleName	= event.target.data["styleName"];
			cmd.maintainProportion = true;
			
			cmd.execute();			
		}
		
		public function dispatchUpdate_TextAreaCreated(cmd:AddTextAreaCommand) : void
		{
			Logger.info("dispatchUpdate_TextAreaCreated()",this);
			
			_remoteSharedObject.setProperty("commandName", "TextAreaCreated");
			_remoteSharedObject.setProperty("sdID", cmd.sdID);
			_remoteSharedObject.setProperty("x", cmd.x);
			_remoteSharedObject.setProperty("y", cmd.y);			
			_remoteSharedObject.setProperty("width", cmd.width);
			_remoteSharedObject.setProperty("height", cmd.height);
			_remoteSharedObject.setProperty("styleName", cmd.styleName);
			_remoteSharedObject.setProperty("textAlign", cmd.textAlign);
			_remoteSharedObject.setProperty("fontSize", cmd.fontSize);
			_remoteSharedObject.setProperty("fontWeight", cmd.fontWeight);			
		}
		
		public function processUpdate_TextAreaCreated(event:SyncEvent) : void
		{
			Logger.info("processUpdate_TextAreaCreated()",this);		
			
			var cmd:AddTextAreaCommand = new AddTextAreaCommand(diagramModel)
			cmd.sdID		= parseInt(event.target.data["sdID"]);
			cmd.x 			= parseFloat(event.target.data["x"]);
			cmd.y 			= parseFloat(event.target.data["y"]);
			cmd.width		= parseFloat(event.target.data["width"]);
			cmd.height		= parseFloat(event.target.data["height"]);
			cmd.styleName	= event.target.data["styleName"];
			cmd.textAlign	= event.target.data["textAlign"];
			cmd.fontSize	= parseFloat(event.target.data["fontSize"]);
			cmd.fontWeight	= event.target.data["fontWeight"];

			cmd.execute();		
		}
		
		public function dispatchUpdate_PencilDrawingCreated(cmd:AddPencilDrawingCommand) : void
		{
			Logger.info("dispatchUpdate_PencilDrawingCreated()",this);
			
			_remoteSharedObject.setProperty("commandName", "PencilDrawingCreated");
			_remoteSharedObject.setProperty("sdID", cmd.sdID);
			_remoteSharedObject.setProperty("linePath", cmd.linePath);
			_remoteSharedObject.setProperty("x", cmd.x);
			_remoteSharedObject.setProperty("y", cmd.y);			
			_remoteSharedObject.setProperty("width", cmd.width);
			_remoteSharedObject.setProperty("height", cmd.height);
			_remoteSharedObject.setProperty("color", cmd.color);			
		}
		
		public function processUpdate_PencilDrawingCreated(event:SyncEvent) : void
		{
			Logger.info("processUpdate_PencilDrawingCreated()",this);		
			
			var cmd:AddPencilDrawingCommand = new AddPencilDrawingCommand(diagramModel)
			cmd.sdID		= parseInt(event.target.data["sdID"]);
			cmd.linePath	= event.target.data["linePath"];
			cmd.x 			= parseFloat(event.target.data["x"]);
			cmd.y 			= parseFloat(event.target.data["y"]);
			cmd.width		= parseFloat(event.target.data["width"]);
			cmd.height		= parseFloat(event.target.data["height"]);
			cmd.color		= event.target.data["color"];
			
			cmd.execute();	
		}
		
		public function dispatchUpdate_CreateLineComponent(cmd:AddLineCommand) : void
		{
			Logger.info("dispatchUpdate_CreateLineComponent()",this);
			
			_remoteSharedObject.setProperty("commandName", "CreateLineComponent");
			_remoteSharedObject.setProperty("sdID", cmd.sdID);
			_remoteSharedObject.setProperty("x", cmd.x);
			_remoteSharedObject.setProperty("y", cmd.y);			
			_remoteSharedObject.setProperty("endX", cmd.endX);
			_remoteSharedObject.setProperty("endY", cmd.endY);			
			_remoteSharedObject.setProperty("startLineStyle", cmd.startLineStyle);
			_remoteSharedObject.setProperty("endLineStyle", cmd.endLineStyle);
			_remoteSharedObject.setProperty("lineWeight", cmd.lineWeight);		
		}
		
		public function processUpdate_CreateLineComponent(event:SyncEvent) : void
		{
			Logger.info("processUpdate_CreateLineComponent()",this);		
			
			var cmd:AddLineCommand = new AddLineCommand(diagramModel)
			cmd.sdID		= parseInt(event.target.data["sdID"]);
			cmd.x 			= parseFloat(event.target.data["x"]);
			cmd.y 			= parseFloat(event.target.data["y"]);
			cmd.endX		= parseFloat(event.target.data["endX"]);
			cmd.endY		= parseInt(event.target.data["endY"]);
			cmd.startLineStyle	= parseInt(event.target.data["defaultStartLineStyle"]);
			cmd.endLineStyle	= parseInt(event.target.data["defaultEndLineStyle"]);
			cmd.lineWeight		= event.target.data["defaultLineWeight"];
			
			cmd.execute();				
		}
		
		public function dispatchUpdate_RefreshZoom(): void
		{
			Logger.info("dispatchUpdate_RefreshZoom()",this);
			
			_remoteSharedObject.setProperty("commandName", "RefreshZoom");
			_remoteSharedObject.setProperty("scaleX", diagramModel.scaleX);
			_remoteSharedObject.setProperty("scaleY", diagramModel.scaleY);						
		}
		
		public function processUpdate_RefreshZoom(event:SyncEvent) : void
		{
			Logger.info("processUpdate_CreateLineComponent()",this);	
			diagramModel.scaleX = parseFloat(event.target.data["scaleX"]);
			diagramModel.scaleY = parseFloat(event.target.data["scaleY"]);			
		}
		
		public function dispatchUpdate_ChangeLinePosition(cmd:ChangeLinePositionCommand):void
		{
			Logger.info("dispatchUpdate_ChangeLinePosition()",this);
			
			_remoteSharedObject.setProperty("commandName", "ChangeLinePosition");
			
			//SDObjectMemento attributes
			_remoteSharedObject.setProperty("sdID", cmd.toState.sdID);
			_remoteSharedObject.setProperty("x", cmd.toState.x);
			_remoteSharedObject.setProperty("y", cmd.toState.y);
			_remoteSharedObject.setProperty("height", cmd.toState.height);
			_remoteSharedObject.setProperty("width", cmd.toState.width);
			_remoteSharedObject.setProperty("rotation", cmd.toState.rotation);
			_remoteSharedObject.setProperty("zIndex", cmd.toState.zIndex);
			_remoteSharedObject.setProperty("color", cmd.toState.color);
			
			// SDLineMemento attributes
			_remoteSharedObject.setProperty("startLineStyle", cmd.toState.startLineStyle);
			_remoteSharedObject.setProperty("endLineStyle", cmd.toState.endLineStyle);
			_remoteSharedObject.setProperty("lineWeight", cmd.toState.lineWeight);
			_remoteSharedObject.setProperty("startX", cmd.toState.startX);
			_remoteSharedObject.setProperty("startY", cmd.toState.startY);
			_remoteSharedObject.setProperty("endX", cmd.toState.endX);
			_remoteSharedObject.setProperty("endY", cmd.toState.endY);
			_remoteSharedObject.setProperty("bendX", cmd.toState.bendX);
			_remoteSharedObject.setProperty("bendY", cmd.toState.bendY);			
		}
		
		public function processUpdate_ChangeLinePosition(event:SyncEvent):void
		{
			Logger.info("processUpdate_ChangeLinePosition()",this);		
						
			var toState:SDLineMemento = new SDLineMemento();	
			toState.sdID 		= parseInt(event.target.data["sdID"]);
			toState.x 			= parseInt(event.target.data["x"]);
			toState.y 			= parseInt(event.target.data["y"]);
			toState.height 		= parseFloat(event.target.data["height"]);
			toState.width 		= parseFloat(event.target.data["width"]);
			toState.rotation 	= parseInt(event.target.data["rotation"]);
			toState.zIndex 		= parseInt(event.target.data["zIndex"]);
			toState.color 		= parseInt(event.target.data["color"]);
			
			toState.startLineStyle 	= parseInt(event.target.data["startLineStyle"]);
			toState.endLineStyle 	= parseInt(event.target.data["endLineStyle"]);
			toState.lineWeight 		= parseInt(event.target.data["lineWeight"]);			
			toState.startX 			= parseInt(event.target.data["startX"]);
			toState.startY 			= parseInt(event.target.data["startY"]);
			toState.endX 			= parseInt(event.target.data["endX"]);
			toState.endY 			= parseInt(event.target.data["endY"]);
			toState.bendX 			= parseInt(event.target.data["bendX"]);
			toState.bendY 			= parseInt(event.target.data["bendY"]);
			
			var cmd:ChangeLinePositionCommand = new ChangeLinePositionCommand(diagramModel)
			cmd.sdID 			= parseInt(event.target.data["sdID"]);
			cmd.toState = toState;
			
			var sdLineModel:SDLineModel = diagramModel.getModelByID(cmd.sdID) as SDLineModel;
			cmd.fromState = sdLineModel.getMemento() as SDLineMemento;
			
			cmd.execute();
		}
		
		public function dispatchUpdate_SymbolTextEdit(sdSymbolModel:SDSymbolModel):void
		{
			Logger.info("dispatchUpdate_SymbolTextEdit()",this);		
			
			_remoteSharedObject.setProperty("commandName", "SymbolTextEdit");
			_remoteSharedObject.setProperty("sdID", sdSymbolModel.sdID);
			_remoteSharedObject.setProperty("text", sdSymbolModel.text);
		}
		
		public function processUpdate_SymbolTextEdit(event:SyncEvent):void
		{
			Logger.info("processUpdate_SymbolTextEdit()",this);		
			
			var sdID:Number = parseInt(event.target.data["sdID"]);
			var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
			SDSymbolModel(sdObjectModel).text = event.target.data["text"];			
		}

		[Mediate(event="RemoteSharedObjectEvent.DISPATCH_TEXT_AREA_CHANGE")]
		public function dispatchUpdate_SDTextAreaModel_Text(event:RemoteSharedObjectEvent):void
		{
			Logger.info("dispatchUpdate_SDTextAreaModel_Text()",this);		
			
			_remoteSharedObject.setProperty("commandName", "SDTextAreaModel_Text");
			_remoteSharedObject.setProperty("sdID", event.sdID);
			_remoteSharedObject.setProperty("text", event.text);
		}
		
		public function processUpdate_SDTextAreaModel_Text(event:SyncEvent):void
		{
			Logger.info("processUpdate_SDTextAreaModel_Text()",this);		
			
			var sdID:Number = parseInt(event.target.data["sdID"]);
			var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
			(sdObjectModel as SDTextAreaModel).text = event.target.data["text"];	
		}
		
		[Mediate(event="StyleEvent.CHANGE_STYLE")]
		public function dispatchUpdate_StyleChanged(event:StyleEvent):void
		{
			_remoteSharedObject.setProperty("commandName", "StyleChanged");
			_remoteSharedObject.setProperty("styleName", event.styleName);
		}
		
		public function processUpdate_StyleChanged(event:SyncEvent):void
		{
			diagramStyleManager.changeStyle(event.target.data["styleName"])
		}
		
		[Mediate(event="RemoteSharedObjectEvent.CHANGE_ALL_SHAPES_TO_DEFAULT_COLOR")]
		public function dispatchUpdate_ChangeAllShapesToDefaultColor():void
		{
			_remoteSharedObject.setProperty("commandName", "ChangeAllShapesToDefaultColor");			
		}
		
		public function processUpdate_ChangeAllShapesToDefaultColor(event:SyncEvent):void
		{
			diagramModel.changeAllShapesToDefaultColor();
		}
		
		[Mediate(event="RemoteSharedObjectEvent.LOAD_IMAGE")]
		public function dispatchUpdate_LoadImage(rsoEvent:RemoteSharedObjectEvent):void
		{
			_netConnection.call("sendJPG", null, rsoEvent.imageData, 
				rsoEvent.sdImageModel.sdID,
				rsoEvent.sdImageModel.x,
				rsoEvent.sdImageModel.y,
				rsoEvent.sdImageModel.width,
				rsoEvent.sdImageModel.height,
				rsoEvent.sdImageModel.zIndex,
				rsoEvent.sdImageModel.origHeight,
				rsoEvent.sdImageModel.origWidth,
				rsoEvent.sdImageModel.styleName);
		}
		
		[Mediate(event="RemoteSharedObjectEvent.CHANGE_COLOR")]
		public function dispatchUpdate_ChangeColor(event:RemoteSharedObjectEvent):void
		{
			Logger.info("dispatchUpdate_ChangeColor()",this);		
			
			_remoteSharedObject.setProperty("commandName", "ChangeColor");
			_remoteSharedObject.setProperty("sdID", event.sdID);
			_remoteSharedObject.setProperty("color", event.color);
		}
		
		public function processUpdate_ChangeColor(event:SyncEvent):void
		{
			Logger.info("processUpdate_ChangeColor()",this);		
			
			var sdID:Number = parseInt(event.target.data["sdID"]);
			var sdObjectModel:SDObjectModel = diagramModel.getModelByID(sdID);
			
			var cmd:ChangeColorCommand = new ChangeColorCommand(diagramModel, sdObjectModel);
			cmd.color = event.target.data["color"];	
			cmd.execute();
		}
		
		
		
	}	
}

