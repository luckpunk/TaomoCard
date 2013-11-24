package
{
	import com.adobe.crypto.MD5;
	
	import flash.external.ExternalInterface;
	
	public class Params
	{
		
		
		
		public static var uid:uint;
		public static var img_type:String;
		public static var t:String;//token
		private static var _ts:Number;//timestamp
		//public static var upload_url:String = 'http://localhost:9999/upload/upload.php';
		public static var upload_url:String = 'http://localhost:1234';

		
		public static const KEY:String = 'c06ce179-9bfe-4ae2-ae67-42b8786699c9'; 

		
		public static var IMG_COUNT_LIMIT:uint = 20;
		public static var IMG_SIZE_LIMIT:uint = 20*1024*1024;
		
		
	
		
		
		public static function setParams(params:Object):void{
			
			if(!(params.t)) return; 
			t = params.t;
			img_type = params.img_type;
			uid = params.uid;
			upload_url = params.upload_url;
			
//			if(flash.external.ExternalInterface.available) {
//				ExternalInterface.call('console.log','ready');
//				ExternalInterface.call('console.log',t,img_type,uid,upload_url);
//			}
		}
				
		
		public static function addMD5():String{						
			return MD5.hash(t+'&'+img_type+'&'+_ts+'&'+KEY);
		}
		
		public static function get ts():Number{
			_ts = new Date().time;
			return _ts;
		}
	}
}