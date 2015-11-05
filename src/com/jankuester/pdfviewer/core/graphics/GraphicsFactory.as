package com.jankuester.pdfviewer.core.graphics
{
	import flash.utils.ByteArray;
	
	import spark.components.Image;

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
		
		
		public static function createImageObject(streamDecoded:ByteArray):Image
		{
			var i:Image = new Image();
				i.source = streamDecoded;
			return i;	
		}
	}
}