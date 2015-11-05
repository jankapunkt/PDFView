package com.jankuester.pdfviewer.core.pdfparser
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class XRef implements IDisposable
	{
		protected var stream:ByteArray;
		
		protected var _references:Vector.<uint>;
		
		protected var _lookup:Dictionary;
		
		protected var count:int=0;
		
		protected var _source:ByteArray;
		
		public function XRef()
		{

			
		}
		
		protected static var _xref:XRef;
		
		public function get source():ByteArray
		{
			return _source;
		}

		public static function  instance():XRef
		{
			if (_xref == null)
				_xref = new XRef();
			return _xref;
		}
		
		public function isReference(token:String):Boolean
		{
			var split:Array = token.split(" ");
			for (var i:int = 0; i < split.length; i++) 
			{
				if (split[i] == "R")return true;	
			}
			return false;
		}
		
		public function hasReference(token:String):Boolean
		{
			var split:Array = token.split(" ");
			for (var i:int = 0; i < split.length; i++) 
			{
				if (split[i] == "R")return true;	
			}
			return false;
		}
		
		public function getReferenceBytes(reference:String):ByteArray
		{
			if (reference.length==0)
				return null;
			var resourcePos:int = getPosition(reference);
			if (resourcePos == -1)
				return null;
			return PdfBinaryUtils.getObjectBytesByReference(source, resourcePos);
		}
		
		public function load(source:ByteArray, startPos:int, endPos:int):void
		{
			_source=source;
			stream = new ByteArray();
			stream.writeBytes(source,startPos,endPos-startPos);
		}
		
		public function get references():Vector.<uint>
		{
			return _references;
		}

		public function parse():void
		{
			if(stream==null)return;
			_lookup = new Dictionary();
			var lines:Vector.<String> = PdfBinaryUtils.getLines(stream);
			var firstSplit:Array = lines[0].split(" ");
			this.count = int(firstSplit[1]);
			_references = new Vector.<uint>(lines.length-1);
			for (var i:int = 0; i < lines.length; i++) 
			{
				var split:Array = lines[i].split(" ");
				_references[i] = uint(split[0]);
				var key:String = PdfBinaryUtils.readLine(_source,  _references[i]);
				_lookup[key] = uint(split[0]);
			}
		}
		
		public function getPosition(pattern:String):uint
		{
			trace(pattern);
			while(pattern.charAt(0)==" ")
			{
				pattern = pattern.substr(1, pattern.length);
			}
			var split:Array = pattern.split(" ");
			var key:String = split[0]+" "+split[1]+" obj";
			trace("[XREF]: get object position: key="+key +" pos="+_lookup[key]);
			return _lookup[key] || -1;
		}
		
		public function dispose():void
		{
			
		}
		
	}
}