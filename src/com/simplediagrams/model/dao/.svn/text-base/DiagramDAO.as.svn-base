package com.simplediagrams.model.dao
{
		
	[Bindable]
	[Table(name="diagrams")]
	public class DiagramDAO extends DAO
	{
			
		public var name:String = ""
		public var description:String	
		public var styleName:String		
		public var horizontalScrollPosition:Number 
		public var verticalScrollPosition:Number
		public var width:Number = 2000
		public var height:Number = 1600;
		public var baseBackgroundColor:Number = 0xFFFFFF;
		
		[Transient]
		public var scaleX:Number = 1;
		
		[Transient]
		public var scaleY:Number = 1;
		
			
		[Column(name="updated_at")]
		public var updatedAt:Date = new Date();
				
		[Column(name="created_at")]
		public var createdAt:Date = new Date();
			
		public function DiagramDAO()
		{
		}
		
		
	}
}