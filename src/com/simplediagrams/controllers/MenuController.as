package com.simplediagrams.controllers
{
	
	import com.simplediagrams.events.AboutEvent;
	import com.simplediagrams.events.PreferencesEvent;
	import com.simplediagrams.model.*;
	import com.simplediagrams.view.AboutWindow;
	import com.simplediagrams.view.dialogs.PreferencesDialog;
	import com.simplediagrams.controllers.DialogsController
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	import org.swizframework.controller.AbstractController;
	
	public class MenuController extends AbstractController
	{
		
		/* Put any function here that the user can access via the menu but which really can't be put in any other controller */
		
		[Autowire(bean="dialogsController")]
		public var dialogsController:DialogsController
		
		protected var _aboutWindow:AboutWindow
		protected var _preferencesDialog:PreferencesDialog
		
		public function MenuController()
		{
		}
		
		[Mediate(event="AboutEvent.SHOW_ABOUT_WINDOW")]
		public function showAboutWindow(event:AboutEvent):void
		{
			
			_aboutWindow = dialogsController.showAboutDialog()
			_aboutWindow.addEventListener("close", onAboutWindowClose)
		}
		
		protected function onAboutWindowClose(event:Event):void
		{
			if (_aboutWindow)
			{
				dialogsController.removeDialog(_aboutWindow)
				_aboutWindow.removeEventListener("close", onAboutWindowClose)	
				_aboutWindow = null			
			}
		}	
		
		[Mediate(event="PreferencesEvent.SHOW_PREFERENCES_WINDOW")]
		public function showPreferencesWindow(event:PreferencesEvent):void
		{
			_preferencesDialog = dialogsController.showPreferencesDialog()
			_preferencesDialog.addEventListener("OK", onPreferencesOK)
			_preferencesDialog.addEventListener(Event.CANCEL, onPreferencesCancel)
		}
		
		protected function onPreferencesOK(event:Event):void
		{
			closePreferencesDialog()			
		}
		
		protected function onPreferencesCancel(event:Event):void
		{
			closePreferencesDialog()
		}
		
		protected function closePreferencesDialog():void
		{
			if (_preferencesDialog)
			{
				_preferencesDialog.removeEventListener("OK", onPreferencesOK)
				_preferencesDialog.removeEventListener(Event.CANCEL, onPreferencesCancel)
				dialogsController.removeDialog(_preferencesDialog)
				_preferencesDialog = null
			}
		}	
		
	}
}