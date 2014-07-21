package faw.net {
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import faw.net.ServerRequest;
	import faw.net.events.SocketMessageEvent;
	import faw.debug.events.DebugEvent;
	
	public class ServerSocket extends Socket {
		
		private var compteur:int;
		private var bufferPacket:ServerRequest;
		
		public function ServerSocket() {
			this.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDatas);
			this.addEventListener(Event.CLOSE, onSocketClosed);
			this.compteur = 0;
		}
		
		protected function onSocketClosed(e:Event):void 
		{
			
		}
		
		public function send(message:ServerRequest) {
			if(this.connected){
				message.position = 0;
				this.writeUnsignedInt(message.length+1); //+1 pour le byte du compteur
				this.writeByte(this.compteur++);
				if (compteur >= 255) compteur = 0;
				this.writeBytes(message, 0, message.length);
				this.flush();
			}
		}
		
		protected function debug(text:String) {
			this.dispatchEvent(new DebugEvent(DebugEvent.DEBUG, text));
		}
		
		public function dispatchThisEvent(e:Event) {
			this.dispatchEvent(e);
		}
		
		private function packetHandler(packet:ServerRequest) {
			packet.position = 0;
			var len:uint = packet.readUnsignedInt();

			var message:ServerRequest = new ServerRequest();
			while (message.position != len) {
				message.writeByte(packet.readByte());
			}
			
			if (packet.bytesAvailable > 0) {
				var otherPacket:ServerRequest = new ServerRequest();
				while (packet.bytesAvailable > 0) {
					otherPacket.writeByte(packet.readByte());
				}
				this.bufferingHandler(otherPacket);
			}
			
			message.position = 0;
			
			var type:int = message.readUnsignedShort();
			var subType:int = message.readUnsignedShort();
			
			this.dispatchThisEvent(new SocketMessageEvent(SocketMessageEvent.MESSAGE_SOCKET, message, type, subType));
		}
		
		private function bufferingHandler(packet:ServerRequest) {
			packet.position = 0;
			var len:uint = 0;
			if (this.bufferPacket == null) {
				len = packet.readUnsignedInt();
				if (packet.bytesAvailable >= len) {
					this.packetHandler(packet);
				}else {
					this.bufferPacket = new ServerRequest();
					this.bufferPacket.writeBinary(packet);
				}
			}else {
				this.bufferPacket.position = this.bufferPacket.length;
				this.bufferPacket.writeBinary(packet);
				this.bufferPacket.position = 0;
				var bufferSize:uint = this.bufferPacket.readUnsignedInt();
				var finalPacketSize:uint = bufferSize + 4;
				if (this.bufferPacket.bytesAvailable >= bufferSize) {
					var newPacket:ServerRequest = new ServerRequest();
					newPacket.writeBytes(this.bufferPacket, 0, finalPacketSize);
					this.bufferPacket.position = finalPacketSize;
					if (this.bufferPacket.bytesAvailable > 0) {
						var newBuffer:ServerRequest = new ServerRequest();
						newBuffer.writeBytes(this.bufferPacket, this.bufferPacket.position, this.bufferPacket.bytesAvailable);
						this.bufferPacket = null;
						this.bufferingHandler(newBuffer);
					}
					this.packetHandler(newPacket);
					this.bufferPacket = null;
				}
			}
			
		}
		
		private function onSocketDatas(e:ProgressEvent):void 
		{
			var bufferTemp:ServerRequest = new ServerRequest();
			while (this.connected && this.bytesAvailable > 0) {
				bufferTemp.writeByte(this.readByte());
			}
			this.bufferingHandler(bufferTemp);
		}
		
		override public function close():void {
			if (this.connected)
				super.close();
		}
		
		public function get Compteur():int {
			return this.compteur;
		}
		public function set Compteur(value:int):void {
			this.compteur = value;
		}
		
	}
	
}