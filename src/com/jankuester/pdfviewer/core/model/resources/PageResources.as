package com.jankuester.pdfviewer.core.model.resources
{
	import com.jankuester.pdfviewer.core.cos.COSDictionary;
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.core.model.resources.maps.ColorSpaceMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ExtGStateMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.FontMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.PatternMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ProcSetMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.PropertiesMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.ShadingMap;
	import com.jankuester.pdfviewer.core.model.resources.maps.XObjectMap;
	import com.jankuester.pdfviewer.core.pdfparser.FontTokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	import com.jankuester.pdfviewer.core.pdfparser.XRef;
	
	import flash.utils.ByteArray;
	
	/**
	 * <p>Extract from the Adobe PDF specification:</p>
	 * <p>Required; inheritable) A dictionary containing any resources required by the page (see 7.8.3, "Resource Dictionaries").
	 * If the page requires no resources, the value of this entry shall be an empty dictionary. 
	 * Omitting the entryentirely indicates that the resources shall be inherited from an ancestor node in the page tree.</p> 
	 */
	public class PageResources extends COSDictionary
	{
		/** CONSTRUCTOR **/
		public function PageResources()
		{
			super();
		}
		
		protected var _isInherited:Boolean = false;

		public function get isInherited():Boolean
		{
			return _isInherited;
		}

		protected var _extgstate:ExtGStateMap;

		public function get extgstate():ExtGStateMap
		{
			return _extgstate;
		}

		protected var _colorSpace:ColorSpaceMap;

		public function get colorSpace():ColorSpaceMap
		{
			return _colorSpace;
		}

		protected var _pattern:PatternMap;

		public function get pattern():PatternMap
		{
			return _pattern;
		}

		protected var _shading:ShadingMap;

		public function get shading():ShadingMap
		{
			return _shading;
		}

		protected var _xobject:XObjectMap;

		public function get xobject():XObjectMap
		{
			return _xobject;
		}

		protected var _font:FontMap;
		
		public function get font():FontMap
		{
			return _font;
		}
		
		protected var _procSet:ProcSetMap;

		public function get procSet():ProcSetMap
		{
			return _procSet;
		}

		
		protected var _properties:PropertiesMap;

		public function get properties():PropertiesMap
		{
			return _properties;
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
				_xobject = new XObjectMap();
				//if (XRef.instance().isReference(obj))
				//	_xobjext.reference = obj;
				//else
				_xobject.loadString(obj);
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