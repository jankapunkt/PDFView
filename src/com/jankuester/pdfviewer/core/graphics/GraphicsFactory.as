package com.jankuester.pdfviewer.core.graphics
{
	import com.jankuester.pdfviewer.core.pdfloader.PDFImage;
	
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import spark.components.Image;
	import spark.components.Label;

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
		
		
		public static function createImageObject(streamDecoded:ByteArray,type:String, width:int=0,height:int=0, transformMatrix:Matrix=null):Image
		{
			var i:PDFImage = new PDFImage();
				i.type = type;
				i.smooth=true;
				i.width = width;
				i.height = height;
				i.loadBinary(streamDecoded, transformMatrix);
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