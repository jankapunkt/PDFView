package com.jankuester.pdfviewertests.utils
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	
	public class PDFBinaryUtilsTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testFindStreamPositions():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("stream");
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("endstream");
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("stream");
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("endstream");
			
			var streams:Array = PdfBinaryUtils.findStreamPositions(ba);
			Assert.assertNotNull(streams);
			Assert.assertEquals(streams.length,4);
			Assert.assertEquals("ABCDE",ByteArrayUtils.readStringFromTo(ba,streams[0],streams[1],true));
			Assert.assertEquals(12, streams[0] );
			Assert.assertEquals(streams[1], 17);
			Assert.assertEquals("A",ByteArrayUtils.readString(ba,streams[0],1,true));

			Assert.assertEquals(streams[2], 39);
			Assert.assertEquals(streams[3], 44);
			Assert.assertEquals("ABCDE",ByteArrayUtils.readStringFromTo(ba,streams[2],streams[3],true));
		}

		
		[Test]
		public function testPurgeStreamChars():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("stream");
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("endstream");

			var streams:Array = PdfBinaryUtils.findStreamPositions(ba);
			var start:int = PdfBinaryUtils.purgeStreamChars(ba, streams[0]);
			var end:int   = PdfBinaryUtils.purgeEndstreamChars(ba, streams[1]);
			Assert.assertEquals(0,start);
			Assert.assertEquals(0,end);

			ba = new ByteArray();
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("stream\n");
			ba.writeUTFBytes("ABCDE\n");
			ba.writeUTFBytes("endstream\n");
			
			
			streams = PdfBinaryUtils.findStreamPositions(ba);
			start   = PdfBinaryUtils.purgeStreamChars(ba, streams[0]-2);
			end     = PdfBinaryUtils.purgeEndstreamChars(ba, streams[1]+3);
			Assert.assertEquals(2,start);
			Assert.assertEquals(3,end);
			
			start   = PdfBinaryUtils.purgeStreamChars(ba, streams[0]-7);
			end     = PdfBinaryUtils.purgeEndstreamChars(ba, streams[1]+10);
			Assert.assertEquals(7,start);
			Assert.assertEquals(10,end);
			
			
		}
		
		[Test]
		public function getStreamDefTest():void
		{
			var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes("ABCDEFG");
			var type:String = PdfBinaryUtils.getStreamDef(ba, ba.length);
			assertEquals("none",type);
			
				ba.writeUTFBytes(PDFConstants.DEFLATE);
				ba.writeUTFBytes("ABCDEFG");
				ba.writeUTFBytes("ABCDEFG");
			type = PdfBinaryUtils.getStreamDef(ba, ba.length);
			assertEquals(PDFConstants.DEFLATE, type);
			
				ba.writeUTFBytes(PDFConstants.DCT);
				ba.writeUTFBytes("ABCDEFG");
				ba.writeUTFBytes("ABCDEFG");
				
			type = PdfBinaryUtils.getStreamDef(ba, ba.length);
			assertEquals(PDFConstants.DCT, type);
						
		}
		
		[Test]
		public function testReadStream():void
		{

			var pattern:String="helloworld";
			
			var origin:ByteArray = new ByteArray();
				origin.writeUTFBytes("ABCDEF");
				origin.writeUTFBytes(PDFConstants.DEFLATE);
				origin.writeUTFBytes("stream\n");
			
			var toCompress:ByteArray = new ByteArray();
				toCompress.writeUTFBytes(pattern);
				toCompress.compress();

			//trace("to compress: "+toCompress.length);
			//trace("origin before write: "+origin.length);
			origin.writeBytes(toCompress, 0,18);
			
			//trace("origin after write: "+origin.length);

			origin.writeUTFBytes("\nendstream");
			//trace("origin after 2. write: "+origin.length);
			
			var uncompressed:ByteArray = PdfBinaryUtils.decodeStream(toCompress,0,toCompress.length);
			Assert.assertNotNull(uncompressed);
			var compressed:String = ByteArrayUtils.readString(toCompress);	
			
			
			
			//trace("-------------------- origin -------------------");
			//trace(ByteArrayUtils.readString(origin));
			
			var streams:Array = PdfBinaryUtils.findStreamPositions(origin);
			
			//trace("------------------ readstream ----------------");
			//trace(streams[0]+" "+streams[1]);
			var result:ByteArray = PdfBinaryUtils.decodeStream(origin, streams[0], streams[1]);
			var resString:String = ByteArrayUtils.readString(result);
			//trace(resString);
			var expectedRes:String ="ABCDEFflatedecodestream\nhelloworld\nendstream";
			
			assertNotNull(result);
			assertEquals(pattern.length, resString.length);
			assertEquals(pattern,resString);
		}
		
		[Test]
		public function getXREFTest():void
		{
			
		}
		
		
	}
}