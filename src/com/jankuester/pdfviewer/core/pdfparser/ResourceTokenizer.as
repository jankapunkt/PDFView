package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;

	/*
	 <</Font 42 0 R
	/XObject<</Tr14 14 0 R/Tr19 19 0 R/Tr24 24 0 R/Tr29 29 0 R/Tr4 4 0 R/Tr9 9 0 R>>
	/ExtGState<</EGS10 10 0 R/EGS15 15 0 R/EGS20 20 0 R/EGS25 25 0 R/EGS30 30 0 R/EGS5 5 0 R>>
	/ProcSet[/PDF/Text/ImageC/ImageI/ImageB]
	>>
	*/
	public class ResourceTokenizer implements ITokenizer, IDisposable
	{
		protected var _source:ByteArray;
		
		public function ResourceTokenizer()
		{
		}
		
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
					if(split[j].indexOf(PDFConstants.RESOURCE_FONT)>-1)
					{
						var font:Array = split[j].split(PDFConstants.RESOURCE_FONT+" ");
						dict[PDFConstants.RESOURCE_FONT] = clean( font[1] );
					}
					if(split[j].indexOf(PDFConstants.RESOURCE_EXTGSTATE)>-1)
					{
						var extgs:Array = split[j].split(PDFConstants.RESOURCE_EXTGSTATE);
						dict[PDFConstants.RESOURCE_EXTGSTATE] = clean( line );
					}
					if(split[j].indexOf(PDFConstants.RESOURCE_XOBJECT)>-1)
					{
						var xobj:Array = split[j].split(PDFConstants.RESOURCE_XOBJECT);
						dict[PDFConstants.RESOURCE_XOBJECT] = clean( line );
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
			_source.clear();
			_source = null;
		}
	}
}