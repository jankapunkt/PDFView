package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	public class XObjectTokenizer implements ITokenizer
	{
		public function XObjectTokenizer(){}
		
		protected var _source:ByteArray;
		
		protected var _subType:String;
		
		
		protected var _usesStreams:Boolean;
		
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
			var xString:String = ByteArrayUtils.readString(_source);
			if (xString.indexOf(PDFConstants.KEY_SUBTYPE) >-1)
			{
				if (xString.indexOf("Image")>-1)
				{
					trace("subtype=>image");
					_subType = "Image";
					dict[PDFConstants.KEY_SUBTYPE] = _subType;
				}
			}
			

			
			
			if (xString.indexOf(PDFConstants.CONTAINER_STREAM)>-1)
			{
				trace("DECODE::::");
				var streams:Array = PdfBinaryUtils.findStreamPositions(_source);
				var decoded:ByteArray = PdfBinaryUtils.decodeStream(_source, streams[0], streams[1]);
				trace("DECODED-----------"+decoded.length);
				var combined:ByteArray = ByteArrayUtils.replaceFromTo(_source, streams[0],streams[1], decoded, 0, decoded.length);
				dict[PDFConstants.CONTAINER_STREAM] = decoded;
				var header:ByteArray = new ByteArray();
					header.writeBytes(_source,0,streams[0]);
				_source = header;
			}
			
			
			
			var lines:Vector.<String> = PdfBinaryUtils.getLines(_source);
			for (var i:int = 0; i < lines.length; i++) 
			{
				var line:String = lines[i];
				var split:Array = lines[i].split("/");
				for (var j:int = 0; j < split.length; j++) 
				{
					var fref:String;
					var token:String = split[j];
					var tSplit:Array;
					if (token.indexOf("Width") >-1)
					{
						tSplit = token.split(" ");		
						dict["width"] = tSplit[1];
					}
					if (token.indexOf("Height") >-1)
					{
						tSplit = token.split(" ");
						dict["height"] = tSplit[1];
						trace("height: "+tSplit[1]);
					}
				}
			}
			return dict;
		}
		
		public function clean(s:String):String
		{
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}