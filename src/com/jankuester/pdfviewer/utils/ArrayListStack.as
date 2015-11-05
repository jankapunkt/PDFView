package com.jankuester.pdfviewer.utils
{
	import com.jankuester.pdfviewer.core.interfaces.IStack;
	
	import mx.collections.ArrayList;

	/**
	 * AS3 implementation of a Java based Stack interface.
	 * 
	 **/
	public class ArrayListStack implements IStack
	{
		/** underlying arraylist **/
		protected var _stack:ArrayList;
		
		/** CONSTRUCTOR **/
		public function ArrayListStack()
		{
			_stack = new ArrayList();
		}
		
		/** checks if stack is empty **/
		public function isEmpty():Boolean
		{
			return _stack == null || _stack.length==0; 
		}
		
		/** returns the topmost object without popping **/
		public function peek():Object
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return null;
			return _stack.getItemAt(_stack.length-1);
		}
		
		/** returns the topmost objects and removes it from the stack **/
		public function pop():Object
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return null;
			return _stack.removeItemAt(_stack.length-1);
		}
		
		/** adds an object to the stack **/
		public function push(item:Object):Object
		{
			if (_stack == null)_stack = new ArrayList();
			_stack.addItem(item);
			return item;
		}
		
		/** returns the index of an object in the stack. I fnot found returns -1 **/
		public function search(item:Object):int
		{
			if (_stack == null)_stack = new ArrayList();
			if (_stack.length == 0)return -1;
			return _stack.getItemIndex(item);
		}
		
	}
}