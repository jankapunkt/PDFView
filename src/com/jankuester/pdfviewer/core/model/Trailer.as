package com.jankuester.pdfviewer.core.model
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	
	public class Trailer extends COSDictionary
	{	
		public function Trailer()
		{
			super();
		}
		
		public function get root():String
		{
			return _dict[PDFConstants.TRAILER_ROOT];
		}
		
		public function get size():String
		{
			return _dict[PDFConstants.TRAILER_SIZE];
		}
		
		public function get info():String
		{
			return _dict[PDFConstants.TRAILER_INFO];	
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("----------------- Trailer -------------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
		}
	}
}