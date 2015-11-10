package com.jankuester.pdfviewer.utils
{
	import com.jankuester.pdfviewertests.utils.StringUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * Utility class for common binary operations on ByteArrays
	 * 
	 */
	public class ByteArrayUtils
	{
		/**
		 * Writes a string as utf bytes to a ByteArray and overwrites all following bytes from pos
		 * 
		 * @param by The ByteArray to write 
		 * @param s The string to write
		 * @param pos the position to start the writing
		 * @param preservePos preserve the initial position of the array
		 * @return the written bytearray
		 */	
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
		
		/**
		 * Writes a string as utf bytes to a ByteArray but does not overwrite all following bytes but instead splits on pos and inserts the string
		 * 
		 * @param by The ByteArray to write 
		 * @param s The string to write
		 * @param pos the position to start the writing
		 * @param preservePos preserve the initial position of the array
		 * @return the new bytearray including all old bytes and the new inserted string
		 */	
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

		/**
		 * Reads a string from a given position and given length from a ByteArray
		 * 
		 * @param by The ByteArray to write 
		 * @param start The start position to read
		 * @param len The length of the bytes/characters to read
		 * @param preservePos preserve the initial position of the array
		 * @return the resulting utf string
		 */	
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
		
		/**
		 * Reads a string from a given start and end position from a ByteArray
		 * 
		 * @param by The ByteArray to write 
		 * @param start The start position to read
		 * @param to The end position to read
		 * @param preservePos preserve the initial position of the array
		 * @return the resulting utf string
		 **/
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
		
		/**
		 * Copys a ByteArray's content to a new created ByteArray.
		 */
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
		
		/**
		 * Splis a bytearray to an array of line-seperated strings.
		 */
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
		
		/**
		 * Searches a string occurrence in a ByteArray from start and returns the first found position.
		 * @param ba The ByteArray to search the pattern in
		 * @param pattern a String to search within the ByteArray
		 * @param preservePos preserve the initial position of the array
		 * @return an integer with the position in the byteArray
		 */
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
		
		/**
		 * Searches a string occurrence in a ByteArray from the end and returns the first (=last) found position.
		 * @param ba The ByteArray to search the pattern in
		 * @param pattern a String to search within the ByteArray
		 * @param preservePos preserve the initial position of the array
		 * @return an integer with the position in the byteArray
		 */
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
		
		
		public static function writeByteArrayToFile(ba:ByteArray, type:String, prefix:String):Boolean
		{
			try
			{
				ba.position = 0;
				var f:File = File.desktopDirectory.resolvePath(prefix+"_bytes.txt");
				var fs:FileStream = new FileStream();					
					fs.open(f, FileMode.WRITE);
					switch(type)
					{
						case "hex":
							while(ba.bytesAvailable && ba.bytesAvailable >= 32)
							{
								fs.writeUTF( ba.readInt().toString(16) );
							}
							break;
						
						case "text":
							
							break;
						
						case "bytes":
							fs.writeBytes(ba);
							break;
					}
					
					fs.close();	
			} 
			catch(error:Error) 
			{
				throw new Error(error.message);
				return false;
			}
			
			return true;
		}
	}
}