package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	
	public class XObject extends COSDictionary
	{
		public function XObject()
		{
			super();
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("------------------------- load XOBJECT ----------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
		}
	}
}