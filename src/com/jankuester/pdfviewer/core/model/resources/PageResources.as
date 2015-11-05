package com.jankuester.pdfviewer.core.model.resources
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.model.resources.maps.ColorSpaceMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ExtGStateMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.FontMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.PattermMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ProcSetMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.PropertiesMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ShadingMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.XObjectMap;
	import com.jankuester.pdfviewer.core.pdfparser.FontTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	
	/**
	 * Required; inheritable)
 A dictio
nary containing any resources 
required by the page (see 
7.8.3, "Resource Dictionaries"
). If the 
page requires no resources, the value of this entry shall be an 
e
mpty dictionary. Omitting the entry
 entirely indicates that the 
resources shall be inherited from an ancestor node in the page tree. 
	 */
	public class PageResources extends COSDictionary
	{
		protected var _isInherited:Boolean = false;
		protected var _extgstate:ExtGStateMap;
		protected var _colorSpace:ColorSpaceMap;
		protected var _pattern:PattermMap;
		protected var _shading:ShadingMap;
		protected var _xobjext:XObjectMap;
		protected var _font:FontMap;

		public function get font():FontMap
		{
			return _font;
		}

		protected var _procSet:ProcSetMap;
		protected var _properties:PropertiesMap;
		
		public function PageResources()
		{
			super();
		}
		
		override public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			trace("----------------- Resources -------------------");
			tokenizer.load(source);
			_dict = tokenizer.getTokensAsDictionary();
			tokenizer.dispose();
			
			var obj:String = _dict[PDFConstants.RESOURCE_XOBJECT];
			if (obj != null)
			{
				trace("xobj : "+_dict[PDFConstants.RESOURCE_XOBJECT]);
				_xobjext = new XObjectMap();
				//if (XRef.instance().isReference(obj))
				//	_xobjext.reference = obj;
				//else
					_xobjext.loadString(obj);
			}
			
			var font:String = _dict[PDFConstants.RESOURCE_FONT];
			if (font != null)
			{
				trace("fonts: "+_dict[PDFConstants.RESOURCE_FONT]);
				_font = new FontMap();
				if (XRef.instance().isReference(font))
				{
					_font.reference = font;
					_font.load(XRef.instance().getReferenceBytes(font), new FontTokenizer());
				}else{
					_font.loadString(font);	
				}
			}
			
			var ext:String = _dict[PDFConstants.RESOURCE_EXTGSTATE];
			if (ext != null)
			{
				trace("ext  : "+_dict[PDFConstants.RESOURCE_EXTGSTATE]);
				_extgstate = new ExtGStateMap();
				_extgstate.loadString(ext);
			}
			
		}
	}
}