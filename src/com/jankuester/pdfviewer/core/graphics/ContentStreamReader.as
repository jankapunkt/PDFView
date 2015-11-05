package com.jankuester.pdfviewer.core.graphics
{
	import com.jankuester.pdfviewer.core.interfaces.IDisposable;
	import com.jankuester.pdfviewer.core.model.resources.PageResources;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	/**
	 * Class to interpret the content stream of a page and transform it into displayable objects.
	 */
	public class ContentStreamReader implements IDisposable
	{
		//---------------------- GRAPHIC STATE OPERATORS ------------------------------//
		
		public static const G_STATE_PUSH:String=		"q";
		public static const G_STATE_POP:String=			"Q";
		
		public static const G_MATRIX_MODIFY:String=		"cm";
		
		public static const G_LINE_WIDTH:String=		"w";
		public static const G_LINE_CAP:String=			"J";
		public static const G_LINE_JOIN:String=			"j";
		
		public static const G_MITER_LIMIT:String=		"M";
		public static const G_DASH_PHASE:String=		"d";

		public static const G_INTENT:String=			"ri";
		public static const G_FLATNESS:String=			"i";
		
		//---------------------- GRAPHIC STATE OPERATORS ------------------------------//
		
		public static const T_BEGIN_TEXT:String=		"BT";
		public static const T_END_TEXT:String=			"ET";
		
		public static const T_MOVE_TO_NEXT_LINE:String=	"Td";
		public static const T_MOVE_TO_NEXT_LINE2:String="TD";
		public static const T_MOVE_TO_NEXT_LINE3:String="T*";
		
		public static const T_SET_MATRIX:String=		"Tm";
		
		public static const T_SHOW_TEXT:String=			"Tj";
		public static const T_NEXT_LINE_SHOW_TEXT:String="'";
		
		public static const T_CUSTOM_POSITIONING:String="TJ";
		
		//---------------------- COLOR STATE OPERATORS ------------------------------//
		
		public static const C_STROKING_COLOR:String=	"rg";
		
		//---------------------- PATH CONSTRUCTION OPERATORS ------------------------------//
		
		public static const P_APPEND_RECT:String=		"re";
		
		
		protected var _gStack:GraphicsStateStack;

		public function get gStack():GraphicsStateStack
		{
			return _gStack;
		}

		public function dispose():void
		{
			_currentObj = null;
			_currentState = null;
			_values = null;
			_objects.removeAll();
			_objects = null;
			_gStack = null;
		}
		
		protected var _currentState:GraphicsState;
		protected var _currentObj:GraphicsObject;
		
		protected var _values:Array; //buffer for sequencial numeric values
		
		protected var _objects:ArrayList;

		public function get objects():ArrayList
		{
			return _objects;
		}

		
		protected var _textMode:Boolean;
		
		public function ContentStreamReader(){}
		
		public function loadStream(content:String, resources:PageResources):void
		{
			_objects 	= new ArrayList();
			_gStack 	= new GraphicsStateStack();
			_currentObj = new GraphicsObject();
			trace("-------------------- STREAM READER --------------------");
			content = content.replace(/\n/g," ");
			var stream:int = content.indexOf("stream")+ 6;
			var end:int = content.indexOf("endstream");
			
			content = content.substring(stream, end);
			var tokens:Array = content.split(" ");
			
			//character map
			var cmap:Dictionary;
			var cfont:String="";
			
			for (var i:int = 0; i < tokens.length; i++) 
			{
				if (_currentState == null)
					_currentState = GraphicsFactory.createGraphicsState();
				if (_currentObj == null)
					_currentObj = GraphicsFactory.createGraphicsObject();
				if (_values == null)
					_values = new Array();
				
				var token:String = tokens[i];
				trace(token);
				var numToken:Number = Number(token);
				
				
				if(!isNaN(numToken))
				{
					_values.push(numToken);
					continue;
				}
				
				if (_textMode )
				{
					
					//decode actual text strings
					if (token.indexOf(T_CUSTOM_POSITIONING) > -1 || token.indexOf(T_SHOW_TEXT) > -1)
					{
						_currentObj.l.setStyle("fontSize",_values[0]);
						_values = [];
						
						var startText:int = token.indexOf("[");
						var endofText:int = token.indexOf("]");
						var textEncoded:String = token.substring(startText+1, endofText);
						var textSplit:Array = textEncoded.split(">");
						var tBuff:String="";
						for (var j:int = 0; j < textSplit.length; j++) 
						{
							var tFragment:String = textSplit[j];
							var tSplit:Array = tFragment.split("<");
							if (tSplit[1] != null && tSplit[1].length > 1)
							{
								
								for (var k:int = 0; k < tSplit[1].length; k+=2) 
								{
									var subs:String=tSplit[1].substr(k,2);
									tBuff+=String.fromCharCode("0x"+cmap[subs]);
								}
								
							}
						}
						trace(tBuff);
						_currentObj.l.text = tBuff;
					}
				}
				
				switch (token)
				{
					case(T_BEGIN_TEXT):
						_values = [];
						_textMode = true;
						break;
					case(T_END_TEXT):
						_values = [];
						_textMode = false;
						break;
					case(G_STATE_PUSH):
						_values = [];
						_currentObj.g = _currentState;
						_objects.addItem(_currentObj);
						_gStack.push(_currentState);
						_currentObj = null;
						_currentState = null;
						break;
					case(G_STATE_PUSH):
						_values = [];
						_currentState =_gStack.pop() as GraphicsState;
						break;
					case(C_STROKING_COLOR):
						_currentState.strokingColorRGB = _values;
						trace("StrokginCOlor: "+_values[0]+" "+_values[1]+" "+_values[2]);
						_values = [];
						break;
				}
				
				if (token.search(/(\/[F]+[0-9]+)/g) >-1)
				{
					_currentObj.x = _values[0];
					_currentObj.y = _values[1];
					_values = [];
					cfont = token.replace("/","");
					cmap = resources.font.getFont(cfont).toUnicode.cmap;
				}
			}
			
		}
		
		
		
	}
}