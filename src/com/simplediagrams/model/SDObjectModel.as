package com.simplediagrams.model
{
	
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import com.simplediagrams.events.RemoteSharedObjectEvent;
	import com.simplediagrams.model.mementos.SDObjectMemento;
	import com.simplediagrams.model.mementos.TransformMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.ISDComponent;
	
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	
	import org.spicefactory.lib.reflect.ClassInfo;

	[Bindable]
	
	//public class SDObjectModel extends DAO implements IResizeable, IMoveable
	public class SDObjectModel extends EventDispatcher implements IResizeable, IMoveable
	{
		
		
		public static const TEXT_POSITION_ABOVE:String = "above"
		public static const TEXT_POSITION_TOP:String = "top"
		public static const TEXT_POSITION_MIDDLE:String = "middle"
		public static const TEXT_POSITION_BOTTOM:String = "bottom"
		public static const TEXT_POSITION_BELOW:String = "below"
			
		
		public static const DELETE_SD_COMPONENT:String = "deleteSDComponent" //when SDObjectModel disptaches an event with this type, the related component is deleted
		
		private var _sdID:Number = 0;
		private var _x:Number = 10;
        private var _y:Number  = 10;
        public var _height:Number = 50; //needs to be set without invoking dispatch
        public var _width:Number = 50; //needs to be set without invoking dispatch
        private var _rotation:Number = 0;
		private var _zIndex:int = 0;
		private var _color:Number= 0xFFFFFF;
		public var maintainProportion:Boolean = false;
		public var diagramID:int
		public var colorizable:Boolean = true;
		public var depth:Number = 0;
		
		private var _startState:TransformMemento
		private var _allowRotation:Boolean = true
		private var _selected:Boolean
		
		//preserve the state of this model before it's transformed via ObjectHandles
		private var _startTransformState:SDObjectMemento
						
		public var iconClass:Class 
	
		public var sdComponent:ISDComponent
				
		public function SDObjectModel()
		{		
			
		}
		
		
		public function set sdID(v:Number):void
		{
			_sdID = v
		}
		
		public function get sdID():Number
		{
			return _sdID
		}
		
		public function set selected(v:Boolean):void
		{
			_selected = v
		}
		
		public function get selected():Boolean
		{
			return _selected
		}
					
		public function set allowRotation(v:Boolean):void
		{
			_allowRotation = v
		}
		
		public function get allowRotation():Boolean
		{
			return _allowRotation
		}
				
		public function get symbolClass():Class
		{
			return this.iconClass
		}
				
		public function createSDComponent():ISDComponent
		{
			throw new Error("Abstract method!")
		}
		
		
		/* VALUES SAVED INTO DB */
				
		public function get color():Number
		{
			return _color	
		}
		
	 	public function set color(value:Number):void
	 	{
	 		_color = value;
	 	}			
				
        public function get rotation():Number
        {
        	return _rotation;
        }

        public function set rotation(v:Number):void
        {
        	_rotation = v;
        }
        	
        public function get width():Number
        {
        	return _width;
        }

        public function set width(v:Number):void
        {
        	_width = v;
        }
		
        public function get height():Number
        {
        	return _height;
        }

        public function set height(v:Number):void
        {
        	_height = v;
        }

        public function get y():Number
        {
        	return _y;
        }

        public function set y(v:Number):void
        {
        	_y = v;
        }
		
		public function get x():Number
		{
			return _x;
		}

		public function set x(v:Number):void
		{
			_x = v;
		}
		
		public function get zIndex():int	
		{
			return _zIndex
		}

		public function set zIndex(value:int):void
		{
			_zIndex = value
		}
	
		
		public function toDetailedString():String
		{
			
			var ci:ClassInfo = ClassInfo.forInstance(this);
				
			var s:String = "\n SDObjectModel: \n-----------------------" +
				"\nclass: " + ci.simpleName + 
				"\nx:" + x + "\ny: " + y + "\nwidth: " + width + "\nheight: " + height +
				"\nzIndex: " + zIndex + "\nrotation: " + rotation + "\ncolor: " + color + 
				"\ndiagramID: " + diagramID + "\n"
			return s
		}
		
		public function destroy():void
		{
			sdComponent.destroy()
			sdComponent = null
		}
		
		
		/* CLONE FUNCTION */
		
		public  function clone( deep:Boolean = false , instance:SDObjectModel = null ):SDObjectModel
        {
            if( instance == null )
            {
                var c:Class = this['constructor'] as Class;
                instance = new c() as SDObjectModel;
            }
            // get class info from instanstiated object (aka the 'this' pointer)
            var classInfo:XML = describeType(this);
            var propertyName:String;
            var propertyValue:Object;
            // List the object's variables, their values, and their types.
            for each ( var v:XML in classInfo..variable )
            {
                propertyName = v.@name;
                propertyValue = this[propertyName];
                checkObjectTypeAndClone(propertyName , propertyValue , deep , instance);
            }

            // List accessors as properties.
            for each ( var a:XML in classInfo..accessor )
            {
                // Do not user the property if it can't be read or written
                if( a.@access == 'readwrite' )
                {
                    propertyName = a.@name;
                    propertyValue = this[propertyName];
                    checkObjectTypeAndClone(propertyName , propertyValue , deep , instance);
                }

            }

            return instance;
        }
        
        protected function checkObjectTypeAndClone( propertyName:String , propertyValue:Object , deep:Boolean , instance:Object ):void
        {
            if( deep && propertyValue is SDObjectModel )
            {
                instance[propertyName] = SDObjectModel(propertyValue).clone(deep);
            }
            else if( propertyValue is Array )
            {
                instance[propertyName] = cloneArray(propertyValue as Array , deep);
            }
            else if( propertyValue is ArrayCollection )
            {
                instance[propertyName] = new ArrayCollection(cloneArray(ArrayCollection(propertyValue).source , deep));
            }
            else
            {
                instance[propertyName] = propertyValue;
            }
        }

		protected function cloneArray( val:Array , deep:Boolean = false ):Array
        {
            var clonedObj : Array = new Array;
            for( var i:int = 0 ; i < val.length ; i++ )
            {
                if( deep && val[i] is SDObjectModel )
                {
                    clonedObj[i] = SDObjectModel(val[i]).clone(true);
                }
                else if( val[i] is Array )
                {
                    clonedObj[i] = cloneArray(val[i] , deep);
                }
                else if( val[i] is ArrayCollection )
                {
                    clonedObj[i] = new ArrayCollection(cloneArray(ArrayCollection(val[i]).source , deep));
                }
                else
                {
                    clonedObj[i] = val[i];
                }
            }
            return clonedObj;
        }
		
		
		protected function captureBasePropertiesInMemento(memento:SDObjectMemento):SDObjectMemento
		{
		    memento.sdID = _sdID
			memento.x = _x
			memento.y = _y
			memento.width = _width
			memento.height = _height
			memento.color = _color
			memento.rotation = _rotation
			memento.zIndex = _zIndex
			
			return memento
		}
				
		
		public function setBasePropertiesFromMemento(memento:SDObjectMemento):void
		{
			sdID = memento.sdID
			x = memento.x
			y = memento.y
			width = memento.width
			height = memento.height
			color = memento.color
			rotation = memento.rotation
			zIndex = memento.zIndex
		}
		
		
		public function captureStartState():void
		{			
			_startState = getTransformState()
		}
	
		public function getStartTransformState():TransformMemento
		{
			if (!_startState)
			{
				captureStartState()
			}
				
			//don't want to return a direct reference because this would interfere with garbage collection
			return _startState.clone()
		}
		
		public function getTransformState():TransformMemento
		{
			var memento:TransformMemento = new TransformMemento()
			memento.x = x
			memento.y = y
			memento.width = width
			memento.height = height
			memento.rotation = rotation
			memento.zIndex = zIndex
			memento.color = color
			return memento
		}
		
		public function setTransformState(memento:TransformMemento):void
		{
			x = memento.x
			y = memento.y
			width = memento.width
			height = memento.height
			rotation = memento.rotation
			zIndex = memento.zIndex
			color = memento.color;

		}
		
		public function getMemento():SDObjectMemento
		{
			throw new Error("Override getMemento()")
		}
		
		public function setMemento(memento:SDObjectMemento):void
		{
			throw new Error("Override setMemento()")
		}
		
		
	}
}

