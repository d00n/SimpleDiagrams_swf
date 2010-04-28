package com.simplediagrams.model.dao
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class DAO extends EventDispatcher
	{
		private var _id:int
		
		public function DAO()
		{
		}
				
		[Id]
		public function get id():int	
		{
			return _id
		}

		public function set id(value:int):void
		{
			_id = value
		}
	}
}