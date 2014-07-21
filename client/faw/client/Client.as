package faw.client 
{
	import faw.net.ServerSocket;
	import flash.events.Event;
	import faw.net.events.SocketMessageEvent;
	import faw.net.ServerRequest;
	
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class Client extends ServerSocket 
	{
		protected var cid:int;
		public var ping:uint;
		
		public function Client() 
		{
			super();
			
		}
		
		override public function dispatchThisEvent(e:Event)
		{
			if (e.type == SocketMessageEvent.MESSAGE_SOCKET)
			{
				this.messageHandler(SocketMessageEvent(e).t, SocketMessageEvent(e).st, SocketMessageEvent(e).message);
			}
			super.dispatchThisEvent(e);
		}
		
		protected function messageHandler(type:int, subType:int, message:ServerRequest):void
		{
			/*switch (type)
			{
				case 0: 
					if (subType == 1)
					{
						this.debug('<span class="msg_special"><span class="sender_special">DEBUG ::</span> ' + message.readString() + '</span>');
					}
					break;
				case 1: 
					if (subType == 1)
					{
						this.debug(message.readString());
						this.close();
					}
					break;
				default:
					
					break;
			}*/
		}
	
	}

}