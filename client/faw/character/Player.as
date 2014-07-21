package faw.character 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.geom.Point;
	import fr.Bases.GlobalApp;
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class Player extends Perso
	{
		private var _life:int;
		private var _shot:Shot;
		private var _shotTimer:Timer;
		private var _directions:Vector3D;
		public var id:int;
		
		public function Player() 
		{
			super();
			this.life = 100;
			this._directions = new Vector3D(0, 0);
			this._shotTimer = new Timer(50);
			this._shotTimer.addEventListener(TimerEvent.TIMER, onShotDone);
		}
		
		private function onShotDone(e:TimerEvent):void 
		{
			this._shotTimer.stop();
			this.mesh.removeChild(this._shot);
			this._shot = null;
		}
		
		public function get life():int 
		{
			return this._life;
		}
		
		public function setDirections(x:int, y:int) {
			this._directions.x = x;
			this._directions.y = y;
		}
		
		public function set life(value:int):void 
		{
			if (value < 0) value = 0;
			if (value > 100) value = 100;
			this._life = value;
			this.dispatchEvent(new Event("onLifeChanged"));
		}
		
		public function get directions():Vector3D 
		{
			return _directions;
		}
	
		
		public function gunShot() {
			if(this._shot == null){
				this._shot = new Shot();
				this._shot.x = 36.65;
				this._shot.y = 1.65;
				//this._shot.rotation = this.mesh.rotation;
				this.mesh.addChild(this._shot);
				this._shotTimer.start();
			}
		}
		
		public function update() {
			this.x += (this._directions.x * ((this._directions.y === 0) ? 8 : Math.sqrt(24))) /** (1/stage.frameRate)*/;
        	this.y += (this._directions.y * ((this._directions.x === 0) ? 8 : Math.sqrt(24))) /** (1/stage.frameRate)*/;
		}
		
		
	}

}