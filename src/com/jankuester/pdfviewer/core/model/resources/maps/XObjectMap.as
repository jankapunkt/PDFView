package com.jankuester.pdfviewer.core.model.resources.maps
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.resources.objects.XObject;
	import com.jankuester.pdfviewer.core.pdfparser.XObjectTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class XObjectMap extends COSDictionary
	{
		public function XObjectMap()
		{
			super();
		}
		
		public function getXObject(name:String):XObject
		{
			return _dict[name];
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
				trace(i+" push xobj:"+id+" / "+_dict[id]);
				if (XRef.instance().isReference(ref))
				{
					trace(i+" => load xobj: "+id+"="+ref);
					var xobject:XObject;
					
					var xBytes:ByteArray = XRef.instance().getReferenceBytes(ref);
					xobject = new XObject();
					xobject.reference = ref;
					xobject.load(xBytes,new XObjectTokenizer());
					_dict[id]=xobject;
					//trace(ByteArrayUtils.readStringFromTo(xBytes,subType, subType+20));
				}
			}
			
		}
		

	}
}