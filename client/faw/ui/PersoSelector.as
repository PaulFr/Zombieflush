package faw.ui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class PersoSelector extends MovieClip 
	{
		
		public function PersoSelector() 
		{
			super();
			face.gotoAndStop(0);
			ss.gotoAndStop(0);
			this.bl.addEventListener(MouseEvent.CLICK, onChangeSex);
			this.br.addEventListener(MouseEvent.CLICK, onChangeSex);
			
			this.bv.addEventListener(MouseEvent.CLICK, onSubmit);
		}
		
		private function onSubmit(e:MouseEvent):void 
		{
			this.dispatchEvent(new Event("onSexSelected"));
		}
		
		private function onChangeSex(e:Event):void 
		{
			var goTo:int = face.currentFrame == 1 ? 2 : 1;
			
			face.gotoAndStop(goTo);
			ss.gotoAndStop(goTo);
		}
		
		public function get sex():int {
			return face.currentFrame;
		}
		
	}

}