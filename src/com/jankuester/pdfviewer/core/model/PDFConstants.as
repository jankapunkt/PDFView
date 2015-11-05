package com.jankuester.pdfviewer.core.model
{
	public class PDFConstants
	{
		public static const SCALAR_INTEGER:String 	= "Integer";
		public static const SCALAR_BOOLEAN:String 	= "Boolean";
		public static const SCALAR_REALNUM:String 	= "Real Number";
		public static const SCALAR_NAME:String 		= "Name";
		public static const SCALAR_STRING:String 	= "String";
		
		//----------------- FOOTER ----------------------//
		
		public static const XREF:String = "xref";
		public static const XREF_STARTXREF:String="startxref";
		
		public static const TRAILER_TRAILER:String = "trailer";
		public static const TRAILER_SIZE:String = "Size";
		public static const TRAILER_ROOT:String = "Root";
		public static const TRAILER_INFO:String = "Info";
		
		
		//-------------------- Structure ---------------------//
		
		public static const STRUCT_COMMENT:String ="%";
		public static const STRUCT_TOKEN:String ="/";
		public static const STRUCT_DELIMITER:String="\n";

		public static const DICTIONARY_OPEN:String="<<";
		public static const DICTIONARY_CLOSE:String=">>";
		
		public static const ARRAY_OPEN:String="[";
		public static const ARRAY_CLOSE:String="]";
		
		public static const OBJECT_OPEN:String="obj";	
		public static const OBJECT_CLOSE:String="endobj";	
		
		
		//DEFINES A PATTERN TO MAP AN OBJECT REFERENCE TO A NAME
		//SUCH AS /F12 31 0 R
		public static const REFERENCE_MAPPING:RegExp = /([A-Z]+[0-9]+ [0-9]+ [0] [R])/g;
		
		//-------------------- TAGS ---------------------------//
		
		
		public static const TAG_MEDIABOX:String ="/MediaBox";
		public static const TAG_FILTER:String = "/Filter";
		public static const TAG_FLATE:String = "/FlateDecode";
		public static const TAG_LENGTH:String ="/Length";
		
		//-------------------- STREAM TAGS ---------------------//
		
		public static const TAG_STREAM_START:String = "stream";
		public static const TAG_STREAM_END:String = "endstream";
		
		public static const DEFLATE:String="flatedecode";
		public static const DCT:String="dctdecode";
		

		//-------------------- Key TYPES ------------------------//

		public static const KEY_TYPE:String=			"Type";					//name
		public static const KEY_SUBTYPE:String=			"Subtype";				//name
		
		public static const KEY_VERSION:String=			"Version";				//name
		
		public static const KEY_EXTENSIONS:String=		"Extensions";			//dict
		public static const KEY_PAGES:String=			"Pages";				//dict
		public static const KEY_PAGE_LABELS:String=		"PageLabels";			//num tree
		public static const KEY_NAMES:String=			"Names";				//dict
		public static const KEY_DESTS:String=			"Dests";				//dict
		public static const KEY_VIEWER_PREFS:String=	"ViewerPreferences";	//dict
		public static const KEY_PAGE_MODE:String=		"PageMode";				//name
		
		
		public static const KEY_OUTLIUNES:String=		"Outlines";			//name
		

		//-------------------- PAGE TYPES ------------------------//

		public static const PAGE_COUNT:String =			"Count";
		public static const PAGE_KIDS:String =			"Kids";
		public static const PAGE_RESOURCES:String=		"Resources";
		
		public static const PAGE_PARENT:String=			"Parent";
		public static const PAGE_MEDIABOX:String=		"MediaBox";
		public static const PAGE_CONTENTS:String=		"Contents";
		public static const PAGE_DEVICERGB:String=		"DeviceRGB";
		
		//-------------------- RESOURCE TYPES ------------------------//
		
		public static const RESOURCE_FONT:String=		"Font";
		public static const RESOURCE_XOBJECT:String=	"XObject";
		public static const RESOURCE_EXTGSTATE:String=	"ExtGState";
		
		
		public static const FONT_TRUETYPE:String = 		"TrueType";				//True type fonts
		public static const FONT_FONTDESCRIPTOR:String=	"FontDescriptor";
		public static const FONT_TOUNICODE:String=		"ToUnicode";
		
		public static const FONT_FONTNAME:String=		"FontName";
		public static const FONT_WEIGHT:String=			"FontWeight";
		public static const FONT_BBOX:String=			"FontBBox";
		public static const FONT_ITALIC_ANGLE:String=	"ItalicAngle";
		
		public static const FONT_FILE2:String=			"FontFile2";
		
		public static const FONT_BEGINBFCHAR:String=	"beginbfchar";
		public static const FONT_ENDBFCHAR:String=		"endbfchar";

		
		//-------------------- FONT TYPES ------------------------//

		//public static const FONT_
		
		public static const CONTAINER_DICTIONARY:String	= "Dictionary";
		public static const CONTAINER_ARRAY:String	 		= "Array";
		
		public static const CONTAINER_STREAM:String	 	= "stream";
		
		
	}
}