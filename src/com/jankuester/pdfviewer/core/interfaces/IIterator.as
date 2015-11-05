package com.jankuester.pdfviewer.core.interfaces
{
	public interface IIterator
	{
		function hasNext():Boolean;
		function next():Object;
		function reset():void;
	}
}