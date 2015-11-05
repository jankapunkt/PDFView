package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	
	public class CatalogTokenizer implements ITokenizer, IDisposable
	{
		public function CatalogTokenizer(){}
		
		protected var _source:ByteArray;
		
		public function load(source:ByteArray):void
		{
			_source = source;	
		}
		
		public function getTokensAsArrayList():ArrayList
		{
			return null;
		}
		
		public function getTokensAsDictionary():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			var lines:Vector.<String> = PdfBinaryUtils.getLines(_source);
			for (var i:int = 0; i < lines.length; i++) 
			{
				var line:String = lines[i];
				var split:Array = lines[i].split("/");
				for (var j:int = 0; j < split.length; j++) 
				{
					if(split[j].indexOf(PDFConstants.KEY_PAGES)>-1)
					{
						var pages:Array = split[j].split(PDFConstants.KEY_PAGES+" ");
						dict[PDFConstants.KEY_PAGES] = pages[1];
					}
				}
			}
			
			return dict;
		}
		
		public function dispose():void
		{
			_source = null;
		}
		
		
		public function clean(s:String):String
		{
			return s;
		}
	}
}