package com.jankuester.pdfviewer.core.model.rectangles
{
	public class PDFRect
	{
		public function PDFRect(x:int,y:int,w:int,h:int)
		{
			_x = x;
			_y = y;
			_w = w;
			_h = h;
		}
		
		protected var _x:int=0;
		protected var _y:int=0;
		protected var _w:int=0;
		protected var _h:int=0;
		
		public function get x():int
		{
			return _x;
		}
		
		
		public function get y():int
		{
			return _y;
		}
		
		
		public function get w():int
		{
			return _w;
		}
		
		
		public function get h():int
		{
			return _h;
		}
		
	}
}