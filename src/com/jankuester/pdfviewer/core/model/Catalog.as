package com.jankuester.pdfviewer.core.model
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.pages.PageTree;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	
	public class Catalog extends COSDictionary
	{
		protected var _pageTree:PageTree;
		
		//TODO Outline Hierarchy
		
		//TODO Article Threads
		
		//TODO Named Destinations
		
		//TODO Interactive For
		
		
		
		public function Catalog()
		{
			super();
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			trace("catalog parsed, found:");
			for (var key:Object in _dict)
			{
				trace(key, _dict[key]);
			}
		}
		
		public function get pages():String
		{
			return _dict[PDFConstants.KEY_PAGES];
		}
		

	}
}