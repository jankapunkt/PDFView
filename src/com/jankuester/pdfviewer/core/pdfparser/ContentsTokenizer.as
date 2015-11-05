package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	public class ContentsTokenizer implements ITokenizer, IDisposable
	{
		public function ContentsTokenizer()
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
			
			var streams:Array = PdfBinaryUtils.findStreamPositions(_source);
			var decoded:ByteArray = PdfBinaryUtils.decodeStream(_source, streams[0], streams[1]);
			trace("DECODED-----------");
			var combined:ByteArray = ByteArrayUtils.replaceFromTo(_source, streams[0],streams[1], decoded, 0, decoded.length);
			dict[PDFConstants.CONTAINER_STREAM] = ByteArrayUtils.readString(combined);
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