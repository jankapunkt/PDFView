package com.jankuester.pdfviewer.core.graphics
{
	import spark.primitives.Path;

	public class GraphicsState
	{
		public function GraphicsState()
		{
		}
		//---------------------- DEVICE INDEPENDENT STATES ------------------------------//
		public var CTM:Array;	//current transformation matrix
		public var clippingPath:Path;
		
		public var colorSpace:String;
		public var color:String;
		
		public var textState:String;
		public var lineWidth:Number;
		public var lineCap:int;
		public var lineJoin:int;
		public var miterLimit:Number;
		public var dashPattern:Array;
		public var renderingIntent:String;
		public var strokeAdjustment:Boolean;
		public var blendMode:Array;
		public var softMask:String;
		public var alphaConstant:Number;
		public var alphaSource:Boolean;
		
		//---------------------- DEVICE DEPENDENT STATES ------------------------------//
		public var overprint:Boolean;
		public var overprintMode:Number;
		public var halftone:String;
		public var flatness:Number;
		public var smoothness:Number;

		//---------------------- DEVICE DEPENDENT FUNCTIONS ------------------------------//
		
		public function undercolorRemoval():void
		{
			
		}
		
		public function transfer():void
		{
			
		}
		
		public function blackGeneration():void
		{
			
		}
		

		
		public var strokingColorRGB:Array;
	}
}