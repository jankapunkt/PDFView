package com.jankuester.pdfviewer.core.cos
{
	import flash.utils.ByteArray;

	/**
	 * Boolean objects 
 	 * 	represent the logical values of true and false. They appear in PDF files using the keywords true and false	 * 
	 */
	public class COSBoolean extends COSBase
	{
		/**
		 * The true boolean token.
		 */
		public static const TRUE_BYTES:Array = [ 116, 114, 117, 101 ]; //"true".getBytes( "ISO-8859-1" );
		/**
		 * The false boolean token.
		 */
		public static const FALSE_BYTES:Array = [ 102, 97, 108, 115, 101 ]; //"false".getBytes( "ISO-8859-1" );
		
		/**
		 * The PDF true value.
		 */
		public static const  TRUE:COSBoolean = new COSBoolean( true );
		
		/**
		 * The PDF false value.
		 */
		public static const  FALSE:COSBoolean = new COSBoolean( false );
		
		private const  value:Boolean;
		
		
		
		
		public function COSBoolean(initialValue:Boolean)
		{
			value = initialValue;
		}
		
		/**
		 * This will get the value that this object wraps.
		 *
		 * @return The boolean value of this object.
		 */
		public function getValue():Boolean
		{
			return value;
		}
		
		/**
		 * This will get the value that this object wraps.
		 *
		 * @return The boolean value of this object.
		 */
		public function getValueAsObject():Boolean
		{
			return (value?true:false);
		}
		
		/**
		 * This will get the boolean value.
		 *
		 * @param value Parameter telling which boolean value to get.
		 *
		 * @return The single boolean instance that matches the parameter.
		 */
		public static function getBoolean( value:Boolean ):COSBoolean
		{
			return (value?TRUE:FALSE);
		}
		
		/**
		 * This will get the boolean value.
		 *
		 * @param value Parameter telling which boolean value to get.
		 *
		 * @return The single boolean instance that matches the parameter.
		 */
		public static function getBoolean(  value:Boolean ):COSBoolean
		{
			return getBoolean( value );
		}
		
		
		
		/**
		 * visitor pattern double dispatch method.
		 *
		 * @param visitor The object to notify when visiting this object.
		 * @return any object, depending on the visitor implementation, or null
		 * @throws IOException If an error occurs while visiting this object.
		 */
		
		override public function accept(  visitor:ICOSVisitor ):Object // throws IOException
		{
			return visitor.visitFromBoolean(this);
		}
		
		/**
		 * Return a string representation of this object.
		 *
		 * @return The string value of this object.
		 */
		override
		public function toString():String
		{
			return String(value);
		}
		
		/**
		 * This will write this object out to a PDF stream.
		 *
		 * @param output The stream to write this object out to.
		 *
		 * @throws IOException If an error occurs while writing out this object.
		 */
		public function writePDF(  output:ByteArray ):void //throws IOException
		{
			if( value )
			{
				for (var i:int = 0; i < TRUE_BYTES.length; i++) 
				{
					output.writeBytes( TRUE_BYTES[i] );
				}
			}
			else
			{
				for (var j:int = 0; j < FALSE_BYTES.length; j++) 
				{
					output.writeBytes( FALSE_BYTES[j] );
				}
			}
		}
	}
}