package com.simplediagrams.model
{
	
	import com.roguedevelopment.objecthandles.constraints.*;
	import com.simplediagrams.events.ClearDiagramEvent;
	import com.simplediagrams.events.ConnectorAddedEvent;
	import com.simplediagrams.events.CreateNewDiagramEvent;
	import com.simplediagrams.events.DeleteSDComponentEvent;
	import com.simplediagrams.events.LoadDiagramEvent;
	import com.simplediagrams.events.RemoteSharedObjectEvent;
	import com.simplediagrams.events.StyleEvent;
	import com.simplediagrams.events.ToolEvent;
	import com.simplediagrams.model.dao.DiagramDAO;
	import com.simplediagrams.model.mementos.SDObjectMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.ISDComponent;
	import com.simplediagrams.view.SDComponents.SDBase;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.DynamicEvent;
	
	import org.swizframework.Swiz;
	
	import spark.components.Group;




	[Bindable]
	public class DiagramModel extends EventDispatcher
	{
	
	
		public static const SD_OBJECT_ADDED:String = "sdObjectAddedToDrawingBoardModel"
		public static const TOOL_CHANGED:String = "toolChanged"
		public static const SIZE_CHANGED:String = "toolChanged"
		
		public static const POINTER_TOOL:String = "pointerTool"
		public static const PENCIL_TOOL:String = "pencilTool"
		public static const TEXT_TOOL:String = "textTool"
		public static const PICTURE_TOOL:String = "pictureTool"
		public static const LINE_TOOL:String = "lineTool";
		public static const ZOOM_TOOL:String = "zoomTool";
		
		public static const DIAGRAM_BUILT:String = "diagramBuilt";
				
			
		[Autowire(bean="settingsModel")]
		public var settingsModel:SettingsModel;
		
		[Autowire(bean='diagramStyleManager')]
		public var diagramStyleManager:DiagramStyleManager
		
		public var firstBuild:Boolean = true
						
		protected var _isDirty:Boolean = false //flag for tracking user changes beyond saved state
		protected var _currToolType:String = POINTER_TOOL
		protected var _objectHandles:SDObjectHandles
		protected var _objectConnectors:ObjectConnectors 
		protected var _diagramDAO:DiagramDAO 
		protected var _currColor:Number 
		
		public var sdObjectModelsAC:ArrayCollection 
	
		public function DiagramModel()
		{
			_diagramDAO = new DiagramDAO()
			objectHandles = new SDObjectHandles();
            sdObjectModelsAC = new ArrayCollection()	
        	sdObjectModelsAC.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange)
        	//var constraint:MaintainProportionConstraint = new MaintainProportionConstraint()
        	//objectHandles.constraints.push(constraint)
        	
        	Swiz.addEventListener(StyleEvent.STYLE_CHANGED, onStyleChanged)
		}
		
		public function onCollectionChange(event:CollectionEvent):void
		{
			_isDirty = true;
		}
		
		public function initDiagramModel():void
		{	
			
			Logger.debug("initing diagram model", this)					
			_diagramDAO = new DiagramDAO()
						
			_currToolType = POINTER_TOOL
				
			dispatchEvent(new ClearDiagramEvent(ClearDiagramEvent.CLEAR_DIAGRAM, true))
			
			//clear out any existing stuff
			if (_objectConnectors)	_objectConnectors.removeAll()
			if (_objectHandles) _objectHandles.removeAll()
						
			//setup for new diagram
			sdObjectModelsAC.removeAll()	
			
			_isDirty = false	
		
		}
		
		public function getModelByID(sdID:Number):SDObjectModel
		{
			Logger.debug("looking for id: " + sdID, this)
			var len:uint =sdObjectModelsAC.length
			for (var i:uint =0;i<len;i++)
			{
				if (SDObjectModel(sdObjectModelsAC.getItemAt(i)).sdID == sdID) 
				{
					return sdObjectModelsAC.getItemAt(i) as SDObjectModel
				}
			}
			Logger.debug("couldn't find model with " + sdID, this)
			return null
		}
		
		public function addToSelected(sdObjectModel:SDObjectModel):void
		{
			objectHandles.selectionManager.addToSelected(sdObjectModel)
		}
		
		public function findModel(sdBase:SDBase):SDObjectModel
		{
			return objectHandles.findModel(sdBase) as SDObjectModel
		}
		
		public function set selectedArray(objArr:Array):void
		{
			//clear the existing selection
			objectHandles.selectionManager.clearSelection()
			
			for each (var obj:Object in objArr)
			{
				if (obj is SDObjectModel) this.addToSelected(obj as SDObjectModel)
			}
		}
		
		public function get selectedArray():Array
		{
			return this.objectHandles.selectionManager.currentlySelected
		}
		
		public function get selectedVisuals():Array
		{
			return this.objectHandles.getSelectedVisuals()
		}
		
		public function clearSelection():void
		{
			this.objectHandles.selectionManager.clearSelection()
		}
		
			
		public function get isDirty():Boolean
		{
			return _isDirty
		}
		
		public function set isDirty(v:Boolean):void
		{
			Logger.debug("isDirty set to : "+ v.toString(), this)
			_isDirty = v
		}
		
		
		public function setContainer(s:Group):void
		{
			objectHandles.setContainer(s)
		}
		
		public function setHandlesContainer(s:Group):void
		{
			objectHandles.setHandlesContainer(s)
		}
		
		public function onConnectorAdded(evt:ConnectorAddedEvent):void
		{
			dispatchEvent(evt)
		}
		
		
		public function buildDiagram():void
		{
			Logger.debug("buildDiagram() ", this)
			Logger.debug("	sdObjectModelsAC.length: " + this.sdObjectModelsAC.length, this)
			
			//clear out any existing stuff
			_objectHandles.removeAll()
			
			//change style 
			var styleEvent:StyleEvent = new StyleEvent(StyleEvent.CHANGE_STYLE, true)
			styleEvent.styleName = _diagramDAO.styleName
			styleEvent.isLoadedStyle = true
			Swiz.dispatchEvent(styleEvent)
			
			//add symbols to objectHandles			
			for each (var sdModel:SDObjectModel in sdObjectModelsAC)
			{				
				addComponentForModel(sdModel)
			}
			
			Swiz.dispatchEvent(new LoadDiagramEvent(LoadDiagramEvent.DIAGRAM_BUILT))
		
			isDirty = false			
			
		}
		
		
		/** Adds a new SDObjectModel to the drawingBoard, 
		 *  and updates the view to show this object */
		 
		public function addSDObjectModel(newSDObjectModel:SDObjectModel):void
		{							
			//if this objectModel doesn't have an id, give it a new unique one
			if (newSDObjectModel.sdID==0)
			{
				newSDObjectModel.sdID = getUniqueID()
			}
			
			newSDObjectModel.depth = this.sdObjectModelsAC.length;			
			sdObjectModelsAC.addItem(newSDObjectModel);
			
//			//set defaults
//			if (newSDObjectModel is SDPencilDrawingModel) 
//			{
//				// don't change the color
//			}
//			else 
//			{
//				newSDObjectModel.color = _currColor
//			}
			
			addComponentForModel(newSDObjectModel, true)
		
			isDirty = true;
			
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.ADD_SD_OBJECT_MODEL);	
			Swiz.dispatchEvent(rsoEvent);
		
		}
		
		protected function addComponentForModel(sdModel:SDObjectModel, setSelected:Boolean = true):Object
		{
			//create visual object and add to ObjectHandles		
			var newSDComponent:ISDComponent = sdModel.createSDComponent()
			newSDComponent.objectModel = sdModel;
			newSDComponent.sdID = sdModel.sdID;
				
			//Tell layer that new SDObjectModel has been added 
			var evt:DynamicEvent = new DynamicEvent(DiagramModel.SD_OBJECT_ADDED, true)
			evt.newSDComponent = newSDComponent
			dispatchEvent(evt)
			
			//register with objecthandles 
			var captureKeyEvents:Boolean = true
			if (sdModel is SDTextAreaModel) captureKeyEvents = false
			objectHandles.registerComponent(sdModel, newSDComponent as EventDispatcher, null, captureKeyEvents)
			if (setSelected) objectHandles.selectionManager.setSelected(sdModel)
						
			return newSDComponent
		}
		
		
		public function get objectHandles():SDObjectHandles
		{
			return _objectHandles;
		}

		public function set objectHandles(v:SDObjectHandles):void
		{
			_objectHandles = v;
		}
		
		public function get objectConnectors():ObjectConnectors
		{
			return _objectConnectors;
		}

		public function set objectConnectors(v:ObjectConnectors):void
		{
			_objectConnectors = v;
		}
		
		public function get currToolType():String
		{
			return _currToolType;
		}

		public function set currToolType(toolType:String):void
		{
			if (toolType==_currToolType) return
						
			var evt:ToolEvent = new ToolEvent(ToolEvent.TOOL_CHANGED, true)
			evt.prevTool = _currToolType
			evt.currTool = toolType
			
			_currToolType = toolType
			
			dispatchEvent(evt)
		}
		
		
		
		public function get name():String
		{
			return _diagramDAO.name
		}
		
		public function set name(v:String):void
		{
			_diagramDAO.name = v
		}
		
		public function get updatedAt():Date
		{
			return _diagramDAO.updatedAt
		}
		
		public function set updatedAt(v:Date):void
		{
			_diagramDAO.updatedAt = v
		}
		
		public function get createdAt():Date
		{
			return _diagramDAO.createdAt
		}
		
		public function set createdAt(v:Date):void
		{
			_diagramDAO.createdAt = v
		}
		
		
		public function get description():String
		{
			return _diagramDAO.description
		}
		
		public function set description(v:String):void
		{
			_diagramDAO.description = v
		}
		
		
		public function get styleName():String
		{
			return _diagramDAO.styleName
		}
		
		public function set styleName(v:String):void
		{
			_diagramDAO.styleName = v
		}
		
		public function get verticalScrollPosition():Number
		{
			return _diagramDAO.verticalScrollPosition
		}
		
		public function set verticalScrollPosition(v:Number):void
		{
			_diagramDAO.verticalScrollPosition = v
		}
		
		public function get width():Number
		{
			return _diagramDAO.width
		}
		
		public function set width(v:Number):void
		{
			_diagramDAO.width = v
		}
		
		public function get height():Number
		{
			return _diagramDAO.height
		}
		
		public function set height(v:Number):void
		{
			_diagramDAO.height = v
		}	
		
		public function get baseBackgroundColor():Number
		{
			return _diagramDAO.baseBackgroundColor
		}
		
		public function set baseBackgroundColor(v:Number):void
		{
			_diagramDAO.baseBackgroundColor = v
		}
		
		
		
		   
		
		/* Can't use getters and setters for color since often same value is sent as held internally.
		In this case the setter wouldn't get called*/
		public function getColor():Number
		{
			return _currColor
		}
		public function setColor(v:Number, changeShapeColors:Boolean=false):void
		{
			_currColor = v
		}
		
		public function changeAllShapesToDefaultColor():void
		{	
			for each (var objModel:SDObjectModel in sdObjectModelsAC)
			{
				objModel.color = _currColor
			}
			Swiz.dispatchEvent(new RemoteSharedObjectEvent(RemoteSharedObjectEvent.CHANGE_ALL_SHAPES_TO_DEFAULT_COLOR))
		}
		
		
		public function get horizontalScrollPosition():Number
		{
			return _diagramDAO.horizontalScrollPosition
		}
		
		public function set horizontalScrollPosition(v:Number):void
		{
			_diagramDAO.horizontalScrollPosition = v
		}
		
		public function get scaleX():Number
		{
			return _diagramDAO.scaleX
		}
		
		public function set scaleX(v:Number):void
		{
			_diagramDAO.scaleX = v
		}
		
		public function get scaleY():Number
		{
			return _diagramDAO.scaleY
		}
		
		public function set scaleY(v:Number):void
		{
			_diagramDAO.scaleY = v
		}
		
			
		
		public function deleteSelectedSDObjectModels():void
		{			
			Logger.debug("deleteSelectedSDObjectModels()",this)
			//remove all SD objects that are currently selected
			
			var sdObjectModelsArr:Array = this.objectHandles.selectionManager.currentlySelected
			
			for each (var sdObjectModel:SDObjectModel in sdObjectModelsArr)
			{
				deleteSDObjectModel(sdObjectModel)
			}
			
			this.objectHandles.selectionManager.clearSelection()   			
			isDirty = true
		}
		
		
		public function deleteSDObjectModel(sdObjectModel:SDObjectModel):void
		{			
			//remove from the DrawingBoardModel...making sure to delete the model and the SDComponent
			var len:uint = sdObjectModelsAC.length
			for (var i:uint=0;i<len;i++)			 
			{
				if (sdObjectModelsAC.getItemAt(i) as SDObjectModel == sdObjectModel)
				{
					objectHandles.unregisterComponent(sdObjectModel.sdComponent as EventDispatcher)  	//remove from object handles
					sdObjectModelsAC.removeItemAt(i)													//remove from our local arrayCollection
					break	
				}
			}
			
			Logger.debug("deleting sdOBjectMode:" +sdObjectModel + "  component: " + sdObjectModel.sdComponent,this)
			
			var evt:DeleteSDComponentEvent = new DeleteSDComponentEvent(DeleteSDComponentEvent.DELETE_FROM_DIAGRAM, true)
			evt.sdComponent = sdObjectModel.sdComponent
			Swiz.dispatchEvent(evt)
			
			this.objectHandles.selectionManager.clearSelection()   			
			isDirty = true
		}
		
		public function deleteSDObjectModelByID(id:Number):void
		{
			var sdObjectModel:SDObjectModel = this.getModelByID(id)
			if (sdObjectModel!=null)
			{
				deleteSDObjectModel(sdObjectModel)
			}
		}
		
		
		/* Do all things necessary to init DiagramModel for a new diagram */		
		public function createNew():void
		{
			initDiagramModel()	
			
			Logger.info("createNew()",this);
									
			//launch the loaded event before actually building the diagram
			//b/c on the first load, the DrawingBoard stage won't be set up correctly.			
			var evt:CreateNewDiagramEvent = new CreateNewDiagramEvent(CreateNewDiagramEvent.NEW_DIAGRAM_CREATED, true, true)
			Swiz.dispatchEvent(evt)			
			
		}		
		
		public function updateUpdatedAt():void
		{			
			_diagramDAO.updatedAt = new Date()
		}
		
				
		public function get numSDObjects():Number
		{
			return this.sdObjectModelsAC.length
		}
	
		
		
		
		protected function onStyleChanged(event:StyleEvent):void
		{
			_diagramDAO.styleName = event.styleName
			_currColor = diagramStyleManager.defaultSymbolColor
				
		}
		
		protected function getUniqueID():Number
		{
			return new Date().time
		}
		
		
		
	}
}