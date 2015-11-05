package com.jankuester.pdfviewer.core.streamloader
{
	import com.jankuester.pdfviewer.core.interfaces.IIterator;

	public class StreamposIterator implements IIterator
	{
		protected var _index:int;
		protected var _positions:Array;
		
		public function StreamposIterator(source:Array)
		{
			if (source == null)source=new Array();
			_positions = source;
			_index = 0;
			for (var i:int = 0; i < source.length; i++) 
			{
				trace(source[i].start);	
			}
			
		}
		
		public function hasNext():Boolean
		{
			return _positions != null && _index >= 0 && _index < _positions.length;
		}
		
		public function next():Object
		{
			trace("index: "+_index);
			var obj:Object = _positions[_index];
			_index++;
			return obj;
		}
		
		public function reset():void
		{
			_index = 0;
		}
		
	}
}