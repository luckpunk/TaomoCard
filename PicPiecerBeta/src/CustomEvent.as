package
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		
		
		public static var RESET:String = 'reset';
		public static var PREVIEW:String = 'preview';
		public static var PREVIEW_BACK:String = 'preview_back';
		public static var FINISH:String = 'finish';
				
		public static var PIC_ADDED:String = 'pic_added';
		public static var PIC_REMOVED:String = 'pic_removed';
		
		public function CustomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}