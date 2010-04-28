/**
 *  Latest information on this project can be found at http://www.rogue-development.com/objectHandles.html
 * 
 *  Copyright (c) 2009 Marc Hughes 
 * 
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"), 
 *  to deal in the Software without restriction, including without limitation 
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 *  and/or sell copies of the Software, and to permit persons to whom the Software 
 *  is furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in all 
 *  copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 * 
 * -------------------------------------------------------------------------------------------
 *  
 * Contributions by:
 *    
 *    Alexander Kludt
 *    Thomas Jakobi
 *    Mario Ernst
 *    Aaron Winkler
 *    Gregory Tappero
 *    Andrew Westberg
 * 
 * -------------------------------------------------------------------------------------------
 * 
 * Description:
 *    ObjectHandles gives the user the ability to move and resize a component with the mouse.
 * 
 * 
 * 
 **/
package com.roguedevelopment.objecthandles
{
	import com.simplediagrams.events.MoveOnceEvent;
	import com.simplediagrams.events.ObjectChangedEvent;
	import com.simplediagrams.events.SelectionEvent;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.events.PropertyChangeEvent;
	import mx.events.ScrollEvent;
	
	import org.swizframework.Swiz;
	
	import spark.components.Group;

	
	[Event(name="objectMoved",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]
	[Event(name="objectResized",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]
	[Event(name="objectRotated",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]
	[Event(name="objectMoving",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]
	[Event(name="objectResizing",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]
	[Event(name="objectRotating",type="com.roguedevelopment.objecthandles.ObjectChangedEvent")]

    public class ObjectHandles extends EventDispatcher
    {
		/**
		 * The default handle class to use.
		 * 
		 * SpriteHandle is good for Flex 3 based applications, or Flex 4 applications where the object handles live
		 * inside a Canvas.
		 * 
		 * Switch it over to a VisualElementHandle for Flex 4 based applications.  Do this before creating ObjectHandle instances,
		 * it's merely here to provide a convienent way to set the default globally.
		 **/
		public static var defaultHandleClass:Class = SpriteHandle;
				
        protected const zero:Point = new Point(0,0);
        
        protected var container:Group;
		//DMCQ: I'm adding a second container to hold the handles, while the "container" holds the actual visual object
		//This is because I want the handles to always appear above all objects, even when selected objet is beneath others
		protected var handlesContainer:Group 
		
		/**
		 * Should the user be allowed to select multiple items?
		 **/
		public var enableMultiSelect:Boolean=true;
				
        public var selectionManager:ObjectHandlesSelectionManager;
        protected var handleFactory:IFactory;
        
        public var defaultHandles:Array = [];
        
		/**
		 * These are the handles that appear around the bounding box when multiple objects are selected.
		 **/
		public var multiSelectHandles:Array = [];
		
        // Key = a Model, value = an Array of handles
        protected var handles:Dictionary = new Dictionary(); 
        		
        // Key = a visual, value = the model
        protected var models:Dictionary = new Dictionary(); 
		
		// A dictionary of the geometry of the models before the current drag operation started.                
		// This is set at the beginning of the user gesture.
		// Key = a visual, value = the model
		protected var originalModelGeometry:Dictionary = new Dictionary(); 
		
        // Key = a model, value = the visual
        protected var visuals:Dictionary = new Dictionary();
        
        // Key = a model, value = an array of HandleDescription objects;
        protected var handleDefinitions:Dictionary = new Dictionary(); 
        
        // Array of unused, visible=false handles
        protected var handleCache:Array = [];
        
        protected var temp:Point = new Point(0,0);
        
        protected var isDragging:Boolean = false;
		protected var _isHandleDragging:Boolean = false; //DMCQ - we use this as part of recording action when user is resizing or rotating
        protected var currentDragRole:uint = 0;
		
        protected var mouseDownPoint:Point;
        protected var mouseDownRotation:Number;
        protected var originalGeometry:DragGeometry;
        protected var originalGeometries:Array;
		
		
		/**
		 * An array of IConstraint objects that influence how the objects are allowed to be
		 * moved or resized.
		 * 
		 * For instance, put in a SizeConstraint to set the max or minimum sizes. 
		 **/
		public var constraints:Array = [];
		
		protected var currentHandleConstraint:IFactory;
				
		public var modelList:Array=[];
                
       	//used to remember object changes so
       	//events can be fired when the changes are complete
      	private var isMoved:Boolean = false;
       	private var isResized:Boolean = false;
       	private var isRotated:Boolean = false;
            
		protected var multiSelectModel:DragGeometry=new DragGeometry();
		
		
		/**
		* @param container The base container that all of the objects and the handles will be added to.
		* 
		* @param selectionManager 
		* 
		* A manager class that deals with which object(s) are currently selected.  
		* If you pass null, a new one will be created for you.  It's often times useful to share 
		* a single selection manage across an entire app so that "selection" is global.
		* 
		* @param handleFactory 
		* 
		* A factory capable of creating IHandle objects.
		* If you pass null, a generic Flex 3 based factory will be created.
		* Use the Flex4HandleFactory to make Group compatible handles.
		* 
		* 
		**/

		
		
		
		public function ObjectHandles(  container:Group , 
                                        selectionManager:ObjectHandlesSelectionManager = null, 
                                        handleFactory:IFactory = null)
        {       
            this.container = container;
            
            //container.addEventListener(MouseEvent.ROLL_OUT, onContainerRollOut );
            container.addEventListener( ScrollEvent.SCROLL, onContainerScroll );
            
            
            if( selectionManager )          
                this.selectionManager = selectionManager;           
            else            
                this.selectionManager = new ObjectHandlesSelectionManager();
            
            
            if( handleFactory )
                this.handleFactory = handleFactory;
            else
                this.handleFactory = new ClassFactory( Handle );
            
            
            Swiz.addEventListener(SelectionEvent.ADDED_TO_SELECTION, onSelectionAdded );
            Swiz.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, onSelectionRemoved );
           	Swiz.addEventListener(SelectionEvent.SELECTION_CLEARED, onSelectionCleared );
            
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
				zero ,
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_UP ,
				new Point(50,0) , 
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
				new Point(100,0) ,
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_RIGHT,
				new Point(100,50) , 
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
				new Point(100,100) , 
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN ,
				new Point(50,100) ,
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
				new Point(0,100) ,
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.RESIZE_LEFT,
				new Point(0,50) ,
				zero ) ); 
			
			multiSelectHandles.push( new HandleDescription( HandleRoles.ROTATE,
				new Point(100,50) , 
				new Point(20,0) ) ); 
			
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
				zero ,
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP ,
				new Point(50,0) , 
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
				new Point(100,0) ,
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_RIGHT,
				new Point(100,50) , 
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
				new Point(100,100) , 
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN ,
				new Point(50,100) ,
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
				new Point(0,100) ,
				zero ) ); 
			
			defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_LEFT,
				new Point(0,50) ,
				zero ) ); 
			
			
			defaultHandles.push( new HandleDescription( HandleRoles.ROTATE,
				new Point(100,50) , 
				new Point(20,0) ) ); 
			
			registerComponent(multiSelectModel, null, multiSelectHandles, false);

            
        }
		
		
		/**
		 * Registers a component with the ObjectHandle manager.
		 * 
		 * @param dataModel The data model that represents this object.  This is where values will be commited to.  It should have a getter/setter for x,y,width, height, and optionally
		 *                                      rotation.
		 * 
		 * @param visualDisplay This is the actual on-screen display of the object.  We never set the coordinates of this object explictly, it should be bound
		 *                                  to your data model.
		 * 
		 * @param handleDescriptions If you want non-standard handles, create a list of HandleDescription objects and pass them in.
		 * 
		 * @param captureKeyEvents Should we add event listeners to support keyboard navigation?
		 **/
        
        public function registerComponent( dataModel:Object, visualDisplay:EventDispatcher , handleDescriptions:Array = null, captureKeyEvents:Boolean = true) : void
        {
			modelList.push(dataModel)
				
			if( visualDisplay )
			{
				visualDisplay.addEventListener( MouseEvent.MOUSE_DOWN, onComponentMouseDown, false, 0, true );				
            	visualDisplay.addEventListener( SelectionEvent.SELECTED, handleSelection );
            	if(captureKeyEvents)
				{
            	 	visualDisplay.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
            	}
				models[visualDisplay] = dataModel;
			}
			
			dataModel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			visuals[dataModel] = visualDisplay;     			
			
            dataModel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
            models[visualDisplay] = dataModel;
            visuals[dataModel] = visualDisplay;     
            
			//DMCQ
            //if (SDObjectModel(dataModel).maintainProportion)
            //{
            //	handleDefinitions[dataModel] = HandleDefinitions.MAINTAIN_PROPORTION_DEFINITION	
            //}
			//~DMCQ
                        
            if( handleDescriptions )
            {
                handleDefinitions[ dataModel ] = handleDescriptions;
            }
			
			
        }
        
        protected function onKeyDown(event:KeyboardEvent):void
        {
			Logger.debug("######## keyboard event: " + event.keyCode, this)
								
            var t:DragGeometry = new DragGeometry();
			var evt:MoveOnceEvent
		    switch(event.keyCode )
            {
                case Keyboard.UP : 
					evt = new MoveOnceEvent(MoveOnceEvent.MOVE_UP, true)
					event.stopPropagation()
					break;
                case Keyboard.DOWN : 
					evt = new MoveOnceEvent(MoveOnceEvent.MOVE_DOWN, true)
					event.stopPropagation()
					break;
                case Keyboard.RIGHT : 					
					evt = new MoveOnceEvent(MoveOnceEvent.MOVE_RIGHT, true)
					event.stopPropagation()
					break;
                case Keyboard.LEFT : 					
					evt = new MoveOnceEvent(MoveOnceEvent.MOVE_LEFT, true)
					event.stopPropagation()
					break;             
                default:return; 
            }
			
			evt.relatedObjects = this.selectionManager.currentlySelected
			Swiz.dispatchEvent(evt)
            
            //applyConstraints( t, HandleRoles.MOVE );
			//applyTranslation( t );
        }
        
        /**
         * Returns true if the given model should have a movement handle.
         **/
        protected function hasMovementHandle( model:Object ) : Boolean
        {
            var desiredHandles:Array = getHandleDefinitions(model);
            for each ( var handle:HandleDescription in desiredHandles )
            {
                if( HandleRoles.isMove( handle.role ) ) return true;
            }
            return false;
        }
        
        public function unregisterComponent( visualDisplay:EventDispatcher ) : void
        {
			if (visualDisplay==null)
			{
				Logger.warn("somebody sent a null visualDisplay to unregisterComponent.", this)
				return
			}
            visualDisplay.removeEventListener( MouseEvent.MOUSE_DOWN, onComponentMouseDown);
            visualDisplay.removeEventListener( SelectionEvent.SELECTED, handleSelection );
            visualDisplay.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
            var dataModel:Object = findModel(visualDisplay as DisplayObject);
            dataModel.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );   
			
			modelList.splice( modelList.indexOf(dataModel), 1 );
						
            delete visuals[dataModel];
            delete models[visualDisplay];
			selectionManager.clearSelection();
        }
		
		protected function onModelChange(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "x":
				case "y":
				case "width":
				case "height":
				case "rotation": updateHandlePositions(event.target);
			}
		}

		//DMCQ : helps when doing stuff like copying
		public function getSelectedVisuals():Array
		{
			var returnArr:Array = []
			if (this.selectionManager.currentlySelected.length>0)
			{
				var len:uint=selectionManager.currentlySelected.length
				for (var i:uint=0;i<len;i++)
				{
					if (visuals[selectionManager.currentlySelected[i]]!=null)
					{
						returnArr.push(visuals[selectionManager.currentlySelected[i]])
					}
				}				
				return returnArr
			}
			return []
		}
		//~DMCQ
		
        
		protected function onSelectionAdded( event:SelectionEvent ) : void
		{
			setupHandles();                 
		}
		
		protected function onSelectionRemoved( event:SelectionEvent ) : void
		{
			setupHandles();            
		}
		
		protected function onSelectionCleared( event:SelectionEvent ) : void
		{                       
			setupHandles();
			lastSelectedModel=null;
		}
		
		
		
        protected function onComponentMouseDown(event:MouseEvent):void
        {   
						
            handleSelection( event );
            
            container.stage.addEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove );
            container.stage.addEventListener( MouseEvent.MOUSE_UP, onContainerMouseUp );

            try
            {
              event.target.setFocus();
            }
            catch(e:Error)
            {}
            
            var model:Object = findModel( event.target as DisplayObject);
			for each (var model:Object in this.selectionManager.currentlySelected)
			{
				Logger.debug("capturing state of model: " + model,this)				
				SDObjectModel(model).captureStartState()
			}				
			
			var evt:ObjectChangedEvent = new ObjectChangedEvent(this.selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_START_MOVING, true)
			dispatchEvent(evt)					
				
            if( ! hasMovementHandle(model) )
            {
                currentDragRole = HandleRoles.MOVE; // a mouse down on the component itself as opposed to a handle is a move operation.
                currentHandleConstraint = null;
                handleBeginDrag( event );
            }
        }
		
	
        
        protected function onContainerRollOut(event:MouseEvent) : void
        {
            isDragging = false; 
        }
        
        
		protected function onContainerMouseUp( event:MouseEvent ) : void
		{
			_isHandleDragging = false
				
			if (isMoved)
			{
				Swiz.dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_MOVED, true));
			}
			else if (isResized)
			{
				Swiz.dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_RESIZED, true));
			}
			else if (isRotated)
			{
				Logger.debug("onContainerMouseUp() dispatching OBJECT_ROTATED",this)
				Logger.debug("onContainerMouseUp() selectionManager.currentlySelected.length: " + selectionManager.currentlySelected.length,this)
				Swiz.dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_ROTATED, true));
			}
			
			isMoved = false;
			isResized = false;
			isRotated = false;
			container.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onContainerMouseMove );
			container.stage.removeEventListener( MouseEvent.MOUSE_UP, onContainerMouseUp );
			
			if( selectionManager.currentlySelected.length > 1 )
			{
				multiSelectModel.copyFrom( selectionManager.getGeometry() );                    
				updateHandlePositions(multiSelectModel);
			}
			
			isDragging = false;
		}
		
    
		
		protected function onContainerScroll(event:ScrollEvent):void
		{
			for each (var model:Object in models )
			{
				updateHandlePositions(model);
			}
		}
		protected function onContainerMouseMove( event:MouseEvent ) : void
		{
			if( ! isDragging ) { return; }
			var translation:DragGeometry = new DragGeometry();
			
			if( HandleRoles.isMove( currentDragRole ) )
			{
				isMoved = true;
				applyMovement( event, translation );
				applyConstraints(translation, currentDragRole );
			}
			
			if( HandleRoles.isResizeLeft( currentDragRole ) )
			{
				isResized = true;
				applyResizeLeft( event, translation );              
			}
			
			if( HandleRoles.isResizeUp( currentDragRole) )
			{
				isResized = true;
				applyResizeUp( event, translation );                
			}
			
			if( HandleRoles.isResizeRight( currentDragRole ) )
			{
				isResized = true;
				applyResizeRight( event, translation );             
			}
			
			if( HandleRoles.isResizeDown( currentDragRole ) )
			{
				isResized = true;
				applyResizeDown( event, translation );                      
			}
			
			if( HandleRoles.isRotate( currentDragRole ) )
			{
				isRotated = true;
				applyRotate( event, translation );              
			}
			
			applyTranslation( translation );            
			
			event.updateAfterEvent();    
			
			if (isMoved)
			{
				dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_MOVING, true));
			}
			else if (isResized)
			{
				dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_RESIZING, true));
			}
			else if (isRotated)
			{
				dispatchEvent(new ObjectChangedEvent(selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_ROTATING, true));
			}                       
		}

		protected function applyTranslationForSingleObject( current:Object, translation:DragGeometry , originalGeometry:DragGeometry) : void
		{
			if (current==null )
			{
				Logger.debug("current was null", this)
				return
			}
			if (translation==null )
			{
				Logger.debug("translation was null", this)
				return
			}
			if (originalGeometry==null )
			{
				Logger.debug("originalGeometry was null", this)
				return
			}
			if( current.hasOwnProperty("x") ) current.x = translation.x + originalGeometry.x;
			if( current.hasOwnProperty("y") ) current.y = translation.y + originalGeometry.y;
			
			if( current.hasOwnProperty("width") ) current.width = translation.width + originalGeometry.width;
			if( current.hasOwnProperty("height") ) current.height = translation.height + originalGeometry.height;
			if( current.hasOwnProperty("rotation") ) current.rotation = translation.rotation + originalGeometry.rotation;
			
			updateHandlePositions(  current );
		}

		protected function applyTranslation( translation:DragGeometry) : void
		{
			
			if( selectionManager.currentlySelected.length == 1 )
			{                                           
				applyTranslationForSingleObject( selectionManager.currentlySelected[0], translation, originalGeometry );                    
			}
			else if( selectionManager.currentlySelected.length > 1 )
			{                           
				applyTranslationForSingleObject(multiSelectModel, translation , originalGeometry);
				for each ( var subObject:Object in selectionManager.currentlySelected )
				{
					var subTranslation:DragGeometry = calculateTranslationFromMultiTranslation( translation, subObject );
					applyTranslationForSingleObject( subObject, subTranslation , originalModelGeometry[subObject] );
				}
			}
			
		}
		
		private var selectionMatrix:Matrix = new Matrix();
		private var objectMatrix:Matrix = new Matrix();
		private var relativeGeometry:Point = new Point();
		/**
		 * Calculates the translation of a single object in a group of objects that is selected
		 * based on the translation of the entire group.
		 **/
		protected function calculateTranslationFromMultiTranslation(overallTranslation:DragGeometry ,  object:Object) : DragGeometry
		{
			var rv:DragGeometry = new DragGeometry();
			
			
			// This is the rotation, scaling, and translation of the entire selection.
			selectionMatrix.identity();
			selectionMatrix.rotate( toRadians( overallTranslation.rotation ));
			selectionMatrix.scale( (originalGeometry.width + overallTranslation.width) / originalGeometry.width,
				(originalGeometry.height + overallTranslation.height) / originalGeometry.height );
			selectionMatrix.translate( overallTranslation.x + originalGeometry.x, overallTranslation.y + originalGeometry.y);
			
			// This is the point the object is relative to the selection
			
			relativeGeometry.x = originalModelGeometry[object].x - originalGeometry.x;
			relativeGeometry.y = originalModelGeometry[object].y - originalGeometry.y;                      
			
			objectMatrix.identity();
			objectMatrix.rotate( toRadians( overallTranslation.rotation +  originalModelGeometry[object].rotation) );                       
			objectMatrix.translate(relativeGeometry.x, relativeGeometry.y);
			
			
			var translatedZeroPoint:Point = objectMatrix.transformPoint( zero );
			var translatedTopRightCorner:Point = objectMatrix.transformPoint( new Point(originalModelGeometry[object].width,0) );                   
			var translatedBottomLeftCorner:Point = objectMatrix.transformPoint( new Point(0,originalModelGeometry[object].height) );                        
			
			translatedZeroPoint = selectionMatrix.transformPoint( translatedZeroPoint );
			translatedTopRightCorner = selectionMatrix.transformPoint( translatedTopRightCorner );
			translatedBottomLeftCorner = selectionMatrix.transformPoint( translatedBottomLeftCorner );
			
			// uncomment to draw debug graphics.
			//                      container.graphics.lineStyle(2,0xff0000,0.5);
			//                      container.graphics.drawCircle(translatedZeroPoint.x, translatedZeroPoint.y , 4);
			//                      container.graphics.lineStyle(2,0xffff00,0.5);
			//                      container.graphics.drawCircle(translatedTopRightCorner.x, translatedTopRightCorner.y , 4);
						
			var targetWidth:Number = Point.distance( translatedZeroPoint, translatedTopRightCorner);
			var targetHeight:Number = Point.distance( translatedZeroPoint, translatedBottomLeftCorner ) ;
			
			// remember, rv is the CHANGE in value from the original, not an absolute value.
			rv.x = translatedZeroPoint.x - originalModelGeometry[object].x; 
			rv.y = translatedZeroPoint.y - originalModelGeometry[object].y;
			rv.width = targetWidth - originalModelGeometry[object].width;
			rv.height = targetHeight - originalModelGeometry[object].height;
			
			var targetAngle:Number = toDegrees(Math.atan2( translatedTopRightCorner.y - translatedZeroPoint.y, translatedTopRightCorner.x - translatedZeroPoint.x));
			
			rv.rotation = targetAngle - originalModelGeometry[object].rotation - overallTranslation.rotation;
			return rv;
		}

        
		
		protected function applyConstraints(translation:DragGeometry, currentDragRole:uint):void
		{
			if( selectionManager.currentlySelected.length > 1 )
			{
				// We don't apply constraints when there's a bunch of things selected.
				return;
			}
			
			if (currentHandleConstraint != null)
			{
				currentHandleConstraint.newInstance().applyConstraint( originalGeometry, translation, currentDragRole );
			}
			for each ( var constraint:IConstraint in constraints )
			{
				constraint.applyConstraint( originalGeometry, translation, currentDragRole );
			}
		}


        
        
		protected function applyRotate( event:MouseEvent, proposed:DragGeometry ) : void
		{
			var centerRotatedAmount:Number = toRadians(originalGeometry.rotation) -
				toRadians(mouseDownRotation) +
				getAngleInRadians(event.stageX, event.stageY);
			
			var oldRotationMatrix:Matrix = new Matrix();
			oldRotationMatrix.rotate( toRadians( originalGeometry.rotation) );
			var oldCenter:Point = oldRotationMatrix.transformPoint(new Point(originalGeometry.width/2,originalGeometry.height/2));
			//          
			var newRotationMatrix:Matrix = new Matrix();
			//newRotationMatrix.rotate( toRadians(originalGeometry.rotation) );
			newRotationMatrix.translate(-oldCenter.x, -oldCenter.y);//-originalGeometry.width/2,-originalGeometry.height/2);                                    
			newRotationMatrix.rotate( centerRotatedAmount );
			newRotationMatrix.translate(oldCenter.x, oldCenter.y);                          
			var newOffset:Point = newRotationMatrix.transformPoint( zero );
			
			
			proposed.x += newOffset.x;
			proposed.y += newOffset.y;
			proposed.rotation = toDegrees(centerRotatedAmount);
		}    
		
		
		
		
		protected function getAngleInRadians(x:Number,y:Number):Number
		{
			var m:Matrix = new Matrix();
			var mousePos:Point = container.globalToLocal( new Point(x,y) );
			
			
			
			var angle1:Number;
			m.rotate( toRadians( originalGeometry.rotation)  );
			var originalCenter:Point = m.transformPoint( new Point(originalGeometry.width/2, originalGeometry.height/2) );
			originalCenter.offset( originalGeometry.x,  originalGeometry.y );
			
			////            This will draw some debug lines
			//                      container.graphics.clear();
			//                      container.graphics.lineStyle(1,0xff0000);
			//                      container.graphics.moveTo( originalCenter.x, originalCenter.y );
			//                      container.graphics.lineTo( mousePos.x, mousePos.y );
			//                      container.graphics.lineStyle(1,0x00ff00);
			//                      var ang:Number = Math.atan2(mousePos.y - originalCenter.x, mousePos.x - originalCenter.y) ;
			//                      container.graphics.moveTo( originalCenter.x, originalCenter.y );
			//                      container.graphics.lineTo( originalCenter.x + Math.cos(ang)*300, originalCenter.y + Math.sin(ang)*300);
			
			if( container is Canvas) {
				var parentCanvas:Canvas = container as Canvas;
				return Math.atan2((mousePos.y + parentCanvas.verticalScrollPosition) - originalCenter.y, (mousePos.x + parentCanvas.horizontalScrollPosition) - originalCenter.x) ;
			}
			else
				return Math.atan2(mousePos.y - originalCenter.y, mousePos.x - originalCenter.x) ;
		}
		protected function applyMovement( event:MouseEvent, translation:DragGeometry ) : void
		{          
			temp.x = event.stageX;
			temp.y = event.stageY;
			var localDown:Point = container.globalToLocal( mouseDownPoint );
			var current:Point = container.globalToLocal( temp );
			var mouseDelta:Point = new Point( current.x - localDown.x, current.y - localDown.y );
			
			
			translation.x = mouseDelta.x;
			translation.y = mouseDelta.y;
			
		}
		
		protected function applyResizeRight( event:MouseEvent, translation:DragGeometry ) : void
		{
			var containerOriginalMousePoint:Point = container.globalToLocal(new Point( mouseDownPoint.x, mouseDownPoint.y ));      
			var containerMousePoint:Point = container.globalToLocal( new Point(event.stageX, event.stageY) );
			
			// "local coordinates" = the coordinate system that is relative to the piece that moves around.
			
			// matrix describes the current rotation and helps us to go from container to local coordinates
			var matrix:Matrix = new Matrix();
			matrix.rotate( toRadians( originalGeometry.rotation ) );
			// The inverse matrix helps us to go from local to container coordinates
			var invMatrix:Matrix = matrix.clone();
			invMatrix.invert();
			
			// The point where we pressed the mouse down in local coordinates
			var localOriginalMousePoint:Point = invMatrix.transformPoint( containerOriginalMousePoint );
			// The point where the mouse is currently in local coordinates
			var localMousePoint:Point = invMatrix.transformPoint( containerMousePoint );
			
			// How far along the X axis (in local coordinates) has the mouse been moved?  This is the amount the user has tried to resize the object
			var resizeDistance:Number = localMousePoint.x - localOriginalMousePoint.x;
			
			// So our new width is the original width plus that resize amount
			translation.width +=  resizeDistance;
			
			applyConstraints(translation, currentDragRole );
			
			// Now, that we've resize the object, we need to know where the upper left corner should get moved to because when we resize left, we have to move left.
			var translationp:Point = matrix.transformPoint( zero );
			
			translation.x +=  translationp.x;
			translation.y +=  translationp.y;
		}
		
		protected function applyResizeDown( event:MouseEvent, translation:DragGeometry ) : void
		{
			var containerOriginalMousePoint:Point = container.globalToLocal(new Point( mouseDownPoint.x, mouseDownPoint.y ));      
			var containerMousePoint:Point = container.globalToLocal( new Point(event.stageX, event.stageY) );
			
			// "local coordinates" = the coordinate system that is relative to the piece that moves around.
			
			// matrix describes the current rotation and helps us to go from container to local coordinates
			var matrix:Matrix = new Matrix();
			matrix.rotate( toRadians( originalGeometry.rotation ) );
			// The inverse matrix helps us to go from local to container coordinates
			var invMatrix:Matrix = matrix.clone();
			invMatrix.invert();
			
			// The point where we pressed the mouse down in local coordinates
			var localOriginalMousePoint:Point = invMatrix.transformPoint( containerOriginalMousePoint );
			// The point where the mouse is currently in local coordinates
			var localMousePoint:Point = invMatrix.transformPoint( containerMousePoint );
			
			// How far along the X axis (in local coordinates) has the mouse been moved?  This is the amount the user has tried to resize the object
			var resizeDistance:Number = localMousePoint.y - localOriginalMousePoint.y;
			
			// So our new width is the original width plus that resize amount
			translation.height +=  resizeDistance;
			
			applyConstraints(translation, currentDragRole );
			
			// Now, that we've resize the object, we need to know where the upper left corner should get moved to because when we resize left, we have to move left.
			var translationp:Point = matrix.transformPoint( zero );
			
			translation.x +=  translationp.x;
			translation.y +=  translationp.y;
		}
		
		protected function applyResizeLeft( event:MouseEvent, translation:DragGeometry ) : void
		{
			var containerOriginalMousePoint:Point = container.globalToLocal(new Point( mouseDownPoint.x, mouseDownPoint.y ));      
			var containerMousePoint:Point = container.globalToLocal( new Point(event.stageX, event.stageY) );
			
			// "local coordinates" = the coordinate system that is relative to the piece that moves around.
			
			// matrix describes the current rotation and helps us to go from container to local coordinates
			var matrix:Matrix = new Matrix();
			matrix.rotate( toRadians( originalGeometry.rotation ) );
			// The inverse matrix helps us to go from local to container coordinates
			var invMatrix:Matrix = matrix.clone();
			invMatrix.invert();
			
			// The point where we pressed the mouse down in local coordinates
			var localOriginalMousePoint:Point = invMatrix.transformPoint( containerOriginalMousePoint );
			// The point where the mouse is currently in local coordinates
			var localMousePoint:Point = invMatrix.transformPoint( containerMousePoint );
			
			// How far along the X axis (in local coordinates) has the mouse been moved?  This is the amount the user has tried to resize the object
			var resizeDistance:Number = localOriginalMousePoint.x - localMousePoint.x ;
			
			// So our new width is the original width plus that resize amount
			translation.width +=  resizeDistance;
			
			
			applyConstraints(translation, currentDragRole );
			
			// Now, that we've resize the object, we need to know where the upper left corner should get moved to because when we resize left, we have to move left.
			var translationp:Point = matrix.transformPoint( new Point(-translation.width,0) );
			
			translation.x +=  translationp.x;
			
			translation.y +=  translationp.y;
		}
		
		protected function applyResizeUp( event:MouseEvent, translation:DragGeometry ) : void
		{
			var containerOriginalMousePoint:Point = container.globalToLocal(new Point( mouseDownPoint.x, mouseDownPoint.y ));      
			var containerMousePoint:Point = container.globalToLocal( new Point(event.stageX, event.stageY) );
			
			// "local coordinates" = the coordinate system that is relative to the piece that moves around.
			
			// matrix describes the current rotation and helps us to go from container to local coordinates
			var matrix:Matrix = new Matrix();
			matrix.rotate( toRadians( originalGeometry.rotation ) );
			// The inverse matrix helps us to go from local to container coordinates
			var invMatrix:Matrix = matrix.clone();
			invMatrix.invert();
			
			// The point where we pressed the mouse down in local coordinates
			var localOriginalMousePoint:Point = invMatrix.transformPoint( containerOriginalMousePoint );
			// The point where the mouse is currently in local coordinates
			var localMousePoint:Point = invMatrix.transformPoint( containerMousePoint );
			
			// How far along the Y axis (in local coordinates) has the mouse been moved?  This is the amount the user has tried to resize the object
			var resizeDistance:Number = localOriginalMousePoint.y - localMousePoint.y ;
			
			// So our new width is the original width plus that resize amount
			translation.height +=  resizeDistance;
			
			applyConstraints(translation, currentDragRole );
			
			// Now, that we've resize the object, we need to know where the upper left corner should get moved to because when we resize left, we have to move left.
			var translationp:Point = matrix.transformPoint( new Point(0, -translation.height) );
			
			translation.x += translationp.x;
			translation.y += translationp.y;
		}       
		
		public function findModel( display:DisplayObject ) : Object
		{
			var model:Object = models[ display ];
			
			while( (model==null) && (display.parent != null) )
			{
				display = display.parent as DisplayObject;
				model = models[ display ];
			}
			return model;
		}
		
		
		public function handleSelection( event : MouseEvent ) : void
		{
			var model:Object = findModel( event.target as DisplayObject );
			
			if( ! model ) { return; }
			
			// if shift key - add/remove to selection
			if(event.shiftKey && enableMultiSelect)  
			{
				if(selectionManager.isSelected(model) && selectionManager.currentlySelected.length > 1) 
				{
					selectionManager.removeFromSelected(model);
				} else 
				{
					selectionManager.addToSelected(model);
				}            
			}
			else
			{
				if(! selectionManager.isSelected( model ) )
					selectionManager.setSelected( model );
			}
			
		}
		
		protected function handleBeginDrag( event : MouseEvent ) : void
		{
						
			isDragging = true;  
			mouseDownPoint = new Point( event.stageX, event.stageY );          
			originalGeometry = selectionManager.getGeometry();
			
			//DMcQ: there's a bug where sometimes this originalGeometry is null
			
			if (originalGeometry==null)
			{
				Logger.warn("handleBeginDrag() Original geometry was null. event: " + event + " event.target: " + event.target, this)
				return
			}
			
			// saving old coordinates
			originalModelGeometry = new Dictionary();
			for each(var current:Object in selectionManager.currentlySelected) 
			{
				originalModelGeometry[current] = selectionManager.getGeometryForObject(current);
			}
			mouseDownRotation = originalGeometry.rotation + toDegrees( getAngleInRadians(event.stageX, event.stageY) );        
		}
		
		protected var lastSelectedModel:Object;
		
		protected function setupHandles(  ) : void
		{  		
				
			if( selectionManager.currentlySelected.length == 0 )
			{
				removeHandles( lastSelectedModel );
				removeHandles( multiSelectModel );
			}
			else if( selectionManager.currentlySelected.length == 1 )
			{
				// single object selected
				createHandlesFor( selectionManager.currentlySelected[0] );
				updateHandlePositions(selectionManager.currentlySelected[0]);
				removeHandles( multiSelectModel );
				if (lastSelectedModel != selectionManager.currentlySelected[0])
				{
					removeHandles( lastSelectedModel );
				}
				lastSelectedModel = selectionManager.currentlySelected[0];
				
			}
			else
			{
				// Many objects selected
				removeHandles( lastSelectedModel );
				var geo:DragGeometry = selectionManager.getGeometry();                          
				if(geo )
				{
					multiSelectModel.copyFrom( geo );
					createHandlesFor( multiSelectModel );
					updateHandlePositions( multiSelectModel );
					lastSelectedModel = multiSelectModel;
				}
			}
		}
		
		
		
		
		protected function createHandlesFor( model:Object ) : void
		{
			var desiredHandles:Array = getHandleDefinitions(model);
			for each ( var descriptor:HandleDescription in desiredHandles )
			{
				createHandle( model, descriptor);
			}                      
		}
		
		protected function getHandleDefinitions( model:Object ) :Array
		{
			var desiredHandles:Array;
			desiredHandles = handleDefinitions[ model ];
			if(! desiredHandles)
			{
				desiredHandles = defaultHandles;
			}
			return desiredHandles;
		}
		
		protected function createHandle( model:Object, descriptor:HandleDescription ) : void
		{
			var current:Array = handles[model];
			if( ! current )
			{
				current = [];
				handles[model] = current;
			}
			// todo: use cached handles for performance.
			var handle:IHandle
			
			if (descriptor.handleFactory != null)
			{
				handle = descriptor.handleFactory.newInstance() as IHandle;
			}
			else
			{
				handle = handleFactory.newInstance() as IHandle;
			}
			handle.targetModel = model;
			handle.handleDescriptor = descriptor;
			connectHandleEvents( handle , descriptor);
			current.push(handle);
			addToHandlesContainer( handle as Sprite);
			handle.redraw();
		}
		
		protected function getContainerScrollAmount() : Point
		{
			var rv:Point = new Point(0,0);
			if( container is Container )
			{
				var con:Container = container as Container;
				// If the scroll amount is negative we return 0
				if (con.horizontalScrollPosition < 0)
					rv.x = 0
				else if (con.horizontalScrollPosition > con.maxHorizontalScrollPosition)
					rv.y = con.maxHorizontalScrollPosition
				else					
					rv.x = con.horizontalScrollPosition;
				if (con.verticalScrollPosition  < 0)
					rv.y = 0
				else if (con.verticalScrollPosition > con.maxVerticalScrollPosition)
					rv.y = con.maxVerticalScrollPosition
				else
					rv.y = con.verticalScrollPosition;
			}
			return rv;
		}
		
		protected function updateHandlePositions( model:Object ) : void
		{
			var h:Array = handles[model]
			var scroll:Point = getContainerScrollAmount();
			
			if( ! h ) { return; }
			for each ( var handle:IHandle in h )
			{                      
				if( model.hasOwnProperty("rotation") )
				{
					var m:Matrix = new Matrix(  1, // first four form partial identity matrix
						0,
						1,
						0,
						(model.width * handle.handleDescriptor.percentageOffset.x / 100)  + handle.handleDescriptor.offset.x, // The tX
						(model.height * handle.handleDescriptor.percentageOffset.y / 100)  + handle.handleDescriptor.offset.y); // the tY
					m.rotate( toRadians( model.rotation ) );
					var p:Point = m.transformPoint( zero );                                            
					handle.x = p.x + model.x - Math.floor(handle.width / 2) - scroll.x;
					handle.y = p.y + model.y - Math.floor(handle.height / 2) - scroll.y;
				}
				else
				{
					handle.x =  model.x - Math.floor(handle.width / 2) + (model.width * handle.handleDescriptor.percentageOffset.x / 100)  + handle.handleDescriptor.offset.x - scroll.x;
					handle.y =  model.y - Math.floor(handle.height / 2) + (model.height * handle.handleDescriptor.percentageOffset.y / 100)  + handle.handleDescriptor.offset.y - scroll.y;
				}
			}  
		}
		
		protected static function toRadians( degrees:Number ) :Number
		{
			return degrees * Math.PI / 180;
		}
		protected static function toDegrees( radians:Number ) :Number
		{
			return radians *  180 / Math.PI;
		}
		
		protected function connectHandleEvents( handle:IHandle , descriptor:HandleDescription) : void
		{
			handle.addEventListener( MouseEvent.MOUSE_DOWN, onHandleDown );	
		}
		
		protected function onHandleDown( event:MouseEvent):void
		{
			Logger.debug("onHandleDown()",this)
			_isHandleDragging = true
			var evt:ObjectChangedEvent = new ObjectChangedEvent(this.selectionManager.currentlySelected, ObjectChangedEvent.OBJECT_START_RESIZING, true)
			Swiz.dispatchEvent(evt)
			
			var handle:IHandle = event.target as IHandle;
			if( ! handle ) { return; }
						
			container.stage.addEventListener( MouseEvent.MOUSE_MOVE, onContainerMouseMove );
			container.stage.addEventListener( MouseEvent.MOUSE_UP, onContainerMouseUp );
						
			currentDragRole = handle.handleDescriptor.role;
			currentHandleConstraint = handle.handleDescriptor.constraint;
			handleBeginDrag(event);
		}
				
		
		protected function addToHandlesContainer( display:Sprite):void
		{
			(handlesContainer as Group).addElement( display as IVisualElement );
		}
		
		protected function addToContainer( display:Sprite):void
		{
			(container as Group).addElement( display as IVisualElement );
		}      
		
		protected function removeFromHandlesContainer( display:Sprite):void
		{
			(handlesContainer as Group).removeElement( display as IVisualElement );    
		}
		
		protected function removeFromContainer( display:Sprite):void
		{
			(container as Group).removeElement( display as IVisualElement );            
		}
		
		
		protected function removeHandles( model:Object ) : void
		{
			var currentHandles:Array = handles[model];
			for each ( var handle:IHandle in currentHandles )
			{              
				if( handleCache.length <= 10 )
				{
					handle.visible = false;
					handleCache.push( handle );
				}
				else
				{
					removeFromHandlesContainer( handle as Sprite);                  
				}
			}
			
			delete handles[model];
			
		}
		
		public function get isHandleDragging():Boolean
		{
			return _isHandleDragging
		}
		
		/* added by greg */
		// return the rotated point coordinates
		// help from http://board.flashkit.com/board/showthread.php?t=775357        
		public function getRotatedRectPoint( angle:Number, point:Point, rotationPoint:Point = null):Point {
			var ix:Number = (rotationPoint) ? rotationPoint.x : 0;
			var iy:Number = (rotationPoint) ? rotationPoint.y : 0;
			var m:Matrix = new Matrix( 1,0,0,1, point.x - ix, point.y - iy);
			m.rotate(angle);
			return new Point( m.tx + ix, m.ty + iy);
		}
		/* end added */        
	}
}
