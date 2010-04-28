
package com.simplediagrams.view.components
{
	import spark.components.Button;
	import spark.primitives.BitmapImage;
	
	[Style(name="icon", type="Class")]
	public class IconButton extends Button
	{
		[SkinPart(required="true")]
		public var bmpIcon:BitmapImage;
		
		public function IconButton()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if ( partName == "bmpIcon" ) 
			{
				var iconClass:Class = Class(getStyle("icon"));
				if ( iconClass == null )
				{
					instance = null;
				}
				else
				{
					BitmapImage(instance).source = new iconClass();
				}
			}
		}
	}
}

