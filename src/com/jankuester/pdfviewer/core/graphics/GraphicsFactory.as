package com.jankuester.pdfviewer.core.graphics
{
	public class GraphicsFactory
	{
		public static function createGraphicsState():GraphicsState
		{
			var g:GraphicsState = new GraphicsState();
			return g;
		}
		
		public static function createGraphicsObject():GraphicsObject
		{
			var g:GraphicsObject = new GraphicsObject();
			return g;
		}
	}
}