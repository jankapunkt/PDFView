package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;

	/*
	<</Type/Font/Subtype/TrueType/BaseFont/BAAAAA+LiberationSerif-Bold
	/FirstChar 0
	/LastChar 38
	/Widths[777 610 443 500 333 443 556 333 389 277 443 250 666 722 389 556
	666 610 500 556 556 500 500 833 722 556 556 556 443 556 666 277
	500 666 722 666 722 556 722 ]
	/FontDescriptor 39 0 R
	/ToUnicode 40 0 R
	>>
	
	
	34 0 obj
	<</Type/FontDescriptor/FontName/CAAAAA+LiberationSerif
	/Flags 6
	/FontBBox[-543 -303 1278 982]/ItalicAngle 0
	/Ascent 891
	/Descent -216
	/CapHeight 981
	/StemV 80
	/FontFile2 32 0 R
	>>
	<</Type/FontDescriptor/FontName/BAAAAA+LiberationSerif-Bold
	/Flags 6
	/FontBBox[-543 -303 1344 1008]/ItalicAngle 0
	/Ascent 891
	/Descent -216
	/CapHeight 1007
	/StemV 80
	/FontFile2 37 0 R
	>>
	*/
	public class FontTokenizer implements ITokenizer
	{
		
		public function FontTokenizer()
		{
		}
		
		protected var _source:ByteArray;
		
		private var _catchFontName:Boolean;
		
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
			
			if (ByteArrayUtils.readString(_source).indexOf(PDFConstants.CONTAINER_STREAM)>-1)
			{
				var streams:Array = PdfBinaryUtils.findStreamPositions(_source);
				var decoded:ByteArray = PdfBinaryUtils.decodeStream(_source, streams[0], streams[1]);
				trace("DECODED-----------");
				var combined:ByteArray = ByteArrayUtils.replaceFromTo(_source, streams[0],streams[1], decoded, 0, decoded.length);
				dict[PDFConstants.CONTAINER_STREAM] = combined;
				return dict;
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
					//trace(token);
					if (token.search(PDFConstants.REFERENCE_MAPPING) >-1)
					{
						var separate:int = token.indexOf(" ");
						var id:String = token.substring(0,separate);
						id = id.replace(/\s+/g,"");
						var ref:String= token.substring(separate+1, token.length);
						dict[id] = ref;
					}
					
					if(token.indexOf(PDFConstants.FONT_BBOX)>-1)
					{
						token = token.replace(PDFConstants.FONT_BBOX);
						token = token.replace("[","");
						token = token.replace("]","");
						var fontBox:Array = token.split(" ");
						dict[PDFConstants.FONT_BBOX] = fontBox;
						trace("fontBBox: "+fontBox);
					}
					if(token.indexOf(PDFConstants.FONT_FILE2)>-1)
					{
						fref = token.substring(token.indexOf(" "),token.length);
						dict[PDFConstants.FONT_FILE2] = clean(fref);
					}
					if(token.indexOf(PDFConstants.FONT_FONTDESCRIPTOR)>-1)
					{
						fref = token.substring(token.indexOf(" "),token.length);
						dict[PDFConstants.FONT_FONTDESCRIPTOR] = clean(fref);
					}
					if(_catchFontName)
					{
						trace("fontName->"+token);
						_catchFontName=false;
						dict[PDFConstants.FONT_FONTNAME] = token;
					}
					if(token.indexOf(PDFConstants.FONT_FONTNAME)>-1)
					{
						_catchFontName = true;
					}
					if(token.indexOf(PDFConstants.FONT_ITALIC_ANGLE)>-1)
					{
						trace("itAngle->"+token);
					}
					if(token.indexOf(PDFConstants.FONT_TOUNICODE)>-1)
					{
						
						var unicodesplit:Array = token.split(PDFConstants.FONT_TOUNICODE);
						dict[PDFConstants.FONT_TOUNICODE] = clean(unicodesplit[1]);
					}
					if(token.indexOf(PDFConstants.FONT_TRUETYPE)>-1)
					{
						dict[PDFConstants.KEY_SUBTYPE] = PDFConstants.FONT_TRUETYPE;
					}
					if(token.indexOf(PDFConstants.FONT_WEIGHT)>-1)
					{
						trace("fontWeight->"+token);
					}
				}
			}
			return dict;
		}
		
		public function clean(s:String):String
		{
			var buff:String = s;
				buff = buff.replace("/"+PDFConstants.RESOURCE_EXTGSTATE,"");
				buff = buff.replace("/"+PDFConstants.RESOURCE_XOBJECT,"");
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
		
		public function dispose():void
		{
		}
	}
}