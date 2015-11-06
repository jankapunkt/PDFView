package com.jankuester.pdfviewer.core.graphics
{
	import mx.graphics.SolidColorStroke;
	
	import spark.components.Group;
	import spark.primitives.Rect;
	
	public class GraphicsObject extends Group
	{
		/** current object's graphic state **/
		public var g:GraphicsState;
		
		/** bounding box for debug purposes **/
		protected var _r:Rect;
		
		/** CONSTRUCTOR **/
		public function GraphicsObject()
		{
			super();
		
			_r = new Rect();
			_r.percentHeight = 100;
			_r.percentWidth  = 100;
			_r.stroke = new SolidColorStroke(0xFF0000,2);
			_r.visible = false;
			addElement(_r);
			
		}
		
		/** DEFINES wether the bounding box is rendered or not **/
		public function set debug(value:Boolean):void
		{
			_r.visible = value;
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}