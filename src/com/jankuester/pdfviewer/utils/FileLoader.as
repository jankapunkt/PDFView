package com.jankuester.pdfviewer.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class FileLoader extends EventDispatcher
	{
		public static const LOAD_SUCCESS:String="loadSuccess";
		public static const LOAD_ERROR:String="loadError";
		
		
		protected var _loader:URLLoader;
		protected var _request:URLRequest;
		
		
		
		public function FileLoader()
		{
			super();
		} 
		
		
		protected var _bytes:ByteArray;
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}

		public function load(path:String):void
		{
			_request = new URLRequest( path );
			_loader  = new URLLoader( _request );
			
			_loader.addEventListener(Event.COMPLETE, onURLLoaderComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		
		
		protected function onURLLoaderComplete(event:Event):void
		{
			try
			{
				_bytes = event.target.data;
			}catch(e:Error){
				dispatchEvent(new Event(LOAD_ERROR));
			}finally{
				clean();
			}
			dispatchEvent(new Event(LOAD_SUCCESS));
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(LOAD_ERROR));
			clean();
		}
		
		protected function clean():void
		{
			_loader.removeEventListener(Event.COMPLETE, onURLLoaderComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_request = null;
			_loader = null;
		}
		
	}
}