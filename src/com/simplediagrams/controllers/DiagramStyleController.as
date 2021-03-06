package com.simplediagrams.controllers
{
	
	import com.simplediagrams.events.StyleEvent;
	import com.simplediagrams.model.*;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.dialogs.*;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.swizframework.controller.AbstractController;

	public class DiagramStyleController extends AbstractController
	{
		[Autowire(bean="diagramStyleManager")]
		public var diagramStyleManager:DiagramStyleManager;
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;

		[Autowire(bean="remoteSharedObjectController")]
		public var remoteSharedObjectController:RemoteSharedObjectController
		
		public function DiagramStyleController()
		{
		}
			
        [Mediate(event="StyleEvent.CHANGE_STYLE")]
		public function onStyleChange(event:StyleEvent):void 
		{		
			Logger.debug("onStyleChange()",this)
			
			if (diagramStyleManager.currStyle == event.styleName || event.styleName==null)
			{
				return
			}
			
			Logger.debug("setting style to : " + event.styleName, this)
			diagramStyleManager.changeStyle(event.styleName)
			
			if (event.isLoadedStyle==false && diagramModel.numSDObjects>0)
			{
				Alert.show("Change shape colors to fit new style?", "", Alert.YES | Alert.NO, null, onChangeColorResponse)
  			}
  			
  		}
  
  		protected function onChangeColorResponse(event:CloseEvent):void
  		{
  			if (event.detail==Alert.YES)
			{
				diagramModel.changeAllShapesToDefaultColor()
			}
  		}
		
		
	}
}