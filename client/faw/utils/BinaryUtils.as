package faw.utils {
	import flash.utils.ByteArray;
	import faw.datas.BinaryArray;
	
	public class BinaryUtils {
		
		public static function getStringLength(text:String):int {
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(text);
			return ba.length;
		}
		
	}
	
}