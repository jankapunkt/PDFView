 package com.jankuester.pdfviewer.core.model.pages
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.interfaces.INode;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.model.content.PageContent;
	import com.jankuester.pdfviewer.core.model.rectangles.PDFRect;
	import com.jankuester.pdfviewer.core.model.resources.PageResources;
	import com.jankuester.pdfviewer.core.pdfparser.ContentsTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.ResourceTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	
	

	public class PageNode extends COSDictionary implements IPageNode, IDisposable
	{
		protected var _children:ArrayList;
		protected var _allowsChildren:Boolean=true;
		protected var _parent:INode;
		protected var _isLeaf:Boolean=false;

		protected var _type:String;
		
		protected var _resources:PageResources;
		protected var _contents:PageContent;
		
		protected var _pageCount:int=0;

		/**
		 * define the boundaries of the physical medium 
		 * on which the page shall be 
		 * displayed or printed
		**/
		protected var _mediaBox:PDFRect;
		protected var _cropBox:PDFRect;
		protected var _bleedBox:PDFRect;
		protected var _trimBox:PDFRect;
		protected var _artBox:PDFRect;
		
		
		public function PageNode(parent:INode=null)
		{
			super();
			this._parent = parent;
		}
	
		
		public function get resources():PageResources
		{
			return _resources;
		}

		public function loadResources():void
		{
			_resources.load(XRef.instance().getReferenceBytes(_resources.reference), new ResourceTokenizer());	
		}

		public function loadContents():void
		{
			_contents.load(XRef.instance().getReferenceBytes(_contents.reference), new ContentsTokenizer());
		}
		
		public function get mediaBox():PDFRect
		{
			return _mediaBox;
		}

		
		public function get contents():PageContent
		{
			return _contents;
		}

		public function get pageCount():int
		{
			return _pageCount;
		}


		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			trace("------------ PAGE NODE ----------------");
			_children = new ArrayList();
			
			var count:String = _dict[PDFConstants.PAGE_COUNT];
			if (count != null)
			{
				trace("count:"+ _dict[PDFConstants.PAGE_COUNT]);
				_pageCount = int(count);
			}
			
			var mediaBox:String = _dict[PDFConstants.PAGE_MEDIABOX];
			if (mediaBox != null)
			{
				trace("media:"+ _dict[PDFConstants.PAGE_MEDIABOX]);
				var mediaSplit:Array = mediaBox.split(" ");
				_mediaBox = new PDFRect(
					int(mediaSplit[0]),
					int(mediaSplit[1]),
					int(mediaSplit[2]),
					int(mediaSplit[3])
				);
			}
			
			var content:String = _dict[PDFConstants.PAGE_CONTENTS];
			if (content != null)
			{
				trace("content:"+ _dict[PDFConstants.PAGE_CONTENTS]);
				_contents = new PageContent();
				_contents.reference = content;
			}
			
			var resources:String = _dict[PDFConstants.PAGE_RESOURCES];
			if (resources != null)
			{
				trace("resources:"+ _dict[PDFConstants.PAGE_RESOURCES]);
				_resources = new PageResources();
				_resources.reference = resources;
			}

			var children:String = _dict[PDFConstants.PAGE_KIDS];
			if (children != null)
			{
				trace("kids:"+ _dict[PDFConstants.PAGE_KIDS]);
				var childSplit:Array = children.split("R");
				for (var i:int = 0; i < childSplit.length; i++) 
				{
					var childRef:String = childSplit[i]+"R";
					var childPos:int = XRef.instance().getPosition(childRef);
					if (childPos == -1) continue;
					var nodeSource:ByteArray = PdfBinaryUtils.getObjectBytesByReference(XRef.instance().source, childPos);
					var node:PageNode = new PageNode(this);
						node.load(nodeSource, tokenizer);
						node.reference = childRef;
					_children.addItem(node);	
				}
				
			}else{
				_isLeaf = true;
			}
		}
		
		public function children():ArrayList
		{
			if (_children == null)
				_children = new ArrayList();
			return _children;
		}
		
		public function getAllowsChildren():Boolean
		{
			return _allowsChildren;
		}
		
		public function getChildAt(index:int):INode
		{
			if (_children == null || _children.length == 0 || index < 0 || index >= _children.length)return null;
			return _children.getItemAt(index) as INode;
		}
		
		public function getChildCount():int
		{
			if (_children == null)_children = new ArrayList();
			return _children.length;
		}
		
		public function getChildIndex(child:INode):int
		{
			if (_children == null)_children = new ArrayList();
			return _children.getItemIndex(child);
		}
		
		public function getIndex():int
		{
			return _parent.getChildIndex(this);
		}
		
		public function getParent():INode
		{
			return _parent;
		}
		
		public function isLeaf():Boolean
		{
			return _isLeaf;
		}
		
		public function getType():String
		{
			return _type;
		}
		
		public function addChild(child:INode):INode
		{
			if (_children == null)_children = new ArrayList();
			return _children.addItem(child) as INode;
		}
		
		public function addChildAt(index:int, child:INode):INode
		{
			if (_children == null)_children = new ArrayList();
			return _children.addItemAt(child, index) as INode;
		}
		
		public function removeChild(child:INode):INode
		{
			if (_children == null)_children = new ArrayList();
			return _children.removeItem(child) as INode;
		}
		
		public function removeChildAt(index:int):INode
		{
			if (_children == null)_children = new ArrayList();
			return _children.removeItemAt(index) as INode;
		}
		
		override public function dispose():void
		{
			if (_children == null)_children = new ArrayList();
			for (var i:int = 0; i < _children.length; i++) 
			{
				var child:INode = _children.getItemAt(i) as INode;
					child.dispose();
			}
			_children.removeAll();
			super.dispose();
		}
		
		
	}
}