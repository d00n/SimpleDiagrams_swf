////////////////////////////////////////////////////////////////////////////////
//
//  Andy Andreas Hulstkamp. AH 2009.
//  Flex 4 beta.
//
////////////////////////////////////////////////////////////////////////////////

package com.simplediagrams.view.components
{
	import org.swizframework.Swiz
	import com.simplediagrams.events.AlignEvent
	
	import flash.events.Event
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import flashx.textLayout.formats.VerticalAlign;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Button;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.DropDownEvent;
	import spark.primitives.Rect;
	import spark.primitives.supportClasses.FilledElement;
	
	
						
	/**
	 *  Open State of the DropDown component
	 */
	[SkinState("open")]
	
	/**
	 * Over State of the DropDown component.
	 * When the mouse is over the open element
	 */
	[SkinState("over")]
	
		
	public class AlignButtonPopUp extends SkinnableComponent
	{

		/**
		 * 
		 */
		[SkinPart(required="true")]
		public var dropDown:Group;
		
		[SkinPart(required="true")]
		public var openButton:Button
		
		[SkinPart(required="true")]
		public var buttonGroup:VGroup;
		
		
		[SkinPart(required="true")]
		public var btnAlignRight:Button
		
		[SkinPart(required="true")]
		public var btnAlignLeft:Button
		
		[SkinPart(required="true")]
		public var btnAlignCenter:Button
		
		[SkinPart(required="true")]
		public var btnAlignTop:Button
		
		[SkinPart(required="true")]
		public var btnAlignBottom:Button
		
		[SkinPart(required="true")]
		public var btnAlignMiddle:Button
		
		
		
				
		
		public function AlignButtonPopUp()
		{
			super();
			init();
		}
		
		/**
		 * Sets up the Component. Called from the constructor 
		 * 
		 */
		protected function init():void
		{
			this.useHandCursor = true;
			this.buttonMode = true;
		}
		
				
		//stores state for open of dropdown
		private var _isOpen:Boolean = false;
		
		//stores state for button over
		private var _isOver:Boolean = false;
		
		//The gap between the rating icons fetched from the skin
		private var gap:Number = 0;
		
				
		/**
		 *  @private
		 */
		override public function set enabled(value:Boolean):void
		{
			if (value == enabled)
				return;
			
			super.enabled = value;
			if (openButton)
				openButton.enabled = value;
		}
		
		/**
		 *  Leverage the SkinStates
		 */ 
		override protected function getCurrentSkinState():String
		{
			return !enabled ? "disabled" : _isOpen ? "open" : _isOver ? "over" : "normal";
		}   
		
		/**
		 * Overriden.
		 * Add behaviours to the SkinParts and setup the containers with the icons
		 *  @private
		 */ 
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == openButton)
			{				
				openButton.addEventListener(MouseEvent.MOUSE_DOWN, dropDownButton_buttonDownHandler);
				openButton.addEventListener(MouseEvent.MOUSE_OVER, dropDownButton_buttonOverHandler);
				openButton.addEventListener(MouseEvent.MOUSE_OUT, dropDownButton_buttonOutHandler);
			}
			
			
			if (instance == btnAlignTop)
			{
				btnAlignTop.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignMiddle)
			{
				btnAlignMiddle.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignBottom)
			{
				btnAlignBottom.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignLeft)
			{
				btnAlignLeft.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignCenter)
			{
				btnAlignCenter.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignRight)
			{
				btnAlignRight.addEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
		
		}
		
		/**
		 * Overriden.
		 * Cleans up the skins-parts when they are removed by the framework.
		 * Remove EventListeners that have been added when part was added
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == openButton) 
			{
				openButton.removeEventListener(FlexEvent.BUTTON_DOWN, dropDownButton_buttonDownHandler);
				openButton.removeEventListener(MouseEvent.MOUSE_OVER, dropDownButton_buttonOverHandler);
				openButton.removeEventListener(MouseEvent.MOUSE_OUT, dropDownButton_buttonOutHandler);
			}
			
			if (instance == btnAlignTop)
			{
				btnAlignTop.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignMiddle)
			{
				btnAlignMiddle.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignBottom)
			{
				btnAlignBottom.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignLeft)
			{
				btnAlignLeft.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignCenter)
			{
				btnAlignCenter.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			if (instance == btnAlignRight)
			{
				btnAlignRight.removeEventListener(MouseEvent.MOUSE_DOWN, onAlignButton)
			}
			
			super.partRemoved(partName, instance);
		}
		
		/**
		 * Overriden.
		 * Manage the properties that are used and centralize updates here.
		 *  @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
		}  
		
		//--------------------------------------------------------------------------
		//
		//  New Methods
		//
		//--------------------------------------------------------------------------   
		
		
		public function onAlignButton(event:MouseEvent):void
		{
			var evt:AlignEvent
			
			if (event.target==btnAlignTop)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_TOP)
			}
			else if (event.target==btnAlignMiddle)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_MIDDLE)
			}
			else if (event.target==btnAlignBottom)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_BOTTOM)
			}
			else if (event.target==btnAlignLeft)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_LEFT)
			}
			else if (event.target==btnAlignCenter)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_CENTER)
			}
			else if (event.target==btnAlignRight)
			{
				evt = new AlignEvent(AlignEvent.ALIGN_RIGHT)
			}
			
			Swiz.dispatchEvent(evt)	
		}
		
		public function openDropDown():void
		{
			_isOpen = true;
			addMoveHandlers();
			invalidateSkinState();
			this.dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
		}
		
		public function closeDropDown():void
		{
			_isOpen = false;
			_isOver = false;
			removeMoveHandlers();
			invalidateSkinState();
			this.dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
		}
				
		protected function addMoveHandlers():void 
		{
			openButton.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
			openButton.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
		}
		
		protected function removeMoveHandlers():void 
		{
			openButton.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
			openButton.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
		}
		
			
		protected function systemManager_mouseUpHandler(event:Event):void {
			closeDropDown();
		}
		
		protected function dropDownButton_buttonDownHandler (event:Event):void {
			if (_isOpen) 
			{
				closeDropDown();
			} 
			else 
			{
				openDropDown();
			}
		}
		
		protected function dropDownButton_buttonOverHandler (event:Event):void {
			_isOver = true;
			invalidateSkinState();
		}
		
		protected function dropDownButton_buttonOutHandler (event:Event):void {
			_isOver = false;
			invalidateSkinState();
		}
	}
}
