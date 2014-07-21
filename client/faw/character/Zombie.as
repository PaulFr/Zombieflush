package faw.character 
{
	import faw.Game;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import fr.Bases.GlobalApp;
	
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class Zombie extends MovieClip 
	{
		public var game:Game;
		
		/*private var _currentTarget:Perso;
		private var _position:Vector3D;
		private var _velocity:Vector3D;
		private var _steering:Vector3D;
		private var _mass:Number;
		private var _desired:Vector3D;
		private var _wanderAngle:Number;
		private var _ahead:Vector3D;
		private var _avoidance:Vector3D;
		private var _randomTarget:Vector3D;
		
		public var MAX_VELOCITY:Number = 5;
		public const MAX_FORCE:Number = 5.4;
		public const CIRCLE_DISTANCE:Number = 6;
		public const CIRCLE_RADIUS:Number = 8;
		public const ANGLE_CHANGE:Number = 1;*/
		
		private var _position:Vector3D;
		private var _mass:Number;
		private var _id:int;
		private var _life:int;
		
		public function Zombie(pos:Vector3D, mass:Number, life:int, id:int) 
		{
			super();
			this._position = pos;
			this._mass = mass;
			this._id = id;
			this._life = life;
			/*this._currentTarget = null;
			this._position = pos;
			
			//couleur
			var color = Math.random() * 0xFFFFFF;
			var colorT:ColorTransform = new ColorTransform(1, 1, 1, 1, (color >> 16 & 255) - 128, (color >> 8 & 255) - 128, (color & 255) - 128, 0);
			this.transform.colorTransform = colorT;
			
			this._velocity = new Vector3D( -1, -2);
			this._steering = new Vector3D(0, 0);
			this._desired = new Vector3D(0, 0);
			this._mass = mass;
			//this.MAX_VELOCITY = this.MAX_VELOCITY * (Math.random() + 0.1);
			this._wanderAngle = 0;
			
			this._randomTarget = null;*/
			this.x = this._position.x;
			this.y = this._position.y;
			this.addEventListener(Event.ADDED_TO_STAGE, onZombieAddedToStage);
		}
		
		/*private function setAngle(vector :Vector3D, value:Number):void {
			var len :Number = vector.length;
			vector.x = Math.cos(value) * len;
			vector.y = Math.sin(value) * len;
		}*/

		private function onZombieAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onZombieAddedToStage);
			//this.addEventListener(Event.ENTER_FRAME, zombieLoop);
		}
		
		/*private function seek(target:Vector3D) {
			this._desired = target.subtract(this._position);
			var distance:Number = this._desired.length;
			this._desired.normalize();
			if (distance <= 50) {
				this._desired.scaleBy(this.MAX_VELOCITY * distance/50);
			}else {
				this._desired.scaleBy(this.MAX_VELOCITY);
			}
			
			return this._desired.subtract(this._velocity);
		}
		
		private function distance(obj1:Object, obj2:Object):Number {
			return Math.sqrt(Math.pow(obj1.x - obj2.x, 2) + Math.pow(obj1.y - obj2.y, 2));
		}*/
		
		
		/*private function wander() {
			/*var circleCenter:Vector3D = this._velocity.clone();
			circleCenter.normalize();
			circleCenter.scaleBy(this.CIRCLE_DISTANCE);
			var displacement :Vector3D;
			displacement = new Vector3D(0, -1);
			displacement.scaleBy(this.CIRCLE_RADIUS);
			
			this.setAngle(displacement, this._wanderAngle);
			this._wanderAngle += Math.random() * this.ANGLE_CHANGE - this.ANGLE_CHANGE * .5;
			
			var wanderForce:Vector3D;
			wanderForce = circleCenter.add(displacement);
			return wanderForce;*/
			/*
			var minH:Number = -stage.stageHeight;
			var minW:Number = -stage.stageWidth;
			var maxH:Number = this.game.map.height - stage.stageHeight;
			var maxW:Number = this.game.map.width - stage.stageWidth;
			trace('minH:'+minH+';minW:'+minW+';maxH:'+maxH+';maxW:'+maxW+';');
			
			if (this._randomTarget == null || (this.distance(this._randomTarget, this) < 10 && Math.random() > .95)) {
				this._randomTarget = new Vector3D((maxW - minW) * Math.random() + minW, (maxH - minH) * Math.random() + minH);
			}
			return this.seek(this._randomTarget);
		}
		
		private function truncate(vector:Vector3D, nb:Number) {
			vector.scaleBy(nb/vector.length < 1 ? nb/vector.length : 1);
		}*/
		
		private function zombieLoop(e:Event):void 
		{
			/*var player:Perso;
			var distance:Number;
			
			//On détermine la cible
			for (var p in this.game.players) {
				player = this.game.players[p];
				distance = Math.sqrt(Math.pow(player.x - this.x, 2) + Math.pow(player.y - this.y, 2));

				if (this._currentTarget == null && distance <= 250) {
					this._currentTarget = player;
				}
				if (this._currentTarget != null && this._currentTarget != player && distance <= 105) {
					this._currentTarget = player;
				}
				if (this._currentTarget != null && this._currentTarget == player && distance >= 362) {
					this._currentTarget = null;
				}
				
				if (distance < 75) {
					player.life -= 0.1/100000;
				}
			}
			
			if (this._currentTarget != null) {
				this._steering = this.seek(new Vector3D(this._currentTarget.x, this._currentTarget.y));
			}else {
				this._steering = this.wander();
			}
			this.truncate(this._steering, this.MAX_FORCE);
			this._steering.scaleBy(1 / this._mass);
			this._velocity = this._velocity.add(this._steering);
			this.truncate(this._velocity, this.MAX_VELOCITY);
			this._position = this._position.add(this._velocity);
			
			
			
			this.x = this._position.x;
			this.y = this._position.y;
				
			//var coords:Point = new Point(this._currentTarget.x - this.x, this._currentTarget.y - this.y);
			//var rad:Number = Math.atan2(coords.y, coords.x);
			var rad:Number = Math.atan2(this._velocity.y, this._velocity.x);
			var deg:Number = rad * 180 / Math.PI;
			this.rotation = deg;*/
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get mass():Number 
		{
			return _mass;
		}
		
		public function set mass(value:Number):void 
		{
			_mass = value;
		}
		
		public function get position():Vector3D 
		{
			return _position;
		}
		
		public function set position(value:Vector3D):void 
		{
			_position = value;
		}
		
		public function get life():int 
		{
			return _life;
		}
		
		public function set life(value:int):void 
		{
			_life = value;
		}
		
	}

}