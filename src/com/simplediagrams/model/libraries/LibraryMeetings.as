package com.simplediagrams.model.libraries
{
	
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.util.Logger;
	
	import mx.collections.ArrayCollection;
	
	import com.simplediagrams.shapelibrary.meetings.*



	[Bindable]
	public class LibraryMeetings extends AbstractLibrary implements ILibrary
	{
		
				
		 Chart;
		 CoffeeBreak;
		 BarGraph;
		 Grid;
		 LargeMeeting;
		 SmallMeeting;
		 PaperChart;
		 Papers;
		 Projector;
		 Table;
		 TV;
		
				
		public function LibraryMeetings()
		{ 
			
			libraryName ="com.simplediagrams.shapelibrary.meetings"
			displayName = "Meetings"
				
			super()
		}
		
		override public function initShapes():void
		{
			
			addLibraryItem( new SDSymbolModel("LargeMeeting"))
			addLibraryItem( new SDSymbolModel("SmallMeeting"))
			addLibraryItem( new SDSymbolModel("Chart"))
			addLibraryItem( new SDSymbolModel("BarGraph"))
			addLibraryItem( new SDSymbolModel("Grid"))
			addLibraryItem( new SDSymbolModel("PaperChart"))
			addLibraryItem( new SDSymbolModel("Papers"))
			addLibraryItem( new SDSymbolModel("Projector"))
			addLibraryItem( new SDSymbolModel("Table"))
			addLibraryItem( new SDSymbolModel("CoffeeBreak"))
			addLibraryItem( new SDSymbolModel("TV"))
		}
		
		
		

		
	}
}