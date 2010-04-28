package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class SimpleDiagramsLoginEvent extends Event
	{

		public static const ATTEMPT_LOGIN:String = "attemptSimpleDiagramsLogin"
		public static const CLEAR_LOGIN_CREDENTIALS:String = "attemptSimpleDiagramsLogin"
		
		public function SimpleDiagramsLoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}