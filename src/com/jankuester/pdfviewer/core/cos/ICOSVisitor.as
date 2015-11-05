package com.jankuester.pdfviewer.core.cos
{
	public interface ICOSVisitor
	{

		function visitFromArray( COSArray obj ):Object;
		

		function visitFromBoolean( COSBoolean obj ):Object;
		
		function visitFromDictionary( COSDictionary obj ):Object;
		
		function visitFromDocument( COSDocument obj ):Object;
		
		function visitFromFloat( COSFloat obj ):Object;
		
		function visitFromInt( COSInteger obj ):Object;
		
		function visitFromName( COSName obj ):Object;
		
		function visitFromNull( COSNull obj ):Object;
		
		function visitFromStream( COSStream obj ):Object;
		
		function visitFromString( COSString obj ):Object;
	}
}