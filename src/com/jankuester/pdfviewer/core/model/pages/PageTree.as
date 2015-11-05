package com.jankuester.pdfviewer.core.model.pages
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.interfaces.INode;
	import com.jankuester.pdfviewer.core.interfaces.ITree;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.PageNodeTokenizer;
	
	import flash.utils.ByteArray;
	
	public class PageTree extends COSDictionary implements ITree
	{
		protected var _type:String;
		
		protected var _root:PageNode;
		
		
		public function PageTree()
		{
			super();
		}
		
		public function get pageCount():int
		{
			return _root.pageCount;
		}

		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			_root = new PageNode();
			_root.load(source, new PageNodeTokenizer());
		}
		
		public function getPage(index:int):INode
		{
			return getChild(_root, index);
		}

		public function getChild(parent:INode, index:int):INode
		{
			return parent.getChildAt(index);
		}
		
		public function getChildCount(parent:INode):int
		{
			return parent.getChildCount();
		}
		
		public function getIndexOfChild(parent:INode, child:INode):int
		{
			return parent.getChildIndex(child);
		}
		
		public function getRoot():INode
		{
			return _root;
		}
		
		public function isLeaf(node:INode):Boolean
		{
			return node.isLeaf();
		}
		
	}
}