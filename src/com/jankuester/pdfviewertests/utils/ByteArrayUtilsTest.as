package com.jankuester.pdfviewertests.utils
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewer.utils.ByteArrayUtils;
	import com.jankuester.pdfviewer.utils.PdfBinaryUtils;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	
	public class ByteArrayUtilsTest
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
		public function testBytesToString():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("helloworld");
			
			var reg:RegExp = new RegExp("helloworld");
			ba.position=0;
			Assert.assertEquals(reg.source, ByteArrayUtils.readString(ba,0,ba.length,true));
			Assert.assertEquals(ba.position,0);
			Assert.assertEquals(reg.source, ByteArrayUtils.readString(ba,0,ba.length,false));
			Assert.assertEquals(ba.position,ba.length);
			
			Assert.assertEquals(reg.source, ByteArrayUtils.readString(ba));
			
			reg = new RegExp("world");
			Assert.assertMatch(reg, ByteArrayUtils.readString(ba,5,ba.length));
			
			reg = new RegExp("hello");
			Assert.assertMatch(reg, ByteArrayUtils.readString(ba,0,5));
			
			reg = new RegExp("!§$%&/()=?`");
			ba.clear();
			ba.writeUTFBytes(reg.source);
			Assert.assertEquals(reg.source, ByteArrayUtils.readString(ba,0,ba.length));
			
		}
		
		[Test]
		public function testReadStringFromTo():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("helloworld");
			
			var reg:RegExp = new RegExp("helloworld");
			ba.position=0;
			Assert.assertEquals(reg.source, ByteArrayUtils.readStringFromTo(ba,0,ba.length,true));
			Assert.assertEquals(ba.position,0);
			Assert.assertEquals(reg.source, ByteArrayUtils.readStringFromTo(ba,0,ba.length,false));
			Assert.assertEquals(ba.position,ba.length);
			
			Assert.assertEquals(reg.source, ByteArrayUtils.readStringFromTo(ba));
			
			reg = new RegExp("world");
			Assert.assertMatch(reg, ByteArrayUtils.readStringFromTo(ba,5,ba.length));
			
			reg = new RegExp("hello");
			Assert.assertMatch(reg, ByteArrayUtils.readStringFromTo(ba,0,5));
			
			reg = new RegExp("!%&/()=?`");
			ba.clear();
			ByteArrayUtils.writeString(ba,reg.source,0);
			Assert.assertEquals(reg.source, ByteArrayUtils.readStringFromTo(ba,0,ba.length,true));
		}
		
		[Test]
		public function testWriteString():void
		{
			var ba:ByteArray;
			
			//initial write, no preserve
			ba = ByteArrayUtils.writeString(ba, "hello",0);
			Assert.assertEquals(ba.length, 5);
			Assert.assertEquals(ba.position, 5);
			Assert.assertEquals("hello",ByteArrayUtils.readString(ba,0,ba.length));
			Assert.assertEquals("hello",ByteArrayUtils.readString(ba));
			ba.clear();
			
			//preserve
			ba = ByteArrayUtils.writeString(ba, "hello",0, true);
			Assert.assertEquals(ba.length, 5);
			Assert.assertEquals(ba.position, 0);
			Assert.assertEquals("hello",ByteArrayUtils.readString(ba,0,ba.length));
			
			//append
			ba = ByteArrayUtils.writeString(ba, "hello",ba.length, false);
			Assert.assertEquals(ba.length, 10);
			Assert.assertEquals(ba.position, 10);
			Assert.assertEquals("hellohello",ByteArrayUtils.readString(ba,0,ba.length));
				
			//overwrite
			ba = ByteArrayUtils.writeString(ba, "hello world", 0, false);
			Assert.assertEquals(ba.length, 11);
			Assert.assertEquals("hello world",ByteArrayUtils.readString(ba,0,ba.length));
		}
		
		[Test]
		public function testInsertString():void
		{
			
			var ba:ByteArray = new ByteArray();
			ByteArrayUtils.writeString(ba, "helloworld");
			ba.position=0;
			ba = ByteArrayUtils.insertString(ba, "A",5);
			Assert.assertEquals("helloAworld", ByteArrayUtils.readString(ba,0,ba.length));
		}
		
		[Test]
		public function testReplace():void
		{
			var pattern:String="helloworld";
			
			var toCompress:ByteArray = new ByteArray();
				toCompress.writeUTFBytes(pattern);
				toCompress.compress();
			
			var origin:ByteArray = new ByteArray();
				origin.writeUTFBytes("ABCDEF");
				origin.writeUTFBytes(PDFConstants.DEFLATE);
				origin.writeUTFBytes("stream\n");
				origin.writeBytes(toCompress, 0,18);
				origin.writeUTFBytes("\nendstream");
			
			var streams:Array = PdfBinaryUtils.findStreamPositions(origin);
			
			var result:ByteArray = PdfBinaryUtils.decodeStream(origin, streams[0], streams[1]);
			var resString:String = ByteArrayUtils.readString(result);

			var inserted:ByteArray = ByteArrayUtils.replaceFromTo(origin, streams[0], streams[1], result, 0, result.length);
			
			var expectedRes:String ="ABCDEFflatedecodestream\nhelloworld\nendstream";
			
			assertEquals(expectedRes, inserted);
		}
		
		[Test]
		public function lastIndexOfTest():void
		{
			var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes("ABChelloworldABC");
			var index:int = ByteArrayUtils.lastIndexOf(ba, "hello");
			assertEquals(3, index);
			assertEquals("h", ByteArrayUtils.readString(ba, index, 1));
		}

	}
}