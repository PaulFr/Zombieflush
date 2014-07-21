package faw.ui {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	
	public class Interface extends MovieClip {
		
		
		public function Interface() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.focus = this.pseudoInput;
			this.btnSubmit.addEventListener(MouseEvent.CLICK, this.onPseudoSubmited);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
		}
		
		private function onKeyboardEvent(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13) {
				this.btnSubmit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		private function onPseudoSubmited(e:MouseEvent):void 
		{
			var pseudo:String = this.pseudoInput.text;
			if (pseudo.length < 3 || pseudo.length > 10) {
				this.errorInput.text = 'Votre pseudo doit faire entre 3 et 10 caractères maximum';
				e.stopImmediatePropagation();
			}else {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			}
		}
	}
	
}
