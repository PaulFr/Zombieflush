package faw.net {
	import flash.utils.ByteArray;
	import faw.datas.BinaryArray;
	
	public class ServerRequest extends BinaryArray {
		
		public function setBytes(byteArray:ByteArray) {
			byteArray.position = 0;
			while (byteArray.bytesAvailable > 0) {
				this.writeByte(byteArray.readByte());
			}
		}
		
		public function writeTypes(type:int, subType:int) {
			this.writeShort(type);
			this.writeShort(subType);
		}
		
	}
	
}