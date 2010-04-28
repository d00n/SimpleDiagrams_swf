package com.simplediagrams.view.SDComponents
{
	
	import com.simplediagrams.model.SDObjectModel;
	
	public interface ISDComponent
	{
		function set objectModel(objectModel:SDObjectModel):void
		function get objectModel():SDObjectModel;
		function get sdID():Number;
		function set sdID(value:Number):void;
		function destroy():void
		
		
	}
}