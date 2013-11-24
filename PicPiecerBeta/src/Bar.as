package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Bar extends Sprite
	{
		[Embed(source='assets.swf',symbol='PreviewBtn')]
		private var PreviewBtn:Class;
		private var _previewBtn:*;
		
		[Embed(source='assets.swf',symbol='FinishBtn')]
		private var FinishBtn:Class;
		private var _finishBtn:*;
		
		[Embed(source='assets.swf',symbol='ResetBtn')]
		private var ResetBtn:Class;
		private var _resetBtn:*;
		
		[Embed(source='assets.swf',symbol='Gantanhao')]
		private var Gantanhao:Class;
		private var _gantanhao:*;
		
		private static var _instance:Bar = new Bar();
		
		public function Bar()
		{
			initUI();
			if(_instance){
				
				throw Error('Plz use getInstance !');
			}
			
		}
		
		public static function getInstance():Bar{
			return _instance;
		}
		
		
		public function enableFinish(v:Boolean):void{
			_finishBtn.mouseEnabled = v;
		}
		
		public function enablePreview(v:Boolean):void{
			_previewBtn.mouseEnabled = v;
		}
		
		
		private function initUI():void{
			
			_gantanhao = new Gantanhao();
			addChild(_gantanhao);
			_gantanhao.x = 10;
			_gantanhao.y = 480;
			
			var txt:TextField = new TextField();
			txt.text = '使用鼠标滚轮调整图片大小';
			txt.setTextFormat(new TextFormat('Verdana',null,0xc9c9c9))
			addChild(txt);
			txt.x = 30;
			txt.y = 480;
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			_resetBtn = new ResetBtn();
			addChild(_resetBtn);
			_resetBtn.x = 615;
			_resetBtn.y = 470;
			_resetBtn.addEventListener(MouseEvent.CLICK,function():void{
				
				dispatchEvent(new CustomEvent(CustomEvent.RESET));
			});
			
			_previewBtn = new PreviewBtn();
			addChild(_previewBtn);
			_previewBtn.x = 745;
			_previewBtn.y = 470;
			_previewBtn.addEventListener(MouseEvent.MOUSE_OVER,function():void{
				dispatchEvent(new CustomEvent(CustomEvent.PREVIEW));
			});
			
			_previewBtn.addEventListener(MouseEvent.MOUSE_OUT,function():void{
				dispatchEvent(new CustomEvent(CustomEvent.PREVIEW_BACK));
			});
			
			_previewBtn.mouseEnabled = false;
			
			_finishBtn = new FinishBtn();
			addChild(_finishBtn);
			_finishBtn.x = 875;
			_finishBtn.y = 470;
			_finishBtn.addEventListener(MouseEvent.CLICK,function():void{
				dispatchEvent(new CustomEvent(CustomEvent.FINISH));
			});
			
			_finishBtn.mouseEnabled = false;
		}
	}
}