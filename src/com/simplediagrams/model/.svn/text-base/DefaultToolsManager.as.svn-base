package com.simplediagrams.model
{
	
	import com.simplediagrams.util.Logger;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	

	[Bindable]
	public class DefaultToolsManager  extends EventDispatcher
	{
					
		[Embed(source='assets/tool_shapes/default_tools.swf', symbol='PhotoTool')]
		public var PhotoToolIcon:Class;
		
		
		[Embed(source='assets/tool_shapes/default_tools.swf', symbol='StickyNote')]
		public var StickyNote:Class		
		
		[Embed(source='assets/tool_shapes/default_tools.swf', symbol='IndexCard')]
		public var IndexCard:Class		
		
		[Embed(source='assets/tool_shapes/default_tools.swf', symbol='Napkin')]
		public var Napkin:Class		
				
		
		public static const DEFAULT_TOOLS:String = "defaultTools";
		
		public static const IMAGE_TOOL:String = "imageTool"
		public static const STICKY_NOTE_TOOL:String = "stickyNoteTool"
		public static const INDEX_CARD:String = "indexCard"
		public static const NAPKIN:String = "napkin"
						
						
		public var sdObjectsAC:ArrayCollection = new ArrayCollection()
					
		public function DefaultToolsManager()
		{
			
			sdObjectsAC = new ArrayCollection()
			
			var sdObj:SDSymbolModel = new SDSymbolModel()
			sdObj.libraryName = DefaultToolsManager.DEFAULT_TOOLS
			sdObj.symbolName = IMAGE_TOOL
			sdObj.displayName = "photo"
			sdObj.iconClass = PhotoToolIcon
			sdObjectsAC.addItem(sdObj)
						
			sdObj = new SDSymbolModel()
			sdObj.libraryName = DefaultToolsManager.DEFAULT_TOOLS
			sdObj.symbolName = STICKY_NOTE_TOOL
			sdObj.displayName = "stickyNote"
			sdObj.iconClass = StickyNote
			sdObjectsAC.addItem(sdObj)
				
			sdObj = new SDSymbolModel()
			sdObj.libraryName = DefaultToolsManager.DEFAULT_TOOLS
			sdObj.symbolName = INDEX_CARD
			sdObj.displayName = "indexCard"
			sdObj.iconClass = IndexCard
			sdObjectsAC.addItem(sdObj)
				
			
			/*
			sdObj = new SDSymbolModel()
			sdObj.libraryName = DefaultToolsManager.DEFAULT_TOOLS
			sdObj.symbolName = NAPKIN
			sdObj.displayName = "napkin"
			sdObj.iconClass = Napkin
			sdObjectsAC.addItem(sdObj)
			*/
				
			sdObjectsAC.refresh()
			Logger.debug("### 	basic tools created!", this)
			
		}
		
		
	}
}