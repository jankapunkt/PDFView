package com.jankuester.pdfviewer.core.graphics
{
	import spark.components.Group;
	import spark.components.Label;
	
	public class GraphicsObject extends Group
	{
		public var g:GraphicsState;
		
		public var l:Label;
		
		public function GraphicsObject()
		{
			super();
			l = new Label();
			addElement(l);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}