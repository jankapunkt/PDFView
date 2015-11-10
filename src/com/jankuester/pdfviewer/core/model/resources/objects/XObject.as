package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	
	public class XObject extends COSDictionary
	{
		public function XObject()
		{
			super();
		}
		
		public function getStream():ByteArray
		{
			return _dict[PDFConstants.CONTAINER_STREAM];
		}
		public function getType():String
		{
			return  _dict[PDFConstants.TAG_FILTER];
		}
		
		public function getWidth():int
		{
			return int(_dict["width"]);
		}
		
		public function getHeight():int
		{
			return int(_dict["height"]);
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
		}
	}
}