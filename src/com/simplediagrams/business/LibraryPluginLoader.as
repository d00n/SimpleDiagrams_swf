package com.simplediagrams.business
{
	
	/* This class manages loading in stored libraries from the applicationStorage folder and putting them in the library */
	
	import com.adobe.example.signature.SignatureValidator;
	import com.simplediagrams.model.libraries.ILibraryModule;
	import com.simplediagrams.util.Logger;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
//	import flash.filesystem.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.core.IFlexModuleFactory;
	import mx.modules.IModuleInfo;
		
		
	public class LibraryPluginLoader extends EventDispatcher
	{
		
		public static const LOAD_ERROR:String = "loadError"
		public static const LOAD_COMPLETE:String = "loadComplete"
			
		public var errorMessage:String = ""
		
//		protected var _libraryFile:File 	
		
		//Since we'll be looping through each directory and the reads are asynchronous, we'll have to count stuff manually to know when we're done
		protected var _numToLoad:uint			//number of library files to try to load
		protected var _currLoadingIndex:uint			//number we're currently trying to load 
			
		//This holds each module that's created from library file
		protected var _libraryModuleInfo:IModuleInfo
		public var _libraryModule:ILibraryModule
		
		public function LibraryPluginLoader()
		{
		}
		
		public function get libraryModule():ILibraryModule
		{
			return _libraryModule
		}
		
		public function get name():String
		{
//			if (_libraryFile)
//			{
//				return _libraryFile.name	
//			}
			return "(no file)"	
		}
				
//		public function loadLibrary(file:File):void
//		{	
//			Logger.debug("Loading file: " + file.name,this)
//			_libraryFile = file
//			try
//			{
//				//load library from storage and validate it
//				var sigVal:SignatureValidator = new SignatureValidator()
//				var sigFile:File = _libraryFile.resolvePath("META-INF/signatures.xml")
//				Logger.debug("sigFile: " + sigFile.nativePath,this)
//				sigVal.addEventListener("VALID", onLibraryValidated)
//				sigVal.addEventListener("INVALID", onLibraryInvalid)
//				sigVal.loadFile(sigFile)
//				sigVal.validate()	
//			}
//			catch (err:Error)
//			{
//				errorMessage =  "Couldn't load library " + _libraryFile.name + " error: " + err.toString()
//				var evt:Event = new Event(LOAD_ERROR, true)
//				dispatchEvent(evt)
//			}				
//								
//		}
			
		protected function onLibraryInvalid(event:Event):void
		{
//			Logger.debug("Library invalid: " + event, this)
//			errorMessage =  "Tried to load library " + _libraryFile.name + " but it appears invalid."
//			var evt:Event = new Event(LOAD_ERROR, true)
//			dispatchEvent(evt)
		}
		
		protected function onLibraryValidated(event:Event):void
		{				
//			Logger.debug("Library valid: " + event, this)
//			var swfFile:File = _libraryFile.resolvePath(_libraryFile.name+".swf")			
//			if (swfFile.exists==false)
//			{
//				errorMessage = "Couldn't find .swf file called " + swfFile.name + " in library package"
//				var evt:Event = new Event(LOAD_ERROR, true)
//				dispatchEvent(evt)
//				return
//			}
//			
//			
//			/* Can't use the usual way of loading module since we want to load it into the ApplicationContext */
//			/*
//			_libraryModuleInfo = ModuleManager.getModule(swfFile.url)
//			_libraryModuleInfo.addEventListener(ModuleEvent.READY, onModuleReady)
//			_libraryModuleInfo.addEventListener(ModuleEvent.ERROR, onModuleError)
//			_libraryModuleInfo.load(ApplicationDomain.currentDomain)				
//			*/
//						
//			var stream:FileStream = new FileStream()
//			stream.open(swfFile,FileMode.READ)
//			var data:ByteArray = new ByteArray()
//			stream.readBytes(data, 0, stream.bytesAvailable) 
//			
//			//load module into LibraryManager					
//			var moduleLoader:Loader = new Loader();
//			var context:LoaderContext = new LoaderContext();
//			context.allowLoadBytesCodeExecution = true;
//			context.applicationDomain = ApplicationDomain.currentDomain;    			
//			moduleLoader.loadBytes(data, context);
//			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);	           
//			moduleLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
//		
//				
		}
		
		private function onLoaderIOError(event:IOErrorEvent):void 
		{
			errorMessage = "IOError loading module from swf. Error: " + event.toString();
			var evt:Event = new Event(LOAD_ERROR, true)
			dispatchEvent(evt)
			return
		}

		private function onLoaderComplete(e:Event): void 
		{
			Logger.debug("loader complete. Now setting listener for ready event",this)
			var moduleLoader:LoaderInfo = LoaderInfo(e.target);
			moduleLoader.content.addEventListener("ready", onModuleLoaderContentReady);
		}
		
		
		private function onModuleLoaderContentReady(e:Event): void 
		{
			
			Logger.debug("MODULE READY:...now loading",this)
			
			try
			{
				var factory:IFlexModuleFactory = IFlexModuleFactory(e.target);
				_libraryModule = ILibraryModule(factory.create())						
				Logger.debug("_libraryModule:" +_libraryModule,this)
				dispatchEvent(new Event(LOAD_COMPLETE, true))	
			}
			catch (error:Error)
			{
				Logger.debug("Error creating module from loading swf. Error: " + error.toString(), this)
				errorMessage = "Error creating module from loading swf"
				dispatchEvent(new Event(LOAD_ERROR, true))
				return
			}
			
		}
				
		
		
		
				
		
		
	}
}