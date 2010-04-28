package com.simplediagrams.model.libraries
{
	/* This defines the interface for libraries loaded from signed library files */
	
	public interface ILibraryModule
	{
		function get libraryName():String
		function get displayName():String
		function get fileName():String
		function get isPremium():Boolean
		function get isPlugin():Boolean
		function get library():Array
	}
}