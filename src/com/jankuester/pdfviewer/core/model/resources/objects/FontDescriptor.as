package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	
	public class FontDescriptor extends COSDictionary
	{
		public function FontDescriptor()
		{
			super();
		}
		
		protected var _fontFile:FontFile;
		
		public var fontName:String;
		public var subType:String;
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("-------------- FONT DESCRIPTOR --------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			
			var fname:String = _dict[PDFConstants.FONT_FONTNAME];
			if (fname != null)
			{
				fontName = fname;
			}
			
			if (subType == PDFConstants.FONT_TRUETYPE)
			{
				trace("fontfile for: "+subType);
				_fontFile = new FontFile();
				_fontFile.fontName = fontName;
				_fontFile.reference = _dict[PDFConstants.FONT_FILE2];
				_fontFile.load(XRef.instance().getReferenceBytes(_fontFile.reference),tokenizer);	
			}
			
		}
		
	}
}