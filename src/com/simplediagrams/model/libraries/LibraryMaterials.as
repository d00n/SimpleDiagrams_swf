package com.simplediagrams.model.libraries
{
	
	import com.simplediagrams.model.SDSymbolModel;
	
	import com.simplediagrams.shapelibrary.materials.*
	
	public class LibraryMaterials extends AbstractLibrary implements ILibrary
	{
		BrownNapkin;
				
		public function LibraryMaterials()
		{ 		
			libraryName ="com.simplediagrams.shapelibrary.materials"
			displayName = "Materials"
			super()
		}
		
		override public function initShapes():void
		{			
			addLibraryItem( new SDSymbolModel("BrownNapkin", 500, 500, false))
		}
		
		
	}
}