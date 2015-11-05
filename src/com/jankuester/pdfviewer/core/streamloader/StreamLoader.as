package com.jankuester.pdfviewer.core.streamloader
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;

	public class StreamLoader implements IDisposable
	{
		protected var _streams:Array;
		protected var _size:int;
		protected var _index:int;
		
		public function StreamLoader()
		{
			_streams = new Array();
			_index   = 0;
			_size    = 0;
		}
		
		public function flush():void
		{
			_streams = null;
			_index = 0;
			_size = 0;
		}
		
		public function dispose():void
		{
			flush();
		}
		
		public function loadStreams(pdfBinary:ByteArray):Boolean
		{
			try
			{
				var streamsTmp:Array = PdfBinaryUtils.findStreamPositions(pdfBinary);
				
				if (streamsTmp.length % 2 != 0 ) return false;
				_streams = new Array();
				for (var i:int = 0; i < streamsTmp.length; i+=2) 
				{
					_streams.push( new Streamposition(streamsTmp[i], streamsTmp[i+1]));
				}
				
				
				_size = _streams.length;
			} 
			catch(error:Error) 
			{
				return false;
				trace(error.message);
			}
			return true;
		}
		
		public function get size():int
		{
			return _size;
		}
		
		public function getStreamAt( index:int):Streamposition
		{
			if (_streams == null || index < 0 || index >= _streams.length)return null;
			return _streams[index];
		}
		
		public function streamposIterator():StreamposIterator
		{
			return new StreamposIterator(_streams);
		}
	}
}