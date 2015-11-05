package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	/*
	
	<</Type/Pages
	/Resources 43 0 R
	/MediaBox[ 0 0 595 842 ]
	/Kids[ 1 0 R 6 0 R 11 0 R 16 0 R 21 0 R 26 0 R ]
	/Count 6>>
	
	*/
	public class PageNodeTokenizer implements ITokenizer
	{
		public function PageNodeTokenizer()
		{
		}
		
		protected var _source:ByteArray;
		
		public function load(source:ByteArray):void
		{
			_source = source;
		}
		
		public function getTokensAsArrayList():ArrayList
		{
			return null;
		}
		
		public function getTokensAsDictionary():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			var lines:Vector.<String> = PdfBinaryUtils.getLines(_source);
			for (var i:int = 0; i < lines.length; i++) 
			{
				var line:String = lines[i];
				var split:Array = lines[i].split("/");
				for (var j:int = 0; j < split.length; j++) 
				{
					//trace(split[j]);
					if(split[j].indexOf(PDFConstants.PAGE_COUNT)>-1)
					{
						var count:Array = split[j].split(PDFConstants.PAGE_COUNT+" ");
						dict[PDFConstants.PAGE_COUNT] = clean( count[1] );
					}
					if(split[j].indexOf(PDFConstants.PAGE_KIDS)>-1)
					{
						var kids:Array = split[j].split(PDFConstants.PAGE_KIDS);
						dict[PDFConstants.PAGE_KIDS] = clean( kids[1] );
					}
					if(split[j].indexOf(PDFConstants.PAGE_MEDIABOX)>-1)
					{
						var media:Array = split[j].split(PDFConstants.PAGE_MEDIABOX);
						dict[PDFConstants.PAGE_MEDIABOX] = clean( media[1] );
					}
					if(split[j].indexOf(PDFConstants.PAGE_CONTENTS)>-1)
					{
						var content:Array = split[j].split(PDFConstants.PAGE_CONTENTS);
						dict[PDFConstants.PAGE_CONTENTS] = clean( content[1] );
					}
					if(split[j].indexOf(PDFConstants.PAGE_RESOURCES)>-1)
					{
						var resources:Array = split[j].split(PDFConstants.PAGE_RESOURCES);
						dict[PDFConstants.PAGE_RESOURCES] = clean( resources[1] );
					}
				}
			}
			return dict;
		}
		
		public function dispose():void
		{
			
		}
		
		public function clean(s:String):String
		{
			var buff:String = s;
			buff = buff.replace(/\[/g,"");
			buff = buff.replace(/\]/g,"");
			buff = buff.replace(/\</g,"");
			buff = buff.replace(/\>/g,"");
			while(s.charAt(0) == " ")
			{
				s = s.substr(1,s.length);
			}
			return buff;
		}
	}
}