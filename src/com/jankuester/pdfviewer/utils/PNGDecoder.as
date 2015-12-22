/*
* Copyright (C) 2011 Ionel Rodriguez
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgment in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/



/* * * * * * * * * * * * * * * * * * * * *
* IMPORTANT!!
*
* Only works for png files with bit depth
* of 8 (4 bytes per pixel), colour type 6
* (true colour with alpha) and non inter-
* laced.
*
* * * * * * * * * * * * * * * * * * * * */
package com.jankuester.pdfviewer.utils
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class PNGDecoder
	{
		private static const IHDR:int = 0x49484452;
		private static const IDAT:int = 0x49444154;
		private static const tEXt:int = 0x74455874;
		private static const iTXt:int = 0x69545874;
		private static const zTXt:int = 0x7A545874;
		private static const IEND:int = 0x49454E44;
		
		private static var infoWidth:uint;
		private static var infoHeight:uint;
		private static var infoBitDepth:int;
		private static var infoColourType:int;
		private static var infoCompressionMethod:int;
		private static var infoFilterMethod:int;
		private static var infoInterlaceMethod:int;
		
		private static var fileIn:ByteArray;
		private static var buffer:ByteArray;
		private static var scanline:int;
		private static var samples:int;
		
		//**************************************************************************************************************
		
		/** Decodes a png image stream to a BitmapData. If the ByteArray is not a png, returns null. **/
		public static function decodeImage(bytes:ByteArray):BitmapData {
			if (bytes == null) return null;
			
			fileIn = bytes;
			buffer = new ByteArray();
			samples = 4;
			
			fileIn.position = 0;
			
			// signature check
			if (fileIn.readUnsignedInt() != 0x89504e47)
			{
				trace("signature check 1 failed");
				return invalidPNG();
			}
			if (fileIn.readUnsignedInt() != 0x0D0A1A0A)
			{
				trace("signature check 2 failed");
				return invalidPNG();
			}
			
			var chunks:Array = getChunks();
			
			var countIHDR:int = 0;
			var validChunk:Boolean;
			var i:int;
			
			for (i = 0; i < chunks.length; ++i) {
				fileIn.position = chunks[i].position;
				validChunk = true;
				
				if (chunks[i].type == IHDR) {
					++countIHDR;
					
					if (i == 0) validChunk = processIHDR(chunks[i].length);
					else validChunk = false;
				}
				
				if (chunks[i].type == IDAT) {
					buffer.writeBytes(fileIn, fileIn.position, chunks[i].length);
				}
				
				if (!validChunk || countIHDR > 1) return invalidPNG();
			}
			
			var bd:BitmapData = processIDAT();
			
			fileIn = null;
			buffer = null;
			
			return bd;
		}
		
		/* Retrieves the textual information from a png image stream. If the ByteArray is not a png, returns null. */
		public static function decodeInfo(bytes:ByteArray):XML {
			if (bytes == null) return null;
			
			fileIn = bytes;
			fileIn.position = 0;
			
			// signature check
			if (fileIn.readUnsignedInt() != 0x89504e47) { fileIn = null; return null; }
			if (fileIn.readUnsignedInt() != 0x0D0A1A0A) { fileIn = null; return null; }
			
			var chunks:Array = getChunks();
			var xml:XML = <information />;
			var i:int;
			
			for (i = 0; i < chunks.length; ++i) {
				if (chunks[i].type == tEXt) xml.appendChild(gettEXt(chunks[i].position, chunks[i].length));
				if (chunks[i].type == iTXt) xml.appendChild(getiTXt(chunks[i].position, chunks[i].length));
				if (chunks[i].type == zTXt) xml.appendChild(getzTXt(chunks[i].position, chunks[i].length));
			}
			
			fileIn = null;
			
			return xml;
		}
		
		//**************************************************************************************************************
		// Textual data decoding
		
		private static function gettEXt(init:int, len:int):XML {
			var node:XML = <tEXt />;
			var keyword:String = "";
			var text:String = "";
			var char:int = -1;
			
			fileIn.position = init;
			
			while (fileIn.position < init + len) {
				char = fileIn.readUnsignedByte();
				
				if (char > 0) keyword += String.fromCharCode(char);
				else break;
			}
			
			text = fileIn.readUTFBytes(init + len - fileIn.position);
			
			node.appendChild(<keyword>{keyword}</keyword>);
			node.appendChild(<text>{text}</text>);
			
			return node;
		}
		
		private static function getzTXt(init:int, len:int):XML {
			var node:XML = <zTXt />;
			var keyword:String = "";
			var text:String = "";
			var char:int = -1;
			
			fileIn.position = init;
			
			while (fileIn.position < init + len) {
				char = fileIn.readUnsignedByte();
				
				if (char > 0) keyword += String.fromCharCode(char);
				else break;
			}
			
			var compressionMethod:int = fileIn.readUnsignedByte();
			
			if (compressionMethod == 0) {
				var ba:ByteArray = new ByteArray();
				
				ba.writeBytes(fileIn, fileIn.position, init + len - fileIn.position);
				ba.uncompress();
				
				text = ba.readUTFBytes(ba.length);
			}
			
			node.appendChild(<keyword>{keyword}</keyword>);
			node.appendChild(<text>{text}</text>);
			
			return node;
		}
		
		private static function getiTXt(init:int, len:int):XML {
			var node:XML = <iTXt />;
			var keyword:String = "";
			var langTag:String = "";
			var transKeyword:String = "";
			var text:String = "";
			var char:int = -1;
			
			fileIn.position = init;
			
			while (fileIn.position < init + len) {
				char = fileIn.readUnsignedByte();
				
				if (char > 0) keyword += String.fromCharCode(char);
				else break;
			}
			
			var isCompressed:Boolean = fileIn.readUnsignedByte() == 1;
			var compressionMethod:int = fileIn.readUnsignedByte();
			
			while (fileIn.position < init + len) {
				char = fileIn.readUnsignedByte();
				
				if (char > 0) langTag += String.fromCharCode(char);
				else break;
			}
			
			while (fileIn.position < init + len) {
				char = fileIn.readUnsignedByte();
				
				if (char > 0) transKeyword += String.fromCharCode(char);
				else break;
			}
			
			if (isCompressed) {
				if (compressionMethod == 0) {
					var ba:ByteArray = new ByteArray();
					
					ba.writeBytes(fileIn, fileIn.position, init + len - fileIn.position);
					ba.uncompress();
					
					text = ba.readUTFBytes(ba.length);
				}
			}
			else text = fileIn.readUTFBytes(init + len - fileIn.position);
			
			node.appendChild(<keyword>{keyword}</keyword>);
			node.appendChild(<text>{text}</text>);
			node.appendChild(<languageTag>{langTag}</languageTag>);
			node.appendChild(<translatedKeyword>{transKeyword}</translatedKeyword>);
			
			return node;
		}
		
		//**************************************************************************************************************
		// Misc functions
		
		private static function invalidPNG():BitmapData {
			fileIn = null;
			buffer = null;
			trace("------ INVALID PNG!!!!----------");
			return null;
		}
		
		private static function getChunks():Array {
			var chunks:Array = [];
			var length:uint;
			var type:int;
			
			do {
				length = fileIn.readUnsignedInt();
				type = fileIn.readInt();
				
				chunks.push({type: type, position: fileIn.position, length: length});
				fileIn.position += length + 4; //data length + CRC (4 bytes)
			}
			while (type != IEND && fileIn.bytesAvailable > 0);
			
			return chunks;
		}
		
		//**************************************************************************************************************
		// Header & image chunks processing
		
		private static function processIHDR(cLength:int):Boolean {
			if (cLength != 13) return false;
			
			infoWidth                  = fileIn.readUnsignedInt();
			infoHeight                 = fileIn.readUnsignedInt();
			
			infoBitDepth               = fileIn.readUnsignedByte();
			infoColourType             = fileIn.readUnsignedByte();
			infoCompressionMethod      = fileIn.readUnsignedByte();
			infoFilterMethod           = fileIn.readUnsignedByte();
			infoInterlaceMethod        = fileIn.readUnsignedByte();
			
			if (infoWidth <= 0 || infoHeight <= 0) return false;
			
			switch (infoBitDepth) {
				case 1:
				case 2:
				case 4:
				case 8:
				case 16: break;
				default: return false;
			}
			
			switch (infoColourType) {
				case 0:
					if (
						infoBitDepth != 1 &&
						infoBitDepth != 2 &&
						infoBitDepth != 4 &&
						infoBitDepth != 8 &&
						infoBitDepth != 16
					) return false;
					break;
				
				case 2:
				case 4:
				case 6:
					if (
						infoBitDepth != 8 &&
						infoBitDepth != 16
					) return false;
					break;
				
				case 3:
					if (
						infoBitDepth != 1 &&
						infoBitDepth != 2 &&
						infoBitDepth != 4 &&
						infoBitDepth != 8
					) return false;
					break;
				
				default: return false;
			}
			
			if (infoCompressionMethod != 0 || infoFilterMethod != 0) return false;
			if (infoInterlaceMethod != 0 && infoInterlaceMethod != 1) return false;
			
			return true;
		}
		
		private static function processIDAT():BitmapData {
			var bd:BitmapData = new BitmapData(infoWidth, infoHeight);
			
			var bufferLen:uint;
			var filter:int;
			var i:int;
			
			var r:uint;
			var g:uint;
			var b:uint;
			var a:uint;
			
			try { buffer.uncompress(); }
			catch (err:*) { return null }
			
			scanline = 0;
			bufferLen = buffer.length;
			
			while (buffer.position < bufferLen) {
				filter = buffer.readUnsignedByte();
				
				// check each scanline filter
				if (filter == 0) {
					for (i = 0; i < infoWidth; ++i ) {
						r = noSample() << 16;
						g = noSample() << 8;
						b = noSample();
						a = noSample() << 24;
						
						bd.setPixel32(i, scanline, a + r + g + b);
					}
				}
				else
					if (filter == 1) {
						for (i = 0; i < infoWidth; ++i ) {
							r = subSample() << 16;
							g = subSample() << 8;
							b = subSample();
							a = subSample() << 24;
							
							bd.setPixel32(i, scanline, a + r + g + b);
						}
					}
					else
						if (filter == 2) {
							for (i = 0; i < infoWidth; ++i ) {
								r = upSample() << 16;
								g = upSample() << 8;
								b = upSample();
								a = upSample() << 24;
								
								bd.setPixel32(i, scanline, a + r + g + b);
							}
						}
						else
							if (filter == 3) {
								for (i = 0; i < infoWidth; ++i ) {
									r = averageSample() << 16;
									g = averageSample() << 8;
									b = averageSample();
									a = averageSample() << 24;
									
									bd.setPixel32(i, scanline, a + r + g + b);
								}
							}
							else
								if (filter == 4) {
									for (i = 0; i < infoWidth; ++i ) {
										r = paethSample() << 16;
										g = paethSample() << 8;
										b = paethSample();
										a = paethSample() << 24;
										
										bd.setPixel32(i, scanline, a + r + g + b);
									}
								}
								else {
									buffer.position += samples * infoWidth;
								}
				
				++scanline;
			}
			
			return bd;
		}
		
		//**************************************************************************************************************
		// Scanline filters
		
		private static function noSample():uint {
			return buffer[buffer.position++];
		}
		
		private static function subSample():uint {
			var ret:uint = buffer[buffer.position] + byteA();
			
			ret &= 0xff;
			buffer[buffer.position++] = ret;
			
			return ret;
		}
		
		private static function upSample():uint {
			var ret:uint = buffer[buffer.position] + byteB();
			
			ret &= 0xff;
			buffer[buffer.position++] = ret;
			
			return ret;
		}
		
		private static function averageSample():uint {
			var ret:uint = buffer[buffer.position] + Math.floor((byteA() + byteB())/2);
			
			ret &= 0xff;
			buffer[buffer.position++] = ret;
			
			return ret;
		}
		
		private static function paethSample():uint {
			var ret:uint = buffer[buffer.position] + paethPredictor();
			
			ret &= 0xff;
			buffer[buffer.position++] = ret;
			
			return ret;
		}
		
		//**************************************************************************************************************
		// Misc functions
		
		private static function paethPredictor():uint {
			var a:uint = byteA();
			var b:uint = byteB();
			var c:uint = byteC();
			
			var p:int = 0;
			var pa:int = 0;
			var pb:int = 0;
			var pc:int = 0;
			var Pr:int = 0;
			
			p = a + b - c;
			
			pa = Math.abs(p - a);
			pb = Math.abs(p - b);
			pc = Math.abs(p - c);
			
			if (pa <= pb && pa <= pc) Pr = a;
			else
				if (pb <= pc) Pr = b;
				else
					Pr = c;
			
			return Pr;
		}
		
		/* The byte corresponding to the one being filtered from the pixel to the left. */
		private static function byteA():uint {
			var init:int = scanline * (infoWidth * samples + 1);
			var priorIndex:int = buffer.position - samples;
			
			if (priorIndex <= init) return 0;
			
			return buffer[priorIndex];
		}
		
		/* The byte corresponding to the one being filtered from the pixel at the top. */
		private static function byteB():uint {
			var priorIndex:int = buffer.position - (infoWidth * samples + 1);
			
			if (priorIndex < 0) return 0;
			
			return buffer[priorIndex];
		}
		
		/* The byte corresponding to the one being filtered from the pixel to the left from the pixel at the top. */
		private static function byteC():uint {
			var priorIndex:int = buffer.position - (infoWidth * samples + 1);
			
			if (priorIndex < 0) return 0;
			
			var init:int = (scanline - 1) * (infoWidth * samples + 1);
			priorIndex = priorIndex - samples;
			
			if (priorIndex <= init) return 0;
			
			return buffer[priorIndex];
		}
	}
}