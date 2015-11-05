package com.jankuester.pdfviewer.core.interfaces
{
	public interface IStack
	{
		function isEmpty():Boolean;
		function peek():Object;
		function pop():Object;
		function push(item:Object):Object;
		function search(item:Object):int;
	}
}