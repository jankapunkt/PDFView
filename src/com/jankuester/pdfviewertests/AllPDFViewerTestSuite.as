package com.jankuester.pdfviewertests
{
	import com.jankuester.pdfviewertests.utils.ByteArrayUtilsTest;
	import com.jankuester.pdfviewertests.utils.PDFBinaryUtilsTest;
	
	

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AllPDFViewerTestSuite
	{
		public var pdfBinary:PDFBinaryUtilsTest;
		public var byteArrayUtil:ByteArrayUtilsTest;
		
	}
}