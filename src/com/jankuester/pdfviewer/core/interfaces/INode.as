package com.jankuester.pdfviewer.core.interfaces
{
	import mx.collections.ArrayList;

	public interface INode extends IDisposable
	{
		function getChildAt(index:int):INode;
		function getChildCount():int;
		function getParent():INode;
		function getIndex():int;
		function getChildIndex(child:INode):int;
		function getAllowsChildren():Boolean;
		function addChild(child:INode):INode;
		function addChildAt(index:int,child:INode):INode;
		function removeChild(child:INode):INode;
		function removeChildAt(index:int):INode;
		function isLeaf():Boolean;
		function children():ArrayList;
	}
}