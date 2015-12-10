package com.jankuester.pdfviewer.core.model.resources.maps
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.resources.objects.Font;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	
	public class FontMap extends COSDictionary
	{
		public function FontMap()
		{
			super();
		}
		
		
		public function getFont(name:String):Font
		{
			return _dict[name];
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("------------------------- FontMap ---------------------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			for (var font:String in _dict)
			{
				var fontRef:String = _dict[font];
				if (XRef.instance().isReference(fontRef))
				{
					var f:Font = new Font();
						f.reference = font;
						f.name = font;
						f.load(XRef.instance().getReferenceBytes(fontRef),tokenizer);
					_dict[font] = f;
				}
			}
		}
	}
}