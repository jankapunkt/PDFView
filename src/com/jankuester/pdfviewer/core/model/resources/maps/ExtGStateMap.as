package com.jankuester.pdfviewer.core.model.resources.maps
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	
	import flash.utils.Dictionary;
	
	public class ExtGStateMap extends COSDictionary
	{
		public function ExtGStateMap()
		{
			super();
		}
		
		///EGS10 10 0 R/EGS15 15 0 R/EGS20 20 0 R/EGS25 25 0 R/EGS30 30 0 R/EGS5 5 0 R
		override public function loadString(source:String):void
		{
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
				trace("push extg:"+id+" / "+ref);
			}
			
		}
	}
}