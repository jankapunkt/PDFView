package com.jankuester.pdfviewer.core.cos
{
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class COSDictionary extends COSBase
	{
		
		public function COSDictionary()
		{
			super();
		}
		
		public var reference:String;
		
		protected var _dict:Dictionary;
		
		
		override public function print():void
		{
			trace(" ---- PRINT COS DICTIONARY -----");
			for each (var i:* in _dict) 
			{
				trace(i+" => " + _dict[i]);
			}
			trace("-------- END --------------------");
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			_source = source;
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
		}
		
		public function getReferenceById(id:String):String
		{
			id = id.replace(/\s+/g,"");
			id = id.replace("/","");
			return _dict[id];
		}
		
	}
}