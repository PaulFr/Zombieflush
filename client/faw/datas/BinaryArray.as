package faw.datas
{
	import flash.utils.ByteArray;
	import faw.utils.BinaryUtils;
	
	public class BinaryArray extends ByteArray
	{
		
		public function BinaryArray()
		{
			
		}
		
		public function writeString(string:String)
		{
			this.writeUnsignedInt(BinaryUtils.getStringLength(string));
			this.writeUTFBytes(string);
		}
		
		public function writeSomeBytes(nb:int, taille:int)
		{
			if (nb < 0)
				nb = 0;
			if (taille > 4)
				taille = 4;
			while (taille > 0)
			{
				this.writeByte((nb >> (--taille << 3) & 0xFF));
			}
		}
		
		public function readSomeBytes(taille:int):int
		{
			var output:int = 0;
			if (taille > 4)
				taille = 4;
			while (taille > 0)
			{
				output += this.readByte() << (--taille << 3);
			}
			return output;
		}
		
		public function readString():String
		{
			return this.readUTFBytes(this.readUnsignedInt());
		}
		
		public function readSignedInt():int
		{
			return (this.readBoolean() ? 1 : -1) * this.readUnsignedInt();
		}
		
		public function readColor():uint
		{
			return (this.readByte() & 0xFF) << 16 | (this.readByte() & 0xFF) << 8 | this.readByte() & 0xFF;
		}
		
		public function writeSignedInt(nb:int)
		{
			this.writeBoolean(nb >= 0);
			this.writeUnsignedInt(int(Math.abs(nb)));
		}
		
		public function writeBinaryDatas(datas:ByteArray)
		{
			this.writeUnsignedInt(datas.length);
			this.writeBytes(datas, 0, datas.length);
		}
		
		public function readBinaryDatas():BinaryArray
		{
			var ba:BinaryArray = new BinaryArray();
			ba.writeBytes(this, this.position, this.readUnsignedInt());
			ba.position = 0;
			return ba;
		}
		
		public function writeColor(color:uint):void
		{
			this.writeByte(color >> 16 & 255);
			this.writeByte(color >> 8 & 255);
			this.writeByte(color & 255);
		}
		
		public function writeBinary(binary:ByteArray)
		{
			this.writeBytes(binary, 0, binary.length);
		}
		
		public function writeNumber(number:Number)
		{
			var sNb:Array = String(number).split('.');
			if (sNb.length == 1)
				sNb.push(0);
			this.writeShort(int(sNb[0]));
			this.writeByte(int(sNb[1]));
		}
		
		public function readNumber():Number
		{
			var sNb:Array = [this.readShort(), this.readByte()];
			return Number(sNb.join('.'));
		}
		
		public function writeNByte(i:int) {
			this.writeBoolean(i >= 0);
			this.writeByte(Math.abs(i));
		}
		
		public function readNByte():int {
			return (this.readBoolean() ? 1: -1) * this.readByte();
		}
		
	
	}

}