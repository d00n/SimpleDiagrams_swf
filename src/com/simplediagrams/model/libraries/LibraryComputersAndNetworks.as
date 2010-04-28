package com.simplediagrams.model.libraries
{
	
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.shapelibrary.computersAndNetworks.*
	import com.simplediagrams.shapelibrary.basic.Arrow
	
	[Bindable]
	public class LibraryComputersAndNetworks extends AbstractLibrary implements ILibrary
	{
		
		
		ComputingCloud;
		Computer;
		Database;
		Firewall;
		Folder;
		GnarledMess;
		PBX;
		Laptop;
		Rack;
		Server;
		Server1U;
		Router;
		Switch;
		Webcam;
		Printer
		Desktop;
		WirelessAccessPoint;
		WirelessRouter;
		Cursor;
		Virus;
		
		public function LibraryComputersAndNetworks()
		{									
			libraryName ="com.simplediagrams.shapelibrary.computersAndNetworks"
			displayName = "Computers/Networks"
			isPremium = true
			
			super()			
		}
		
		override public function initShapes():void
		{
						
			addLibraryItem( new SDSymbolModel("Computer"))
			addLibraryItem( new SDSymbolModel("Laptop"))
			addLibraryItem( new SDSymbolModel("Desktop"))
			addLibraryItem( new SDSymbolModel("Database", 30))
			addLibraryItem( new SDSymbolModel("Firewall"))
			addLibraryItem( new SDSymbolModel("Rack")) 
			addLibraryItem( new SDSymbolModel("Server"))
			addLibraryItem( new SDSymbolModel("Server1U", 50, 30))
			addLibraryItem( new SDSymbolModel("ComputingCloud"))
			addLibraryItem( new SDSymbolModel("PBX"))
			addLibraryItem( new SDSymbolModel("Router"))
			addLibraryItem( new SDSymbolModel("Switch"))
			addLibraryItem( new SDSymbolModel("GnarledMess"))
			addLibraryItem( new SDSymbolModel("Folder"))
			addLibraryItem( new SDSymbolModel("Webcam",30))
			addLibraryItem( new SDSymbolModel("Printer"))
			addLibraryItem( new SDSymbolModel("WirelessAccessPoint", 30))
			addLibraryItem( new SDSymbolModel("WirelessRouter"))
			addLibraryItem( new SDSymbolModel("Cursor", 30))
			addLibraryItem( new SDSymbolModel("Virus"))
			
		}
		
		
	}
}