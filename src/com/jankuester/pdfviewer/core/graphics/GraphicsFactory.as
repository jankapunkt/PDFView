package com.jankuester.pdfviewer.core.graphics
{
	/**
	 * Light-Factory which creates graphics related objects, when interpreting the content stream.
	 */
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