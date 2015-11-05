package com.jankuester.pdfviewer.core.graphics
{
	import com.jankuester.pdfviewer.utils.ArrayListStack;
	
	public class GraphicsStateStack extends ArrayListStack
	{
		protected var _currentState:GraphicsState;
		
		public function GraphicsStateStack()
		{
			super();
		}
	}
}