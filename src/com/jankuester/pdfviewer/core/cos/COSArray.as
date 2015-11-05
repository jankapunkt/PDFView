package com.jankuester.pdfviewer.core.cos
{
	/*
	An 
	ar
	ray object
	is a one-dimensional collection of objects arranged sequentially. Unlike arrays in many other 
	computer languages, PDF arrays may be heterogeneous; 
	that is, an array’s elements may be any combination 
	of numbers, strings, dictionaries, or any other objects, including other arrays. An array may have zero 
	elements.
	An array shall be written as a sequence of object
	s enclosed 
	in SQUARE BRACKETS (using LEFT SQUARE 
	BRACKET (5Bh) and RIGHT 
	SQUARE BRACKET (5Dh)).
	EXAMPLE           [
	549
	3.14
	false
	(
	Ralph
	)
	/SomeName
	]
	PDF directly supports only one-dimensional arrays. Ar
	rays of higher dimension can be constructed by using 
	arrays as elements of arrays, nested to any depth. 
	*/
	public class COSArray extends COSBase
	{
		
		public static const ARRAY_OPEN:String="[";
		public static const ARRAY_CLOSE:String="]";
		
		public static const ARRAY_DELIMITER:String=" ";
		
		public function COSArray()
		{
			super();
		}
	}
}