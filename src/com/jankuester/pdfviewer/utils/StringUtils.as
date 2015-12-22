package com.jankuester.pdfviewer.utils
{
	/**
	 * Common String utilities.
	 */
	public class StringUtils
	{
		
		/**
		 * Returns a reversed version of a String without altering the original.
		 * @param s The String to be reversed.
		 * @returns A reversed version of the input.
		 */
		public static function reverse(s:String):String
		{
			var ret:String="";
			for (var i:int = s.length-1; i >= 0 ; i--) 
			{
				ret+=s.charAt(i);
			}
			return ret;
		}
		
		
		public static function printChars(s:String):void
		{
			for (var i:int = 0; i < s.length; i++) 
			{
				trace(i+" "+s.charAt(i)+" => "+ s.charCodeAt(i));
			}
			
		}
	}
}