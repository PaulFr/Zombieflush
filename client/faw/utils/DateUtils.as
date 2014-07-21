package faw.utils {
	
	
	public class DateUtils {
		
		public static function parseUTCDate( dateString : String ) : Date {
			if ( dateString == null ) 
				return null;    
			if ( dateString.length != 10 && dateString.length != 19) 
				return null;

			dateString = dateString.replace("-", "/");
			dateString = dateString.replace("-", "/");

			return new Date(Date.parse( dateString ));
		}
		
	}
	
}