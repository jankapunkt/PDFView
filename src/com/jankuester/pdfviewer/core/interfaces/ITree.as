package com.jankuester.pdfviewer.core.interfaces
{
	public interface ITree
	{
		function getRoot():INode;
		function getChild(parent:INode, index:int):INode;
		function getChildCount(parent:INode):int;
		function isLeaf(node:INode):Boolean;
		function getIndexOfChild(parent:INode,child:INode):int;
	}
}