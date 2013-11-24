package
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	public class Area extends Sprite
	{
		
		[Embed(source='assets.swf',symbol='BrowseBtn')]
		private var BrowseBtn:Class;
		private var _browseBtn:*;
		
		
		[Embed(source='assets.swf',symbol='RepickBtn')]
		private var RepickBtn:Class;
		private var _repickBtn:*;
		
		private var _w:Number;
		private var _h:Number;
		private var _picW:Number;//最贴合area尺寸的图片宽度
		private var _picH:Number;//最贴合area尺寸的图片高度
		
		private var _file:FileReference;
		private var _loader:Loader;
		private var _pic:Sprite;
		
		
		
		public function Area(parent:Sprite,x:Number,y:Number,w:Number,h:Number)
		{
			super();
			
			parent.addChild(this);
			this.x = x;
			this.y = y;
			
			_w = w;
			_h = h;
						
			
			addBorder();
			addBtns();
			addMask();
			addAction();
				
			
		}
		
		private function addBorder():void{
			var border:Shape = new Shape();
			border.graphics.lineStyle(1,0xd8d8d8);
			border.graphics.beginFill(0x000000,0);
			border.graphics.drawRect(0,0,_w,_h);
			border.graphics.endFill();
			addChild(border);
			
		}
		
		private function addBtns():void{
			_browseBtn = new BrowseBtn();
			_repickBtn = new RepickBtn();
			
			_browseBtn.x = _w/2 - _browseBtn.width/2;
			_browseBtn.y = _h/2 - _browseBtn.height/2;
			_repickBtn.x = _w - _repickBtn.width - 5;
			_repickBtn.y = _h - _repickBtn.height - 5
			_repickBtn.visible = false;
			addChild(_browseBtn);
			addChild(_repickBtn);
		}
		
		private function addMask():void{
			var m:Shape = new Shape();
			m.graphics.beginFill(0x000000);
			m.graphics.drawRect(0,0,_w,_h+1);
			this.addChild(m);
			this.mask = m;
		}
		
		private function addAction():void{
			_file = new FileReference();
			_loader = new Loader();
			_pic = new Sprite();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
				_pic.x = 0;
				_pic.y = 0;
				_pic.addChild(_loader);
				addChild(_pic);
				swapChildren(_pic,_repickBtn);
				_repickBtn.visible = true;
				
				
				setPicSize();
				
				dispatchEvent(new CustomEvent(CustomEvent.PIC_ADDED));
			});
			
			_file.addEventListener(Event.SELECT,function():void{
				_file.load();
				_browseBtn.visible = false;
			});
			
			_file.addEventListener(Event.COMPLETE,function():void{
				_loader.loadBytes(_file.data);
			});
			
			_file.addEventListener(Event.CANCEL,function():void{
				_browseBtn.visible = true;
			});
			
			
			_browseBtn.addEventListener(MouseEvent.CLICK,function():void{
				_file.browse(getTypes());
			});
			
			_repickBtn.addEventListener(MouseEvent.CLICK,function():void{
				reset();
				
				_file.browse();
			});
			
			
			_pic.addEventListener(MouseEvent.MOUSE_DOWN,function():void{
				var rect:Rectangle = new Rectangle(0,0,_w - _pic.width,_h - _pic.height );
				_pic.startDrag(false,rect);
				
				
			});
			
			_pic.addEventListener(MouseEvent.MOUSE_UP,function():void{
				_pic.stopDrag();

			});
			
			_pic.addEventListener(MouseEvent.MOUSE_OUT,function():void{
				_pic.stopDrag();

			});
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			
			
			
			function onMouseWheel(e:MouseEvent):void{
				
				
				if(e.delta < 0){
					if(_pic.width == _picW) return;
					_pic.scaleX -= 0.1;
					_pic.scaleY -= 0.1;
				}else {
					_pic.scaleX += 0.1;
					_pic.scaleY += 0.1;
					
				}
			}
			
			
		}
		
		private function setPicSize():void{
			var pic_ratio:Number = _loader.content.width/_loader.content.height;
			var area_ratio:Number =  _w/_h;
			
			if(pic_ratio > area_ratio){
				_pic.height = _h;
				_pic.width = _h*pic_ratio;
			}else if(pic_ratio < area_ratio){
				_pic.width = _w;
				_pic.height = _w/pic_ratio;
			}else{
				_pic.width  = _w;
				_pic.height = _h;
			}
			
			_picW = _pic.width;
			_picH = _pic.height;
			
		}
		
		public function reset():void{
			_browseBtn.visible = true;
			_repickBtn.visible = false;
			
			if(this.contains(_pic)){
				removeChild(_pic);
			}
			if(_pic.contains(_loader)){
				_pic.removeChild(_loader);
			}
			
			dispatchEvent(new CustomEvent(CustomEvent.PIC_REMOVED));
		}
		
		public function preview():void{
			_repickBtn.visible = false;
		}
		
		public function preview_back():void{
			if(contains(_pic)){
				_repickBtn.visible = true;
			}
			
		}
		
		
		public function getTypes():Array {
			var allTypes:Array = new Array();
			allTypes.push(getImageTypeFilter());
			//allTypes.push(getTextTypeFilter());
			return allTypes;
		}
		
		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.bmp)", "*.jpg;*.jpeg;*.gif;*.png;*.bmp");
		}
		
		
	}
}