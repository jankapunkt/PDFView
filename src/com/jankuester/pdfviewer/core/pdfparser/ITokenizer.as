package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;

	public interface ITokenizer extends IDisposable
	{
		function load(source:ByteArray):void;
		function getTokensAsArrayList():ArrayList;
		function getTokensAsDictionary():Dictionary;
		function clean(s:String):String;
	}
}