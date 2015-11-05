package com.jankuester.pdfviewer.core.model.resources.maps
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.model.resources.objects.Font;
	import com.jankuester.pdfviewer.core.model.resources.objects.XImage;
	import com.jankuester.pdfviewer.core.model.resources.objects.XObject;
	import com.jankuester.pdfviewer.core.pdfparser.XObjectTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	public class XObjectMap extends COSDictionary
	{
		public function XObjectMap()
		{
			super();
		}
		
		//xobj : /Tr14 14 0 R/Tr19 19 0 R/Tr24 24 0 R/Tr29 29 0 R/Tr4 4 0 R/Tr9 9 0 R
		override public function loadString(source:String):void
		{
			trace("-------------- XOBJECT MAP -----------------");
			if (_dict == null) _dict = new Dictionary();
			var split:Array = source.split("/");
			for (var i:int = 0; i < split.length; i++) 
			{
				var pair:String = split[i];
				var separate:int = pair.indexOf(" ");
				var id:String = pair.substring(0,separate);
					id = id.replace(/\s+/g,"");
				var ref:String= pair.substring(separate+1, pair.length);
				_dict[id] = ref;
				trace("push xobj:"+id+" / "+_dict[id]);
				if (XRef.instance().isReference(ref))
				{
					trace("------------- load xobj: "+id+"="+ref+" ---------------------");
					var xobject:XObject;
					
					var xBytes:ByteArray = XRef.instance().getReferenceBytes(ref);
					xobject = new XObject();
					xobject.load(xBytes,new XObjectTokenizer());
					
					//trace(ByteArrayUtils.readStringFromTo(xBytes,subType, subType+20));
				}
			}
			
		}
		

	}
}