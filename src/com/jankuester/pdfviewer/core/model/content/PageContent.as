package com.jankuester.pdfviewer.core.model.content
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	
	public class PageContent extends COSDictionary
	{
		public function PageContent()
		{
			super();
		}
		
		protected var _stream:String;
		
		public function get stream():String
		{
			return _dict[PDFConstants.CONTAINER_STREAM];
		}

		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("-------------------- content -------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			trace("content parsed");
		}
	}
}