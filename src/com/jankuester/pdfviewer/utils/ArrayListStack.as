package com.jankuester.pdfviewer.utils
{
	import com.jankuester.pdfviewer.core.interfaces.IStack;
	
	import mx.collections.ArrayList;

	public class ArrayListStack implements IStack
	{
		
		public function ArrayListStack()
		{
			_stack = new ArrayList();
		}
		
		protected var _stack:ArrayList;
		
		public function isEmpty():Boolean
		{
			return _stack == null || _stack.length==0; 
		}
		
		public function peek():Object
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return null;
			return _stack.getItemAt(_stack.length-1);
		}
		
		public function pop():Object
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return null;
			return _stack.removeItemAt(_stack.length-1);
		}
		
		public function push(item:Object):Object
		{
			if (_stack == null)_stack = new ArrayList();
			_stack.addItem(item);
			return item;
		}
		
		public function search(item:Object):int
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return -1;
			return _stack.getItemIndex(item);
		}
		
	}
}