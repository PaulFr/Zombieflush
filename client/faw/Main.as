package faw 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import fr.Bases.GlobalApp;
	import fr.General.Stats;
	import faw.ui.HUD;
	import faw.ui.Interface;
	import faw.ui.PersoSelector;
	
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class Main extends GlobalApp 
	{
		private var _interface:Interface;
		private var _persoSelector:PersoSelector;
		private var _pseudo:String;
		private var _sex:int;
		private var _game:Game;
		private var _mouse:TargetMouse;
		private var _loading:Loading;
		public var hud:HUD;
		
		public function Main() 
		{
			super();
			GlobalApp.GLOBAL_APPLICATION = this;
			
			this._interface = new Interface();
			this.addChild(this._interface);
			

			this._interface.btnSubmit.addEventListener(MouseEvent.CLICK, this.onPseudoSubmited);
		}
		
		private function onPseudoSubmited(e:MouseEvent):void {
			var pseudo:String = this._interface.pseudoInput.text;
			this.removeChild(this._interface);
			this._pseudo = pseudo;
			//this.initGame();
			this.initSelector();
		}
		
		private function initSelector():void {
			this._persoSelector = new PersoSelector();
			this._persoSelector.addEventListener("onSexSelected", initGame);
			this.addChild(this._persoSelector);
		}
		
		private function initGame(e:Event):void 
		{
			this._sex = this._persoSelector.sex;
			this.removeChild(this._persoSelector);
			
			this._game = new Game(this._pseudo, this._sex);
			this.addChild(this._game);
			
			
			this.hud = new HUD();
			this.hud.playerLife = 100;
			this.addChild(this.hud);
			
			this.addChild(new Stats());
			
			this._loading = new Loading();
			this.addChild(this._loading);
			this._game.addEventListener('onReady', onGameReady);
			
			//Gestion de la souris (target)
			Mouse.hide();
			this._mouse = new TargetMouse();
			this._mouse.scaleX = this._mouse.scaleY = 0.7;
			this._mouse.gotoAndStop(1);
			this._mouse.mouseEnabled = false;
			this.addChild(this._mouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoving);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseChangeState);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseChangeState);
			
			stage.focus = this;
		}
		
		private function onGameReady(e:Event):void 
		{
			this.removeChild(this._loading);
			this._loading = null;
		}
		
		private function onMouseChangeState(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_DOWN) {
				this._mouse.gotoAndStop(2);
			}else {
				this._mouse.gotoAndStop(1);
			}
		}
		
		private function onMouseMoving(e:MouseEvent):void 
		{
			this._mouse.x = e.stageX;
			this._mouse.y = e.stageY;
			e.updateAfterEvent();
		}
		
		public function get game():Game 
		{
			return _game;
		}
		
	}

}