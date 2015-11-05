package com.jankuester.pdfviewertests.utils
{
	public class StringUtils
	{
		public static function reverse(s:String):String
		{
			var ret:String="";
			for (var i:int = s.length-1; i >= 0 ; i--) 
			{
				ret+=s.charAt(i);
			}
			return ret;
		}
	}
}