package
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	/**
	 * 采用urlloader方式POST二进制数据
	 */
	public class Upload{
		
		private static var _loader:URLLoader;
		private static var _request:URLRequest;
				
		private static var _callback:Function;
		
		
		private static var _mask:Sprite;
		private static var _parent:DisplayObjectContainer;
		
		
		public static function addMask(parent:DisplayObjectContainer):void{
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000,0.5);
			_mask.graphics.drawRect(0,0,980,520);
			_mask.graphics.endFill();
			
			parent.addChild(_mask);
			_parent = parent;
		}
		
		private static function removeMask():void{
			if(_mask){
				_mask.graphics.clear();
				_mask = null;
				_parent.removeChild(_mask);
			}
		}
		
		
		public static function POST(bytes:ByteArray):void{
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			//var header:URLRequestHeader = new URLRequestHeader("Content-type",'multipart/form-data');
			
			_request = new URLRequest(Params.upload_url+'?t='+Params.t+'&uid='+Params.uid+'&img_type='+Params.img_type+'&ts='+Params.ts+'&s='+Params.addMD5());
			_request.requestHeaders.push(header);
			_request.method = URLRequestMethod.POST;
			//_request.contentType = "application/octet-stream";
			
			_request.data = bytes;
			
			if(!_loader){
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onComplete);
				_loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
				_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
			}
			
			_loader.load(_request);
		}
		
		
		
		
		private static function onComplete(e:Event):void{
			
			var result:Object  =com.adobe.serialization.json.JSON.decode(e.target.data);
			trace(result.result,result.reason)
			
			if(result.ok == true) {
				//ExternalInterface.call('uploadSucc',Params.img_type,result.data);
				log('UPLOAD_SUCC',{});
			}
			else {
				//ExternalInterface.call('uploadFail','',result);
				log('UPLOAD_FAIL',{});
			}
			
		}
		
		private static function onProgress(e:ProgressEvent):void{
			trace('progress===',e.bytesLoaded,e.bytesTotal);
			log('UPLOADING',e.bytesLoaded/e.bytesTotal);
			
		}
		
		private static function onError(e:*):void{
			trace(e)
			log('UPLOAD_FAIL',e.type);
			
			
		}
		
		private static function onStatus(e:HTTPStatusEvent):void{
			trace('status===',e.status);
		}
		
		
		private static function log(...args):void{
			if(flash.external.ExternalInterface.available){
				ExternalInterface.call('console.log',args)
			}else{
				trace(args)
			}
		}
		
		
	}
}