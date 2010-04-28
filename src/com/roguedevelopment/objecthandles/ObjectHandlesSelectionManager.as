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
 *  See README for more information.
 * 
 **/
 
package com.roguedevelopment.objecthandles
{
	import com.simplediagrams.events.SelectionEvent;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.SDBase;
	
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.swizframework.Swiz;
	
	[Event(name="removedFromSelection", type="com.simplediagrams.events.SelectionEvent")]
	[Event(name="selectionCleared", type="com.simplediagrams.events.SelectionEvent")]
	[Event(name="addedToSelection", type="com.simplediagrams.events.SelectionEvent")]
	public class ObjectHandlesSelectionManager extends EventDispatcher
	{
		public var currentlySelected:Array = [];
		
		public function ObjectHandlesSelectionManager()
		{
		}
		
		public function addToSelected( model:Object ) : void
		{
			//Logger.debug("adding to selected: model: " + model.iconClass, this)
			if( currentlySelected.indexOf( model ) != -1 ) { return; } // already selected
			
			//Logger.debug("model isn't selectd, so go ahead and add it. ", this)
		
			//if this is a textArea, don't set it's selected property to true it b/c it will prevent deletes
			if (model is SDTextAreaModel)
			{
				
			}
			else
			{
				//DMcQ: Set the selected property on model so skins and things know what to do
				SDObjectModel(model).selected = true
			}
				
			//~DMcQ
							
			currentlySelected.push(model);
			
			//Logger.debug("currentlySelected is now: " + currentlySelected.iconClass, this)
			
			//DMcQ make the visual object get focus
			var sdComponent:SDBase = SDObjectModel(model).sdComponent as SDBase			
			sdComponent.focusManager.setFocus(sdComponent)		
			
			//DMcQ: using our own SelectionEvent so Swiz can pick it up correctly
			var evt:SelectionEvent = new SelectionEvent( SelectionEvent.ADDED_TO_SELECTION, true );
			evt.targets.push( model );
			Swiz.dispatchEvent( evt)
		}

		public function isSelected( model:Object ) : Boolean
		{
			return currentlySelected.indexOf( model ) != -1;
		}

		
		public function setSelected( model:Object ) : void
		{			
			//Logger.debug("setting selected: " + model.iconClass, this)
			if( currentlySelected.indexOf( model ) != -1 ) { return; } // already selected
			clearSelection();                 
			addToSelected( model );                 
			
			//DMcQ make the visual object get focus
			var sdComponent:SDBase = SDObjectModel(model).sdComponent as SDBase
			sdComponent.focusManager.setFocus(sdComponent)
				
			//DMcQ: Set the selected property on model so skins and things know what to do
			SDObjectModel(model).selected = true
		}

		
		
		public function removeFromSelected( model:Object ) : void
		{
			
			//Logger.debug("removing from selected: model: " + model.iconClass, this)
			var ind:int = currentlySelected.indexOf(model);
			if( ind == -1 ) { return; }
			
			//Logger.debug("model is selectd, so go ahead and remove it. ", this)
			
			currentlySelected.splice(ind,1);			
			
			//Logger.debug("currentlySelected is now: " + currentlySelected.iconClass, this)
				
			//DMcQ: Set the selected property on model so skins and things know what to do
			SDObjectModel(model).selected = false
			
			//DMcQ: using swiz...
			var event:SelectionEvent = new SelectionEvent( SelectionEvent.REMOVED_FROM_SELECTION, true);
			event.targets.push(model);			
			Swiz.dispatchEvent( event );
					
		}

		public function clearSelection() : void
		{
			
			for each (var model:Object in currentlySelected)
			{
				if (model is SDObjectModel)
				{
					SDObjectModel(model).selected = false
				}
			}
			
			currentlySelected = [];		
				
			//DMcQ: using swiz...
			var event:SelectionEvent = new SelectionEvent( SelectionEvent.SELECTION_CLEARED );
			event.targets = currentlySelected;	
			Swiz.dispatchEvent( event );	
						
		}
		
		public function getGeometry() : DragGeometry
		{
			var obj:Object;
			var rv:DragGeometry;
			
			// no selected objects
			if( currentlySelected.length == 0 ) { return null; }
			
			// only one selected object
			if( currentlySelected.length == 1) 
			{
				obj = currentlySelected[0];
				rv = new DragGeometry();
				
				if( obj.hasOwnProperty("x") ) rv.x = obj["x"];
				if( obj.hasOwnProperty("y") ) rv.y = obj["y"];
				if( obj.hasOwnProperty("width") ) rv.width = obj["width"];
				if( obj.hasOwnProperty("height") ) rv.height = obj["height"];
				if( obj.hasOwnProperty("rotation") ) rv.rotation = obj["rotation"];
				
				return rv;
			} 
			else // a lot of selected objects
			{
				return calculateMultiGeometry();
			}
			return null;
		}
		
		protected function calculateMultiGeometry() : DragGeometry
		{
			var rv:DragGeometry;
			var lx1: Number = Number.POSITIVE_INFINITY; // top left bounds
			var ly1: Number = Number.POSITIVE_INFINITY;
			var lx2: Number = Number.NEGATIVE_INFINITY; // bottom right bounds
			var ly2: Number = Number.NEGATIVE_INFINITY;
			
			var matrix:Matrix = new Matrix();
			var temp:Point = new Point();
			var temp2:Point = new Point();
			
			for each(var modelObject:Object in currentlySelected) 
			{                       
				matrix.identity();
				if( modelObject.hasOwnProperty("rotation") )
				{
					matrix.rotate( toRadians(modelObject.rotation) );
				}
				matrix.translate( modelObject.x, modelObject.y );
				
				
				temp.x=0; // Check top left
				temp.y=0;
				temp = matrix.transformPoint(temp);                             
				
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );
				
				temp.x=0; // Check bottom left
				temp.y=modelObject.height;
				temp = matrix.transformPoint(temp);                             
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );
				
				temp.x=modelObject.width; // Check top right
				temp.y=0;
				temp = matrix.transformPoint(temp);                             
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );
				
				temp.x=modelObject.width; // Check top right
				temp.y=modelObject.height;
				temp = matrix.transformPoint(temp);                             
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );
				
				
			}
			rv = new DragGeometry();
			rv.rotation = 0;
			rv.x = lx1;
			rv.y = ly1;
			rv.width = lx2 - lx1;
			rv.height = ly2 - ly1;
			return rv;
		}
		
		protected static function toRadians( degrees:Number ) :Number
		{
			return degrees * Math.PI / 180;
		}               
		
		public function getGeometryForObject(a:Object) : DragGeometry
		{
			// Just return coordinates of object
			
			var obj:Object = a;
			var rv:DragGeometry = new DragGeometry();
			
			if( obj.hasOwnProperty("x") ) rv.x = obj["x"];
			if( obj.hasOwnProperty("y") ) rv.y = obj["y"];
			if( obj.hasOwnProperty("width") ) rv.width = obj["width"];
			if( obj.hasOwnProperty("height") ) rv.height = obj["height"];
			if( obj.hasOwnProperty("rotation") ) rv.rotation = obj["rotation"];
			
			return rv;
		}

		
		public function debugShowSelected():void
		{
			Logger.debug("currently selected: ",this)
			for each (var model:SDObjectModel in currentlySelected)
			{				
				Logger.debug("  model: " + model,this)
			}
		}

	}
}