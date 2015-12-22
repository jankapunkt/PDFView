package com.jankuester.pdfviewer.core.pdfloader
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import spark.components.Image;
	
	/**
	 * Extends image class by a loader which internally loads binary data and sets as image source onComplete.
	 */
	public class PDFImage extends Image
	{
		protected var _loader:Loader;
		
		protected var _mat:Matrix;
		
		protected var _type:String;

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		
		public function PDFImage()
		{
			super();
		}
		
		public function loadBinary(source:ByteArray, matrix:Matrix=null):void
		{
			if(_type == PDFConstants.DCT)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBinaryLoadCmplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loader.loadBytes(source);
				_mat = matrix;
			}
			else //type is deflated png data
			{
				trace("bitmap source: " + source.length);
				var bd:BitmapData = new BitmapData(width,height,true,0xFFFF0000);
					bd.setPixels(new Rectangle(0,0,width,height),source);
				this.source = bd;
			}
			
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			trace(event.text);
			_loader.unload();
			_loader = null;
			
			var bm:BitmapData =  new BitmapData(width,height, false, 0xFF000000);
			source = bm;
		}
		
		protected function onBinaryLoadCmplete(event:Event):void
		{
			trace("LOAD COMPLETE");
			var content:* = _loader.content;
			this.source = _loader;
			
			if(_mat==null)_mat = new Matrix();

			var bm:BitmapData =  new BitmapData(content.width,content.height, false, 0x00000000);
				bm.draw(content, new Matrix(), null , null, null, true);
			source = bm;
		}
	}
}