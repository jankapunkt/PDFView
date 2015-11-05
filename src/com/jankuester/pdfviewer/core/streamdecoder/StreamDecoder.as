package com.jankuester.pdfviewer.core.streamdecoder
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.streamloader.StreamposIterator;
	import com.jankuester.pdfviewer.core.streamloader.Streamposition;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	
	public class StreamDecoder extends EventDispatcher implements IDisposable
	{
		
		public static const DECODED:String="decoded";
		
		
		protected static const DECODING_STEP_DONE:String="stepDone";
		
		protected var _decoded:ByteArray;
		
		protected var _index:int;
		
		
		
		public function StreamDecoder()
		{
			
		}
		
		
		public function get decoded():ByteArray
		{
			return _decoded;
		}
		
		public function decodedStreams():int
		{
			return _queue.length;
		}
		
		protected var _queue:ArrayList;
	
		
		public function decode(source:ByteArray, iterator:StreamposIterator):void
		{
			_decoded = source;
			_queue = new ArrayList();
			while(iterator.hasNext())
			{
				var pos:Streamposition = iterator.next() as Streamposition;
				trace("position: "+pos.start+" "+pos.end);
				var b:ByteArray =  PdfBinaryUtils.decodeStream(source, pos.start, pos.end);
				if (b != null)
				{
					var carrier:DecodedCarrier = new DecodedCarrier(b, pos);
					_queue.addItem(carrier);	
				}
			}
			addEventListener(DECODING_STEP_DONE, onNext);
			dispatchEvent(new Event(DECODING_STEP_DONE));
		}
		
		protected function onNext(event:Event):void
		{
			if (_queue == null || _queue.length == 0 || _index >= _queue.length)
				dispatchEvent(new Event(DECODED));
			else
				insert();
		}
		
		private function insert():void
		{
			trace("insert: "+_index+" "+_queue.length);
			var carrier:DecodedCarrier = _queue.getItemAt(_index) as DecodedCarrier;
			var pos:Streamposition = carrier.positions;
			var dec:ByteArray = carrier.stream;
			_index++;
			var insert:ByteArray = ByteArrayUtils.replaceFromTo(_decoded, pos.start, pos.end, dec, 0, dec.length);
			_decoded = insert;
			dispatchEvent(new Event(DECODING_STEP_DONE));
		}
		
		
		public function dispose():void
		{
		}
	}
}