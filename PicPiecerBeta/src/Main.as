package
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	
	[SWF(width='980',height='520')]
	public class Main extends Sprite
	{
		private var template:Template;
		
		public function Main()
		{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;  
			stage.align=StageAlign.TOP_LEFT;
			
			
			template = new Template();
			addChild(template);
			
			
			addChild(Bar.getInstance());

			addListener();
			
			Params.setParams(this.loaderInfo.parameters);
			
			
		}
		
		private function addListener():void{
			Bar.getInstance().addEventListener(CustomEvent.RESET,function():void{
				template.reset();
			});
			
			
			Bar.getInstance().addEventListener(CustomEvent.PREVIEW,function():void{
				template.preview();
				
			
			});
			
			Bar.getInstance().addEventListener(CustomEvent.PREVIEW_BACK,function():void{
				template.preview_back();
			});
			
			
			Bar.getInstance().addEventListener(CustomEvent.FINISH,function():void{
				template.preview();
				var bmd:BitmapData = new BitmapData(template.width,template.height);
				bmd.draw(template);
				var bytes:ByteArray = bmd.encode(bmd.rect,new JPEGEncoderOptions())
				
				Upload.POST(bytes);
				
												
			});
		}
	}
}

