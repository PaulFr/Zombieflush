package faw.debug.events {
	import flash.events.Event;
	
	public class DebugEvent extends Event {
		
		public static var DEBUG:String = "debug";
		public var message:String;
		public function DebugEvent(type:String, message:*) {
			super(type);
			this.message = String(message);
		}
		
	}
	
}