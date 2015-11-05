package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class FontUnicodeMapping extends COSDictionary
	{
		public function FontUnicodeMapping()
		{
			super();
		}
		
		protected var _cmap:Dictionary;

		public function get cmap():Dictionary
		{
			return _cmap;
		}
		
		//TODO: https://de.wikipedia.org/wiki/UTF-16
		public function mapChar(char:String):String
		{
			return _cmap[char];
		}

		public function mapStream(stream:String):String
		{
			return "";
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("-------------- FONT UNICODE --------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			var decoded:String = _dict[PDFConstants.CONTAINER_STREAM];
			//trace(decoded);
			var mapList:String = decoded.substring(
				decoded.indexOf(PDFConstants.FONT_BEGINBFCHAR)+PDFConstants.FONT_BEGINBFCHAR.length,
				decoded.indexOf(PDFConstants.FONT_ENDBFCHAR)
				);
			_cmap = new Dictionary();
			
			var lines:Array = mapList.split("\n");
			for (var i:int = 0; i < lines.length; i++) 
			{
				
				var pair:Array = lines[i].split(" ");
				if (pair.length>1)
				{
					_cmap[tokenizer.clean(pair[0])] = tokenizer.clean(pair[1]);
					trace(tokenizer.clean(pair[0])+" ===>" +String.fromCharCode("0x"+tokenizer.clean(pair[1])));
				}
			}
			
		}
	}
}