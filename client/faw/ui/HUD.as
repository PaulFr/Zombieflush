package faw.ui 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class HUD extends MovieClip
	{
		
		public function HUD() 
		{
			super();
		}
		
		public function set playerLife(life:int) {
			this.lifeBar.scaleX = life / 100;
		}
		
	}

}