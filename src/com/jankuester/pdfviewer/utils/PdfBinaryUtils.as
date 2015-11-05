package com.jankuester.pdfviewer.utils
{
	import com.jankuester.pdfviewer.core.model.PDFConstants;
	import com.jankuester.pdfviewertests.utils.StringUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	public class PdfBinaryUtils
	{
		
		public static function getObjectBytesByReference(source:ByteArray,start:int, preservePos:Boolean=true):ByteArray
		{
			if (source == null)return null;
			var posBuff:int = source.position;
			source.position = start;
			var tmp:String="";
			var end:int=source.length;
			while(source.bytesAvailable)
			{
				tmp+=source.readUTFBytes(1);
				if (tmp==PDFConstants.STRUCT_DELIMITER)
					tmp="";
				if (tmp.indexOf(PDFConstants.OBJECT_CLOSE)>-1)
				{
					end = source.position;
					break;
				}
			}
			trace("get object by ref: "+start+" "+end);
			var b:ByteArray = new ByteArray();
				b.writeBytes(source, start, end-start);
			return b;
		}

		public static function getLines(ba:ByteArray):Vector.<String>
		{
			var lines:Vector.<String> = new Vector.<String>();
			ba.position = 0;
			var line:String="";
			var linecount:int = 0;
			while(ba.bytesAvailable)
			{
				var buffer:String= ba.readUTFBytes(1);
				if (buffer == PDFConstants.STRUCT_DELIMITER)
				{
					lines.push( line );	
					line="";
				}else{
					line+=buffer;
				}
			}
			return lines;
		}
		
		public static function readLine(ba:ByteArray, pos:int):String
		{
			var line:String="";
			var posBuff:int = pos;
			ba.position = pos;
			while(ba.bytesAvailable)
			{
				var buffer:String= ba.readUTFBytes(1);
				if (buffer == PDFConstants.STRUCT_DELIMITER)
				{
					ba.position = posBuff;
					return line;
				}else{
					line+=buffer;
				}
			}
			ba.position = posBuff;
			return line;
		}
		
		
		public static function findStreamPositions(ba:ByteArray):Array
		{
			if (ba == null)return [];
			var streams:Array = new Array();
			for (var i:int = 0; i < ba.length; i++) 
			{
				try
				{
					ba.position = i;
					var buffer:String = ba.readUTFBytes(6)
					if (buffer==PDFConstants.TAG_STREAM_START)
					{
						streams.push(i);
					}
				} catch(error:Error) {
					//trace("WARING - FINDING STREAM POSITION ("+i+"): "+error.message);
				}
				
			}
			
			for (var j:int = 0; j < streams.length-1; j+=2) 
			{
				var start:int 	= streams[j];
				var end:int		= streams[j+1];
				//purge char sequences
				var count:int = PdfBinaryUtils.purgeStreamChars(ba, start);
				streams[j] 		= start + count;
				count = PdfBinaryUtils.purgeEndstreamChars(ba,end);
				streams[j+1] 	= end - count;
			}
			
			
			return streams;
		}
		
		
		public static function decodeStream(ba:ByteArray,start:int,end:int):ByteArray
		{
			
			var type:String= getStreamDef(ba, start);
			ba.position = 0;
			var len:int = end-start;
			var b:ByteArray = new ByteArray();
			//trace("type:::::"+type+" "+ba.length);
			try
			{
				if (type == "none")
					type==PDFConstants.DEFLATE;//return ba;
				
				b.writeBytes(ba,start, len);
				//trace(b.length);
				//trace("--------------------------------------------------------------");
				//trace(ByteArrayUtils.readString(b));
				//trace("--------------------------------------------------------------");
				if(type==PDFConstants.DEFLATE)
				{
					b.uncompress(CompressionAlgorithm.ZLIB);
				}
				if(type==PDFConstants.DCT)
				{
					//do nothing and load the jpgeg stream via loader later
				}
				b.position = 0;
				//trace(type+" => success! len="+b.length);
				return b;
			}catch(e:Error){
				trace("=========================================================================================================");
				trace("readStream: error - "+e.message+" type="+type+" len="+b.length);
				//trace(ByteArrayUtils.readString(b));
				trace("=========================================================================================================");
				return null;	
			}
			return null;
		}
		
		public static function getStreamDef(ba:ByteArray, pos:int, preservePos:Boolean=true):String
		{
			if (ba == null) return "none";
			var posBuff:int = ba.position;
			var streamDef:String="";
			var type:String="none";
				ba.position = pos;
			if (ba.position % 2 != 0) 
			{
				if (ba.position == ba.length)
					ba.position--;
				else
					ba.position++;
			}
			try
			{
				while(ba.position>0)
				{
					if (ba.position == ba.length)
					{
						ba.position -= 2;
						continue;
					}
					streamDef+= ba.readUTFBytes(1);
					var reverse:String = StringUtils.reverse(streamDef);
					if (reverse.toLowerCase().indexOf(PDFConstants.DEFLATE)>-1)
					{
						if(preservePos) ba.position = posBuff;
						return PDFConstants.DEFLATE;
					}
					
					if (reverse.toLowerCase().indexOf(PDFConstants.DCT)>-1)
					{
						if(preservePos) ba.position = posBuff;
						return PDFConstants.DCT;
					}
					
					ba.position-=2;
				}
				
			} 
			catch(error:Error) 
			{
				trace(error.message);
			}
			
			if(preservePos) ba.position = posBuff;
			return type;
		}
		
		
		public static function purgeStreamChars(ba:ByteArray, start:int):int
		{
			var count:int= 0;
			ba.position = start;
			while(ba.bytesAvailable)
			{
				var charBuff:String = ba.readUTFBytes(1);
				if (charBuff == "s" || charBuff == "t" || charBuff == "r" || charBuff == "e" || charBuff == "a" || charBuff == "m" ||   charBuff == "\n" || charBuff == "\r\n" || charBuff == "\r")
				{
					//strace("purge: "+charBuff);
					count++;
				}else{
					break;
				}
			}
			return count;
		}
		
		public static function purgeEndstreamChars(ba:ByteArray, end:int):int
		{
			var count:int= 0;
			ba.position = end-1;
			//trace("********************************");
			while(ba.bytesAvailable)
			{
				var charBuff:String = ba.readUTFBytes(1);
				if (charBuff == "e" || charBuff == "n" || charBuff == "d" || charBuff == "s" || charBuff == "t" || charBuff == "r" || charBuff == "e" || charBuff == "a" || charBuff == "m" ||   charBuff == "\n" || charBuff == "\r\n" || charBuff == "\r")
				{
					//trace("purge: "+charBuff);
					count++;
					ba.position-=2;
				}else{
					break;
				}
			}
			return count;
		}
	}
}