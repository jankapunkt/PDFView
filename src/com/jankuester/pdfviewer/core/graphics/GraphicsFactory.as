package com.jankuester.pdfviewer.core.graphics
{
	import com.jankuester.pdfviewer.core.pdfloader.PDFImage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import spark.components.Image;
	import spark.components.Label;
	
	import org.osmf.elements.ImageLoader;

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
		
		
		public static function createImageObject(streamDecoded:ByteArray, width:int,height:int):Image
		{
			var i:PDFImage = new PDFImage();
				i.smooth=true;
				i.width = width;
				i.height = height;
				i.loadBinary(streamDecoded);
			return i;	
		}
		
		public static function createLabel(text:String, fontSize:String="11"):Label
		{
			var l:Label = new Label();
				l.text = text;
				l.setStyle("fontSize",fontSize);
			return l;
		}
	}
}