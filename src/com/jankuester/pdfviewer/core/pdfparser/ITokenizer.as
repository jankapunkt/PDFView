package com.jankuester.pdfviewer.core.pdfparser
{
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;

	public interface ITokenizer extends IDisposable
	{
		function load(source:ByteArray):void;
		function getTokensAsArrayList():ArrayList;
		function getTokensAsDictionary():Dictionary;
		function clean(s:String):String;
	}
}