package com.simplediagrams.business
{
	
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.SettingsModel;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.vo.RecentFileVO;
	
//	import flash.filesystem.*;
	
	import mx.collections.ArrayCollection;

	public class SettingsManager
	{
						
		private var sdSettingsXML:XML; 				// The settings XML data
//		public var sdSettingsFile:File; 			// The preferences file stored in application storage dir -- this is the working file
//		private var stream:FileStream; 				// The FileStream object used to read and write prefsFile data.
	
		[Autowire(bean='settingsModel')]
		[Bindable]
		public var settingsModel:SettingsModel
		
		
		[Autowire(bean='libraryManager')]
		[Bindable]
		public var libraryManager:LibraryManager
			
		public function SettingsManager()
		{
//			//get settings xml path from ModelLocator
//			var sdSettingsFileDir:File = File.applicationStorageDirectory.resolvePath("settings")					
//			sdSettingsFile = sdSettingsFileDir.resolvePath("simplediagrams_settings.xml")	
//				
//			if(!sdSettingsFileDir.exists)
//			{
//				try
//				{
//					sdSettingsFileDir.createDirectory()
//				}
//				catch(error:Error)
//				{					
//					Logger.error("Couldn't create settings directory. Error : " + error,this)
//				}
//			}
//			
			
		}
		
		/** Load settings from .xml file and return a value object */
		public function loadSettings():void
		{
			Logger.debug("loadSettings()", this)
			loadXML()
		}
		
		/** Save settings to .xml file based on information passed in via value object */
		public function saveSettings():Boolean
		{	
			try
			{
				createAppSettingsXML(); 
				writeAppSettingsXML();
			}
			catch(err:Error)
			{
				Logger.error("couldn't save settings: " + err, this)
				return false
			}
			return true
		}
		
		/** Load xml from settings file */ 
		private function loadXML():void
		{
//			if (sdSettingsFile.exists) 
//			{
//				stream = new FileStream();
//    			stream.open(sdSettingsFile, FileMode.READ);
//    			try
//    			{
//    				sdSettingsXML = XML(stream.readUTFBytes(stream.bytesAvailable));
//					stream.close();
//			    	processXMLData();
//    			}
//    			catch(err:Error)
//    			{
//    				Logger.error(" error reading settings XML file. Reverting to internal settings defaults. Error: " + err, this)
//    			}    			
//			}
//			else
//			{
//				//if file doesn't exist, use internal defaults
//				Logger.debug(" no XML file exists for settings...leaving internal defaults.", this)
//				saveSettings()
//			}			
//			
		}

		private function processXMLData():void
		{
//			
//			settingsModel.defaultDiagramStyle = sdSettingsXML.defaultStyle.@name			
//			settingsModel.defaultEndLineStyle = sdSettingsXML.defaultStyle.@defaultEndLineStyle
//			settingsModel.defaultStartLineStyle = sdSettingsXML.defaultStyle.@defaultStartLineStyle 
//			settingsModel.defaultTextPosition = sdSettingsXML.defaultStyle.@defaultTextPosition 
//			
//			var lineWeight:uint = sdSettingsXML.defaultStyle.@defaultLineWeight
//			if (lineWeight<1) lineWeight = 0
//			if (lineWeight>100) lineWeight = 100
//			settingsModel.defaultLineWeight = lineWeight			
//			
//			//read in previously opened files
//			for each (var fileXML:XML in sdSettingsXML.recentFiles.*)
//			{
//				var nativePath:String = fileXML.@nativePath
//				var recentFileVO:RecentFileVO = new RecentFileVO()
//				if (nativePath!="")
//				{
//					recentFileVO.data = nativePath
//					recentFileVO.label = new File(nativePath).name
//					libraryManager.recentDiagramsAC.addItem(recentFileVO)
//				}
//			}
		}
		
				
		private function createAppSettingsXML():void 
		{
			sdSettingsXML = <appSettings>
								<defaultStyle/>
								<recentFiles/>
							</appSettings>
			/*
			appSettingsXML.windowState.@width = stage.nativeWindow.width;
			appSettingsXML.windowState.@height = stage.nativeWindow.height;
			appSettingsXML.windowState.@x = stage.nativeWindow.x;
			appSettingsXML.windowState.@y = stage.nativeWindow.y;
			*/
			
			sdSettingsXML.defaultStyle.@name = settingsModel.defaultDiagramStyle
			sdSettingsXML.defaultStyle.@defaultEndLineStyle = settingsModel.defaultEndLineStyle
			sdSettingsXML.defaultStyle.@defaultStartLineStyle = settingsModel.defaultStartLineStyle
			sdSettingsXML.defaultStyle.@defaultLineWeight = settingsModel.defaultLineWeight
			sdSettingsXML.defaultStyle.@defaultTextPosition = settingsModel.defaultTextPosition
			
			var recentFilesAC:ArrayCollection = settingsModel.recentFilesAC
			var len:uint = libraryManager.recentDiagramsAC.length
			for (var i:uint=0;i<len;i++)
			{
				var newChild:XML = <recentFile />
				newChild.@nativePath = libraryManager.recentDiagramsAC.getItemAt(i).data	
				sdSettingsXML.recentFiles.appendChild(newChild)		
			}
			
		}
		
		private function writeAppSettingsXML():void 
		{
//			Logger.debug("writing settings file to : " + sdSettingsFile.nativePath, this)
//				
//			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>' +  File.lineEnding
//			outputString += sdSettingsXML.toXMLString();
//			//outputString = outputString.replace(/\n/g, File.lineEnding);
//			
//			stream = new FileStream()
//			stream.open(sdSettingsFile, FileMode.WRITE);
//			try
//			{
//				stream.writeUTFBytes(outputString);
//			}
//			catch(err:Error)
//			{
//				Logger.error("couldn't write settings file to : " + sdSettingsFile.nativePath, this)
//			}
//			stream.close();
		}

	}
}