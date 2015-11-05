package com.jankuester.pdfviewer.core.streamdecoder
{
	import com.jankuester.pdfviewer.core.streamloader.Streamposition;
	
	import flash.utils.ByteArray;

	public class DecodedCarrier
	{
		public function DecodedCarrier(byteStream:ByteArray, pos:Streamposition)
		{
			stream = byteStream;		
			positions = pos;
		}
		
		public var stream:ByteArray;
		
		public var positions:Streamposition;
	}
}