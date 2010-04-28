package com.simplediagrams.model.libraries
{
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.util.Logger;
	
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	
	public class AbstractLibrary implements ILibrary
	{
		
		protected var _isPremium:Boolean = false 	//not to be shown in free versions
		protected var _isPlugin:Boolean = false		//plugins will set this to true
		protected var _libraryName:String 			//the fully qualified name, e.g. com.simplediagrams.shapelibrary.basicClean
		protected var _fileName:String 				//the name of the file (same as last part of _libraryName)
		protected var _displayName:String 			//to be shown in UI
		protected var _showInPanel:Boolean = true;
		
		protected var _sdLibraryObjectsAC:ArrayCollection = new ArrayCollection()
		
		
		public function get sdLibraryObjectsAC():ArrayCollection
		{
			return _sdLibraryObjectsAC
		}
		
		public function set sdLibraryObjectsAC(ac:ArrayCollection):void
		{
			_sdLibraryObjectsAC = ac
		}
		
		public function AbstractLibrary()
		{
			initShapes()
			initLibrary()
		}
		
		public function initShapes():void
		{
			//override this
		}
		
		
		public function initLibrary():void
		{	
			Logger.debug("initLibrary() 		_sdLibraryObjectsAC.length: " + _sdLibraryObjectsAC.length, this)
		
			//attach actual graphic symbol to class
			for each (var sdObj:SDSymbolModel in _sdLibraryObjectsAC)
			{
				sdObj.libraryName = _libraryName
				var defName:String =  _libraryName + "." + sdObj.symbolName
				sdObj.iconClass = getDefinitionByName(defName) as Class
			}
						
			sdLibraryObjectsAC.refresh()
		}
		
		public function get libraryName():String
		{
			return _libraryName
		}
		
		public function set libraryName(value:String):void
		{
			_libraryName = value
		}
		
		public function get displayName():String
		{
			return _displayName
		}
		
		public function set displayName(value:String):void
		{
			_displayName = value
		}
		
		public function get fileName():String
		{
			return _fileName
		}
		
		public function set fileName(value:String):void
		{
			_fileName = value
		}
		
		
		public function get showInPanel():Boolean
		{
			return _showInPanel
		}
		
		public function set showInPanel(value:Boolean):void
		{
			_showInPanel = value
		}
		
		
		public function get isPremium():Boolean
		{
			return _isPremium
		}
		
		public function set isPremium(value:Boolean):void
		{
			_isPremium = value
		}
		
		
		public function get isPlugin():Boolean
		{
			return _isPlugin
		}
		
		public function set isPlugin(value:Boolean):void
		{
			_isPlugin = value
		}
		
		
		public function getSymbolClass(name:String):Class
		{
			 return getDefinitionByName(_libraryName + "." + name) as Class
		}
				
		public function getSDObject(symbolName:String):SDObjectModel
		{
			for each (var obj:SDSymbolModel in sdLibraryObjectsAC)
			{
				if (symbolName==obj.symbolName)
				{
					var sdObj:SDSymbolModel = obj.clone() as SDSymbolModel
					return sdObj
				}
			}
			
			Logger.warn("couldn't find symbolName: " + symbolName, this)
			return null
			
		}
		
		public function addLibraryItem(obj:Object):void
		{
			_sdLibraryObjectsAC.addItem(obj)
		}
	}
}