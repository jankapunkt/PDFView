package com.jankuester.pdfviewer.core.model.pages
{
	import com.jankuester.pdfviewer.core.interfaces.INode;
	
	public interface IPageNode extends INode
	{
		function getType():String;
	}
}