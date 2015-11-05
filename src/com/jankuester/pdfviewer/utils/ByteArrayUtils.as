package com.jankuester.pdfviewer.utils
{
	import com.jankuester.pdfviewertests.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class ByteArrayUtils
	{
		
		public static function writeString(ba:ByteArray,s:String, pos:int=0, preservePos:Boolean=false):ByteArray
		{
			if (s==null || s=="")return ba;
			if (ba == null)
				ba = new ByteArray();
			if (pos<0)
				pos=0;
			if (pos>ba.length)
				pos=ba.length;
			
			var posBuff:int = ba.position;
			ba.position = pos;
			ba.writeUTFBytes(s);
			if (preservePos && posBuff <= ba.length && posBuff >= 0)
				ba.position = posBuff;
			return ba;
		}
		
		public static function insertString(ba:ByteArray, s:String, pos:int=0, preservePos:Boolean=false):ByteArray
		{
			if (s==null || s=="")
				return ba;
			
			if (ba == null)
				ba = new ByteArray();
			if (pos<0)
				pos=0;
			if (pos>ba.length)
				pos=ba.length;
			var posBuff:int = ba.position;
			ba.position=0;
						
			var newBytes:ByteArray = new ByteArray();
				newBytes.writeBytes(ba, 0, pos);
				newBytes.writeUTFBytes(s);
			ba.position = pos;
				newBytes.writeBytes(ba, pos, ba.bytesAvailable);
			if(preservePos && posBuff <= ba.length && posBuff >= 0)
				newBytes.position = posBuff;
			return newBytes;
		}

		public static function readString(ba:ByteArray, start:int=0, len:int=-1, preservePos:Boolean=true):String
		{
			if (ba == null)
				ba = new ByteArray();
			if (start < 0)
				start=0;
			if (start > ba.length)
				start = ba.length;
			if (len == -1)
				len = ba.length;
			var posBuff:int = ba.position;
			ba.position = start;
			var s:String="";
			var count:int=0;
			
			while(ba.bytesAvailable && count < len)
			{
				try
				{
					s+=ba.readUTFBytes(1);
					count++;
				} 
				catch(error:Error) 
				{
					s+=ba.readUTFBytes(ba.bytesAvailable);
				}	
			}
			
			if(preservePos)
				ba.position = posBuff;
			return s;
		}
		
		public static function readStringFromTo(ba:ByteArray, start:int=0, to:int=-1, preservePos:Boolean=true):String
		{
			if (ba == null)
				ba = new ByteArray();
			if (start < 0)
				start=0;
			if (start > ba.length)
				start = ba.length;
			if (to == -1)
				to = ba.length;
			if (to > ba.length)
				to = ba.length;
			var posBuff:int = ba.position;
			ba.position = start;
			var s:String="";
			
			while (ba.position < to)
			{
				s+=ba.readUTFBytes(1);	
			}
			if(preservePos)
				ba.position = posBuff;
			return s;
		}
	
		public static function clone(ba:ByteArray):ByteArray
		{
			if (ba == null)return new ByteArray();
			var posBuff:int = ba.position;
			ba.position = 0;
			var clone:ByteArray = new ByteArray();
				clone.writeBytes(ba, 0, ba.bytesAvailable);
			ba.position = posBuff;
			return clone;
		}
		
		public static function padString(str:String, len:int, char:String, padLeft:Boolean = true):String
		{
			var padLength:int = len - str.length;
			var str_padding:String = "";
			if(padLength > 0 && char.length == 1)
				for(var i:int = 0; i < padLength; i++)
					str_padding += char;
			
			return (padLeft ? str_padding : "") + str + (!padLeft ? str_padding: "");
		}
		
		
		public static function byteArrayToBinaryString(bArray:ByteArray):String
		{
			// binary string to return
			var str:String = "";
			
			// store length so that it is not recomputed on every loop
			var aLen:uint = bArray.length;
			
			// loop over all available bytes and concatenate the padded string to return string
			for(var i:int = 0; i < aLen; i++)
				str += padString(bArray[i].toString(2), 8, "0");
			
			// return binary string
			return str;
		}
		
		public static function printByteArray(ba:ByteArray):void
		{
			if(ba == null || ba.bytesAvailable <= 0)return;
			
			while(ba.bytesAvailable)
			{
				trace(ba.readUTFBytes(ba.bytesAvailable));
			}
		}
		
		public static function getByteArrayAsStringList(ba:ByteArray):Array
		{
			if(ba == null || ba.bytesAvailable <= 0)return null;
			var arr:Array = new Array();
			var s:String ="";
			while(ba.bytesAvailable > 0)
			{
				try
				{
					var buffer:String = ba.readUTFBytes(ba.readUnsignedByte());	
					s+= buffer;
				} 
				catch(error:Error) 
				{
					s+= ba.readUTFBytes(ba.bytesAvailable);
				} 
			}
			arr = s.split("\n");
			return arr;
		}
		
		
		public static function replaceFromTo(target:ByteArray, start:int, end:int, replaceWith:ByteArray, replaceStart:int, replaceEnd:int, preservePos:Boolean=true):ByteArray
		{
			if (replaceWith == null) return target;
			if (target == null)
				target = new ByteArray();
			if (start < 0) start = 0;
			if (end > target.length) end = target.length;
			if (replaceStart < 0) replaceStart = 0;
			if (replaceEnd > replaceWith.length)replaceEnd = replaceWith.length;
			
			
			var posBuf:int  = target.position;
			target.position = start;
			
			var b:ByteArray = new ByteArray();
				b.writeBytes(target, 0, start);
				b.writeBytes(replaceWith, replaceStart, replaceEnd);
			target.position=end;
				b.writeBytes(target, end, target.bytesAvailable);
			if (preservePos)
				target.position = posBuf;
			return b;
		}
		
		
		public static function indexOf(ba:ByteArray, pattern:String,preservePos:Boolean=true):int
		{
			if( ba == null || ba.length==0)return -1;
			var posBuff:int = ba.position;
			ba.position = 0;
			
			var buff:String="";
			while(ba.bytesAvailable > 0)
			{
				trace(ba.position+" "+ba.length+" "+ba.bytesAvailable);
				buff+=ba.readUTFBytes(1);
				//trace(buff);
				if (StringUtils.reverse(buff).indexOf(pattern) > -1)
				{
					var retPos:int = ba.position-1;
					if(preservePos)
						ba.position=posBuff;
					return retPos;
				}
				ba.position++;
			}
			if(preservePos)
				ba.position=posBuff;
			return -1;
		}
		
		public static function lastIndexOf(ba:ByteArray, pattern:String, preservePos:Boolean=true):int
		{
			if( ba == null || ba.length==0)return -1;
			var posBuff:int = ba.position;
				ba.position = ba.length-1;
			var buff:String="";
			while(ba.position>0)
			{
				buff+=ba.readUTFBytes(1);
				if (StringUtils.reverse(buff).indexOf(pattern) > -1)
				{
					var retPos:int = ba.position-1;
					if(preservePos)
						ba.position=posBuff;
					return retPos;
				}
				ba.position-=2;
			}
			if(preservePos)
				ba.position=posBuff;
			return -1;
		}
		
		
		


	}
}