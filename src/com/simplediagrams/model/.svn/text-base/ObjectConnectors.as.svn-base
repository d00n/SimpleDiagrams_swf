package com.simplediagrams.model
{
	
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.SDBase;
	import com.simplediagrams.view.SDComponents.SDLine;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ObjectConnectors extends EventDispatcher
	{
		
		public static const START_CONNECTION_DRAG:String = "startConnectionDrag"
		public static const CONNECTOR_ADDED:String = "connectorAdded"
				
		protected var _container:Sprite
		protected var connectionsDict:Dictionary = new Dictionary()
		
		public var currFromComponent:SDBase	
		public var dragCircleX:Number = 0		
		public var dragCircleY:Number = 0		
		
		public var _sdObjectHandles:SDObjectHandles
		
		public var sdBaseArr:Array = [] 
		
		public var connectorDragging:Boolean = false
			
		public function ObjectConnectors(sdObjectHandles:SDObjectHandles)
		{
			_sdObjectHandles = sdObjectHandles
		}
		
			
		
		public function addConnector(fromModel:SDBase, toModel:SDBase, line:SDLine):void
		{
			Logger.debug("adding connector from : "+ fromModel+" to:" +toModel, this)
			
			var connectorModel:ConnectorModel = new ConnectorModel()						
			connectorModel.createConnectorComponent(fromModel.objectModel, toModel.objectModel, SDLineModel(line.objectModel))
						
			if (connectionsDict[fromModel]==undefined)
			{
				connectionsDict[fromModel] = new ArrayCollection()	
			}
			
			connectionsDict[fromModel].push(connectorModel)	
					
		}
		
		
	
		
		
		public function removeAll():void
		{
			for each (var connectorModelAC:ArrayCollection in connectionsDict)
			{
				for each (var connectorModel:ConnectorModel in connectorModelAC)
				{
					connectorModel.destroy()
				}
			}
			
			connectionsDict = new Dictionary()
		}
		
	}
}