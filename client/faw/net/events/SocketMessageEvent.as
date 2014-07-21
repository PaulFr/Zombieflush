package faw.net.events {
	import flash.events.Event;
	import faw.net.ServerRequest;
	
	public class SocketMessageEvent extends Event {
		public static var MESSAGE_SOCKET:String = "messageSocket";
		
		public var message:ServerRequest;
		public var t:int;
		public var st:int;
		
		public function SocketMessageEvent(typeEvt:String, message:ServerRequest, type:int = -1, subtype:int = -1) {
			if (type + subtype >= 0){
				this.t = type;
				this.st = subtype;
			}else {
				this.t = this.message.readShort();
				this.st = this.message.readShort();
			}
			this.message = message;
			super(typeEvt);
		}
	}
	
}