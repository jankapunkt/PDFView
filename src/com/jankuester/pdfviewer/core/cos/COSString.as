package com.jankuester.pdfviewer.core.cos
{
	/*
	A conforming wr
	iter may split a literal string
	across multiple li
	nes. The R
	EVERSE SOLIDUS (5Ch
	) (backslash 
	character) at the end of a line shall be used to indi
	cate that the string continues on the following line. A 
	conforming reader shall disregard the REVERSE SOLIDUS
	and the end-of
	-line marker following it when 
	reading the string; the resulting string value shall be identi
	cal to that which would be read if the string were not 
	split. 
	*/
	public class COSString extends COSBase
	{
		public static const STRING_START:String="<";
		public static const STRING_END:String  =">";
		
		public static const STRING_LITERAL_NAME:String="/";
		
		protected var isHex:Boolean=false;
		
		public function COSString()
		{
			super();
		}
	}
}