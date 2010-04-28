package com.simplediagrams.model
{

	import com.simplediagrams.model.libraries.*;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.vo.RecentFileVO;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.utils.ObjectUtil;


	[Bindable]
	public class LibraryManager extends EventDispatcher 
	{		
		
		/*
		[Autowire(bean="dbManager")]
		public var db:DBManager;
		*/
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;
		
		public static const PANEL_UPDATED:String="panelUpdated" //launched as event when the user manages the library
		
		public var diagramsAC:ArrayCollection = new ArrayCollection()
		public var recentDiagramsAC:ArrayCollection = new ArrayCollection()
		
		public var libraryBasic:LibraryBasic = new LibraryBasic()	
		public var libraryBiz:LibraryBiz = new LibraryBiz()	
		public var libraryMeetings:LibraryMeetings = new LibraryMeetings()	
		public var libraryCommunication:LibraryCommunication = new LibraryCommunication()	
		public var libraryMaterials:LibraryMaterials = new LibraryMaterials()	
					
		public var librariesAC:ArrayCollection = new ArrayCollection()
		
		public var availableForDownloadLibrariesAC:ArrayCollection = new ArrayCollection()
		protected var rememberShowInPanelSettingsArr:Array = []	
			
		public function LibraryManager()
		{					
			librariesAC.addItem(libraryBasic)
			librariesAC.addItem(libraryBiz)
			librariesAC.addItem(libraryMeetings)
			librariesAC.addItem(libraryCommunication)
			librariesAC.refresh()
		}
		
		public function addLibrary(library:ILibrary):void
		{
			librariesAC.addItem(library)
			librariesAC.refresh()
		}
		
		public function removeLibrary(libraryName:String):void
		{
			var len:uint = librariesAC.length
			for(var i:uint=0; i<len;i++)
			{
				var library:ILibrary = librariesAC.getItemAt(i) as ILibrary
				if (library.libraryName == libraryName)
				{
					librariesAC.removeItemAt(i)
				}
			}			
			librariesAC.refresh()
		}
		
		public function hidePremiumLibraries():void
		{
			librariesAC.filterFunction = hidePremiumLibs
			librariesAC.refresh()
		}
		
		public function showPremiumLibraries():void
		{
			librariesAC.filterFunction = null
			librariesAC.refresh()
		}
		
		protected function hidePremiumLibs(item:Object):Boolean 
		{			
			return !item.isPremium
		}
		
		public function getSDObject(libraryName:String, templateName:String):SDObjectModel
		{
			for each (var lib:ILibrary in librariesAC)
			{				
				if (libraryName==lib.libraryName)
				{
					return lib.getSDObject(templateName)
				}
			}
			
			Logger.warn("Couldn't find SDObject for libraryName: " + libraryName + " templateName: " + templateName)
			return null
		}
	
		
		public function getSymbolClass(libraryName:String, templateName:String):Class
		{
			for each (var lib:ILibrary in librariesAC)
			{
				if (libraryName==lib.libraryName)
				{
					return lib.getSymbolClass(templateName)
				}
			}
			return null
		}
		
		public function getLibraryByFileName(fileName:String):ILibrary
		{
			for each (var lib:ILibrary in librariesAC)
			{
				if (lib.fileName==fileName)
				{
					return lib
				}
			}
			return null
		}
		
		public function loadInitialData():void
		{			
			loadDiagrams()
		}
				
										
		public function loadDiagrams():void
		{		
			recentDiagramsAC = new ArrayCollection(diagramsAC.source.concat())
			sortRecentDiagrams()
		}
		
		public function sortRecentDiagrams():void
		{
			var sort:Sort = new Sort();
	    	sort.compareFunction = sortDiagramUpdatedAt;
	    	recentDiagramsAC.sort = sort;
			recentDiagramsAC.refresh()						
		}
				
		private function sortDiagramUpdatedAt(a:Object, b:Object, fields:Array = null):int 
		{			
		    return ObjectUtil.dateCompare( b.updatedAt, a.updatedAt);
		}
		
		public function libraryExists(libraryName:String):Boolean
		{
			for each (var library:ILibrary in this.librariesAC)
			{
				if (library.libraryName == libraryName) return true
			}
			
			return false
		}
		
		public function libraryFileExists(fileName:String):Boolean
		{
			for each (var library:ILibrary in this.librariesAC)
			{
				if (library.fileName == fileName) return true
			}
			
			return false
		}
		
		public function addRecentFilePath(path:String, fileName:String):void
		{
			//don't add if already on list
			var len:uint = recentDiagramsAC.length
			for (var i:uint=0; i< len; i++)
			{
				if (recentDiagramsAC.getItemAt(i).data==path)
				{
					if (i==0) return
					//move path to top of list
					var vo:RecentFileVO = recentDiagramsAC.removeItemAt(i) as RecentFileVO
					recentDiagramsAC.addItemAt(vo, 0)
					return
				}
			}
			
			var recentFileVO:RecentFileVO = new RecentFileVO()
			recentFileVO.data = path
			recentFileVO.label = fileName
			recentDiagramsAC.addItemAt(recentFileVO, 0)
			if (recentDiagramsAC.length>10) recentDiagramsAC.removeItemAt(10)
			recentDiagramsAC.refresh()
		}
		
		
		public function rememberShowInPanelSettings():void
		{
			try
			{
				var len:uint = this.librariesAC.length
				for (var i:uint=0; i< len; i++)
				{
					rememberShowInPanelSettingsArr[i] = ILibrary(librariesAC.getItemAt(i)).showInPanel
				}	
			}
			catch(err:Error)
			{
				Logger.error("rememberShowInPanelSettings() Couldn't remember show in panel settings. Err:" + err, this)
			}
		}
		
		public function revertShowInPanelSettings():void
		{
			try
			{
				var len:uint = this.librariesAC.length
				for (var i:uint=0; i< len; i++)
				{
					ILibrary(librariesAC.getItemAt(i)).showInPanel = rememberShowInPanelSettingsArr[i] as Boolean
				}	
			}
			catch(err:Error)
			{
				Logger.error("revertShowInPanelSettings() Couldn't revert to show in panel settings. Err:" + err, this)
			}
		}
		
		public function updatePanel():void
		{
			dispatchEvent(new Event(PANEL_UPDATED, true))
		}
		
		public function clearRecentDiagrams():void
		{
			this.recentDiagramsAC.removeAll()
		}
		
		
	}
}