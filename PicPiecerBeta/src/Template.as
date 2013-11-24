package 
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class Template extends Sprite 
	{
		
		private var _jsonPath:String = "settings.json";
		public var areasData:Array;
		public var area_count:uint;
		private var areas:Vector.<Area>;
		private var pic_add_count:uint = 0;
		
		public function Template():void 
		{
				
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = _jsonPath;
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.load(request);
		}
		
		
		private function onLoaderComplete(e:Event):void 
		{
			var loader:URLLoader = URLLoader(e.target);
			var json:Object = com.adobe.serialization.json.JSON.decode(loader.data);
			areasData = json.Area;
			area_count = areasData.length;
			//trace(area_count)
			addArea();
		}
		
		private function addArea():void{
			areas = new Vector.<Area>();
			for each(var $area:Array in  areasData){
			
//				var w:uint = area[2];
//				var h:uint = area[3];
//				var rect:Sprite = new Sprite();
//				rect.graphics.lineStyle(1,0xaaaaaa);
//				rect.graphics.drawRect(area[0],area[1],w,h);
//
//				this.addChild(rect);
//				trace(rect.x,rect.y,rect.width,rect.height)
				
				
				var area:Area = new Area(this,$area[0],$area[1],$area[2],$area[3]);
				areas.push(area);
				area.addEventListener(CustomEvent.PIC_ADDED,onAreaEvent);
				area.addEventListener(CustomEvent.PIC_REMOVED,onAreaEvent);
				trace($area)
			}
			
			
		}
		
		public function reset():void{
			for each(var a:Area in areas){
				a.reset();
			}
		}
		
		public function preview():void{
			for each(var a:Area in areas){
				a.preview();
			}
		}
		
		public function preview_back():void{
			for each(var a:Area in areas){
				a.preview_back();
			}
		}
		
		
		private function onAreaEvent(e:CustomEvent):void{
			if(e.type == CustomEvent.PIC_ADDED){
				pic_add_count ++;
			}else{
				pic_add_count --;
			}
			
			if(pic_add_count == areas.length){
				Bar.getInstance().enableFinish(true);
			}else{
				Bar.getInstance().enableFinish(false);
			}
			
			if(pic_add_count > 0){
				Bar.getInstance().enablePreview(true);
			}else{
				Bar.getInstance().enablePreview(false);
			}
		}
		
		
	}
}