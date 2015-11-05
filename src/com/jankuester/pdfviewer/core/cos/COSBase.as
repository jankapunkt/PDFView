package com.jankuester.pdfviewer.core.cos
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.pdfparser.ITokenizer;
	
	import flash.utils.ByteArray;

	public class COSBase implements IDisposable
	{
		public function COSBase()
		{
		}
		
		protected var _source:ByteArray;
		private var _direct:Boolean;
		
		public function getCOSObject():COSObject
		{
			return this as COSObject;
		}
		
		public function load(source:ByteArray, tokenizer:ITokenizer):void
		{
			throw new Error("abstract class. You have to override this method");
		}
		
		public function loadString(source:String):void
		{
			throw new Error("abstract class. You have to override this method");
		}
		
		/**
		 * If the state is set true, the dictionary will be written direct into the called object. 
		 * This means, no indirect object will be created.
		 * 
		 * @return the state
		 */
		public function isDirect():Boolean 
		{
			return _direct;
		}
		
		/**
		 * Set the state true, if the dictionary should be written as a direct object and not indirect.
		 * 
		 * @param direct set it true, for writting direct object
		 */
		public function setDirect(direct:Boolean):void
		{
			_direct = direct;
		}
		
		public function dispose():void
		{
			_source = null;
		}
	}
}