package com.jankuester.pdfviewer.core.model.resources.objects
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FontFile extends COSDictionary
	{
		public function FontFile()
		{
			super();
		}
		
		public var fontName:String;
		
		public var subType:String;
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("----------------- FONT FILE -----------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			var decoded:ByteArray = _dict[PDFConstants.CONTAINER_STREAM];
			var streampos:Array = PdfBinaryUtils.findStreamPositions(decoded);
			//trace(ByteArrayUtils.readString(decoded));
			var f:File = File.desktopDirectory.resolvePath(fontName+".ttf");
			var fs:FileStream = new FileStream();
				fs.open(f, FileMode.WRITE);
				fs.writeBytes(decoded,streampos[0],streampos[1]-streampos[0]);
				fs.close();
		}
	}
}