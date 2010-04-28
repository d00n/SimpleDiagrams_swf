package com.simplediagrams.controllers
{
	
	import com.simplediagrams.events.EditSymbolTextEvent;
	import com.simplediagrams.model.*;
	import com.simplediagrams.util.Logger;
	
	import flash.events.MouseEvent;
	
	import mx.controls.TextArea;
	
	import org.swizframework.controller.AbstractController;
			
	public class SymbolEditController extends AbstractController
	{
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;
		
		
		public function SymbolEditController()
		{
			
		}
				
		[Mediate(event='EditSymbolTextEvent.EDIT_SYMBOL_TEXT')]
		public function onEditSymbolTextEvent(event:EditSymbolTextEvent):void
		{			
			var model:SDSymbolModel = event.sdSymbolModel					
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			Logger.debug("onMouseClick",this)
		}
		
	}
}