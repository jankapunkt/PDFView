package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;

	public class TrailerTokenizer implements ITokenizer, IDisposable
	{
		public function TrailerTokenizer(){}
		
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
			
			if (_source == null)return null;
			_source.position = 0;
			var dict:Dictionary = new Dictionary();
			var lines:Vector.<String> = PdfBinaryUtils.getLines(_source);
			for (var i:int = 0; i < lines.length; i++) 
			{
				var split:Array = lines[i].split("/");
				for (var j:int = 0; j < split.length; j++) 
				{
					
					if(split[j].indexOf(PDFConstants.TRAILER_ROOT)>-1)
					{
						var root:Array = split[j].split(PDFConstants.TRAILER_ROOT+" ");
						dict[PDFConstants.TRAILER_ROOT] = root[1];
					}
					if(split[j].indexOf(PDFConstants.TRAILER_SIZE)>-1)
					{
						var size:Array = split[j].split(PDFConstants.TRAILER_SIZE+" ");
						dict[PDFConstants.TRAILER_SIZE] = size[1];
					}
					if(split[j].indexOf(PDFConstants.TRAILER_INFO)>-1)
					{
						var info:Array = split[j].split(PDFConstants.TRAILER_INFO+" ");
						dict[PDFConstants.TRAILER_INFO] = info[1];
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