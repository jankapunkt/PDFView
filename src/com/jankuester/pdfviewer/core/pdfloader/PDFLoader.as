package com.jankuester.pdfviewer.core.pdfloader
{
	import com.jankuester.pdfviewer.core.model.Catalog;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.model.Trailer;
	import com.jankuester.pdfviewer.core.model.pages.PageNode;
	import com.jankuester.pdfviewer.core.model.pages.PageTree;
	import com.jankuester.pdfviewer.core.pdfparser.CatalogTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.TrailerTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.FileLoader;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class PDFLoader extends EventDispatcher
	{
		public static const ERROR:String ="error";
		
		public static const LOAD_COMPLETE:String ="loadComplete";
		
		
		protected var _source:ByteArray;
		
		protected var _uncompressed:ByteArray;
		
		protected var _path:String;
		
		protected var _pages:int=0;
		
		
		
		public var uncompress:Boolean=true;
		
		public function PDFLoader(target:IEventDispatcher=null)
		{
			super(target);
		}

		
		public function get pages():int
		{
			return _pageTree.pageCount;
		}
		
		public function getPageAt(index:int):PageNode
		{
			return _pageTree.getPage(index) as PageNode;
		}

		public function prepare(path:String):Boolean
		{
			_path = path;
			return true;				
		}
		
		public function loadFile():Boolean
		{
			var fl:FileLoader = new FileLoader();
				fl.addEventListener(FileLoader.LOAD_SUCCESS, onLoaderSuccess);
				fl.load(_path);
			return true;
		}
		

		protected function onLoaderSuccess(event:Event):void
		{
			_source = FileLoader(event.target).bytes as ByteArray;
			parsePdf(uncompress);
		}
		
		
		public function parsePdf(uncompressStreams:Boolean=true):void
		{
			loadXREF();
			loadTrailer();
			loadCatalog();
			createPageTree();
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
	
		
		protected function loadXREF():void
		{
			trace("---------------- XREF ---------------");
			//GET XREF
			var xpos:int = getXREFposition(_source);
			
			var end:int  = ByteArrayUtils.lastIndexOf(_source, PDFConstants.TRAILER_TRAILER)-1;
			
			XRef.instance().load(_source, xpos, end);
			XRef.instance().parse();
			
			var positions:Vector.<uint> = XRef.instance().references;
			for (var i:int = 0; i < positions.length; i++) 
			{
				trace(PdfBinaryUtils.readLine(_source, positions[i]));
			}
			
		}
		
		protected function getXREFposition(ba:ByteArray):int
		{
			if (ba==null)return -1;
			var xrefstart:int =  ByteArrayUtils.lastIndexOf(ba, PDFConstants.XREF_STARTXREF)+PDFConstants.XREF_STARTXREF.length+1;
			//trace(xrefstart);
			ba.position = xrefstart;
			var xrefpos:String ="";
			
			while(ba.bytesAvailable)
			{
				var buff:String = ba.readUTFBytes(1);
				
				if (buff == PDFConstants.STRUCT_DELIMITER)break;
				xrefpos+=buff;
			}
			return int(xrefpos)+PDFConstants.XREF.length+1;
		}
		

		protected var _trailer:Trailer;
		protected function loadTrailer():void
		{
			trace("---------------- TRAILER ---------------");
			var trailerpos:int =  ByteArrayUtils.lastIndexOf(_source, PDFConstants.TRAILER_TRAILER)+PDFConstants.TRAILER_TRAILER.length+1;
			_source.position = trailerpos;
			var trailerendpos:int=_source.length;
			var trailerendbuffer:String="";
			while(_source.bytesAvailable)
			{
				var tmp:String =_source.readUTFBytes(1);
				if (tmp == PDFConstants.STRUCT_DELIMITER)
					trailerendbuffer="";
				else
					trailerendbuffer+=tmp;
				if (trailerendbuffer == PDFConstants.DICTIONARY_CLOSE)
					break;
			}
			trailerendpos = _source.position;
			trace("BYTE-STREAM");
			var b:ByteArray = new ByteArray();
				b.writeBytes(_source,trailerpos, trailerendpos-trailerpos);
			trace(ByteArrayUtils.readString(b));
			_trailer = new Trailer();
			_trailer.load(b, new TrailerTokenizer());
			trace(_trailer.root+ " " + XRef.instance().isReference(_trailer.root));
			trace(_trailer.size+ " " + XRef.instance().isReference(_trailer.size));
			trace(_trailer.info+ " " + XRef.instance().isReference(_trailer.info));
		}

		protected var _catalog:Catalog;
		protected function loadCatalog():void
		{
			trace("---------------- CATALOG ---------------");
			var catalogPos:int = XRef.instance().getPosition(_trailer.root);
			var catalogSource:ByteArray = PdfBinaryUtils.getObjectBytesByReference(_source, catalogPos);
			trace(ByteArrayUtils.readString(catalogSource));
			_catalog = new Catalog();
			_catalog.load(catalogSource, new CatalogTokenizer());
			
		}
		
		protected var _pageTree:PageTree;
		protected function createPageTree():void
		{
			trace("---------------- PAGETREE ---------------");
			var treePos:int = XRef.instance().getPosition(_catalog.pages);
			if (treePos == -1)throw new Error(" no tree pos found");
			trace("treePos:"+treePos);
			var treeSource:ByteArray = PdfBinaryUtils.getObjectBytesByReference(_source, treePos);
			_pageTree = new PageTree();
			_pageTree.load(treeSource, null);
		}
		
	}
}