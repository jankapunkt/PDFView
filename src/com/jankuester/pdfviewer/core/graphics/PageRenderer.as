package com.jankuester.pdfviewer.core.graphics
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.content.PageContent;
	import com.jankuester.pdfviewer.core.model.resources.PageResources;
	
	import mx.collections.ArrayList;
	
	import spark.components.Group;

	public class PageRenderer extends Group implements IDisposable
	{
		public function PageRenderer()
		{
		
		}
		
		public function dispose():void
		{
			this.removeAllElements();
			_reader.dispose();
		}
		
		protected var _reader:ContentStreamReader;
		
		
		public function prepare(content:PageContent, resources:PageResources, dimY:Number):void
		{
			_reader = new ContentStreamReader();
			_reader.loadStream(content.stream, resources);
			
			var elemnts:ArrayList = _reader.objects;
			for (var i:int = 0; i < elemnts.length; i++) 
			{
				var g:GraphicsObject = elemnts.getItemAt(i) as GraphicsObject;
					g.y = dimY - g.y;
				this.addElement(g);
			}
			
		}
	}
}