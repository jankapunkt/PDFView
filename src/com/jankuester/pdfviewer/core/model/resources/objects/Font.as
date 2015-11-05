package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	
	public class Font extends COSDictionary
	{
		public function Font()
		{
			super();
		}
		
		public var name:String;
		public var subType:String;
		
		protected var _fontDescriptor:FontDescriptor;

		public function get fontDescriptor():FontDescriptor
		{
			return _fontDescriptor;
		}

		
		protected var _toUnicode:FontUnicodeMapping;

		public function get toUnicode():FontUnicodeMapping
		{
			return _toUnicode;
		}
		
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("-------------- FONT --------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			
			subType = _dict[PDFConstants.KEY_SUBTYPE];
			if (subType!=null)
			{
				switch(subType)
				{
					case PDFConstants.FONT_TRUETYPE:
						loadTrueType(tokenizer);
						break;
					default:
						break;
				}
			}
		}
		
		private function loadTrueType(tokenizer:ITokenizer):void
		{
			_fontDescriptor = new FontDescriptor();
			_fontDescriptor.reference = _dict[PDFConstants.FONT_FONTDESCRIPTOR];
			_fontDescriptor.subType = PDFConstants.FONT_TRUETYPE;
			_fontDescriptor.load(XRef.instance().getReferenceBytes(_fontDescriptor.reference),tokenizer);
			
			_toUnicode = new FontUnicodeMapping();
			_toUnicode.reference = _dict[PDFConstants.FONT_TOUNICODE];
			trace("unicode ref: "+_toUnicode.reference);
			_toUnicode.load(XRef.instance().getReferenceBytes(_toUnicode.reference),tokenizer);
			
		}
		
	}
}