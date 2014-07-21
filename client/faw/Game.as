package faw 
{
	import faw.character.Zombie;
	import faw.character.Player;
	import faw.client.Client;
	import faw.net.events.SocketMessageEvent;
	import faw.net.ServerRequest;
	import faw.utils.DateUtils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import fr.Bases.GlobalApp;
	
	/**
	 * ...
	 * @author Paul Frinchaboy
	 */
	public class Game extends MovieClip 
	{
		private var _pseudo:String;
		private var _sex:int;
		private var _player:Perso;
		private var _keys:Array;
		private var _zombies:Vector.<Zombie>;
		private var _map:Map;
		public var players:Vector.<Player>;
		public var server:Client;
		private var _previousDir:Vector3D;
		private var _mapName:String;
		private var startAt:Date;
		private var endAt:Date;
		private var _timer:Timer;
		private var _lastShot:Date;
		
		public function Game(pseudo:String, sex:int) 
		{
			super();
			
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			
			this._lastShot = new Date();
			
			this._keys = new Array();
			
			this._previousDir = new Vector3D(0,0);
			
			this.mouseChildren = false;
			
			this._pseudo = pseudo;
			this._sex = sex;
			this.players = new Vector.<Player>();
			
			this._zombies = new Vector.<Zombie>();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onServerConnected(e:Event):void 
		{
			this._player = new Player();
			this._player.gotoAndStop(this._sex == 1 ? 1 : 3);
			this._player.pseudo.text = this._pseudo;
			this._player.x = stage.stageWidth / 2;
			this._player.y = stage.stageHeight / 2;
			this._player.addEventListener("onLifeChanged", onLifeChanged);
			
			var req:ServerRequest = new ServerRequest();
			req.writeTypes(1, 1);
			req.writeString(this._pseudo);
			req.writeBoolean(this._sex == 1);
			req.writeShort(this._player.x);
			req.writeShort(this._player.y);
			req.writeShort(this._player.mesh.rotation);
			req.writeNByte(this._player.directions.x);
			req.writeNByte(this._player.directions.y);
			this.server.send(req);
		}
		
		private function onLifeChanged(e:Event):void 
		{
			Main(GlobalApp.GLOBAL_APPLICATION).hud.playerLife = this._player.life;
		}
		
		private function onMessage(e:SocketMessageEvent):void 
		{
			trace('message:' + e.t + ';' + e.st);
			switch(e.t) {
				case 0:
					
					break;
				case 1:
					if (e.st == 1) {
						this.init();
						this._mapName = e.message.readString();
						Main(GlobalApp.GLOBAL_APPLICATION).hud.mapName.text = this._mapName;
						while (e.message.readBoolean()) {
							this.addPlayer(e.message);
						}
					}
					break;
				case 2:
					
					if (e.st == 1) {
						var type = e.message.readUnsignedShort();
						var player:Player = this.getPlayerById(e.message.readUnsignedShort());
						if (player == null) return;
						if (type == 1) {
							player.mesh.rotation = e.message.readShort();
						}else if (type == 2) {
							player.x = e.message.readShort();
							player.y = e.message.readShort();
						}else if (type == 3) {
							player.setDirections(e.message.readNByte(), e.message.readNByte());
						}
					}else if (e.st == 2) {
						var player:Player = this.getPlayerById(e.message.readUnsignedShort());
						this.removeChild(player);
						this.players.splice(this.players.indexOf(player), 1);
						player = null;
					}else if (e.st == 3) {
						this.addPlayer(e.message);
					}else if (e.st == 4) { //On bouge un zombie
						var zombie:Zombie = this.getZombieById(e.message.readUnsignedShort());
						zombie.life = e.message.readUnsignedShort();
						zombie.position.x = e.message.readSignedInt();
						zombie.position.y = e.message.readSignedInt();
						zombie.rotation = e.message.readUnsignedShort();
					}
					
					break;
				case 3:
					if (e.st == 1) {
						trace('Début de partie');
						
						startAt = DateUtils.parseUTCDate(e.message.readString());
						endAt = new Date();
						endAt.setTime(startAt.getTime() + 120000);
						this.startGameSession();
					}else if (e.st == 3) {
						var zombie:Zombie;
						while (e.message.readBoolean()) {
							
							var zId:int = e.message.readUnsignedShort();
							var zLife:int = e.message.readUnsignedShort();
							var zMass:int = e.message.readUnsignedShort();
							var zX = e.message.readSignedInt();
							var zY = e.message.readSignedInt();
							
							trace(zId, zLife, zMass, zX, zY);
							
							zombie = new Zombie(new Vector3D(zX, zY), zMass, zLife, zId);
							zombie.game = this;
							this.addChild(zombie);
							this._zombies.push(zombie);
							
						}
					}else if (e.st == 10) {
						this.getPlayerById(e.message.readUnsignedShort()).gunShot();
					}
					
					break;
				default:
					trace('Je ne sais que faire');
					break;
			}
		}
		
		private function startGameSession():void 
		{
			this._timer.reset();
			this._timer.start();
		}
		
		private function onTimerEvent(e:TimerEvent):void 
		{
			var now:Number = new Date().getTime();
			var time:Number = endAt.getTime() - now;
			if (time < 0) {
				trace('fin de partie detectée coté client');
				e.target.stop();
				return;
			}
			var secondes:int = (time / 1000)%60;
			var mins:int = (time / 60000) % 60;
			Main(GlobalApp.GLOBAL_APPLICATION).hud.temps.text = (mins < 10 ? "0" : "")+mins + ':' + (secondes < 10 ? "0" : "") + secondes;
		}
		
		private function addPlayer(infos:ServerRequest) {
			var nPlayer = new Player();
			nPlayer.id = infos.readUnsignedShort();
			nPlayer.pseudo.text = infos.readString();
			nPlayer.gotoAndStop(infos.readBoolean() ? 1 : 3);
			nPlayer.x = infos.readShort();
			nPlayer.y = infos.readShort();
			nPlayer.mesh.rotation = infos.readShort();
			nPlayer.setDirections(infos.readNByte(), infos.readNByte());
			this.addChild(nPlayer);
			this.players.push(nPlayer);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.server = new Client();
			this.server.connect("localhost", 5000);
			this.server.addEventListener(Event.CONNECT, onServerConnected);
			this.server.addEventListener(SocketMessageEvent.MESSAGE_SOCKET, onMessage);
			
			//this.init();
			
		}
		
		private function getPlayerById(id:int):Player {
			for (var p in this.players) {
				if (this.players[p].id == id) {
					return this.players[p];
				}
			}
			return null;
		}
		
		private function getZombieById(id:int):Zombie {
			for (var z in this._zombies) {
				if (this._zombies[z].id == id) {
					return this._zombies[z];
				}
			}
			return null;
		}
		
		
		private function updatePerso(type:int) {
			//1->angle, 2->pos, 3->directions
			var req:ServerRequest = new ServerRequest();
			req.writeTypes(2, 1);
			req.writeShort(type);
			if (type == 1) {
				req.writeShort(this._player.mesh.rotation);
			}else if (type == 2) {
				req.writeShort(this._player.x);
				req.writeShort(this._player.y);
			}else if (type == 3) {
				req.writeNByte(this._player.directions.x);
				req.writeNByte(this._player.directions.y);
			}

			this.server.send(req);
		}
		
		private function init() {
			
			this.dispatchEvent(new Event("onReady"));
			
			//Création de la map
			this._map = new Map();
			this._map.x = stage.stageWidth / 2;
			this._map.y = stage.stageHeight / 2;
			this.addChild(this._map);
			
			//Création du perso
			
			this.updatePerso(1);
			this.updatePerso(2);
			this.updatePerso(3);
			
			this.players.push(this._player);
			this.addChild(this._player);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoving);
			stage.addEventListener(MouseEvent.CLICK, onShot);
			
			this.addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		private function onShot(e:MouseEvent):void 
		{
			if (new Date().getTime() - this._lastShot.getTime() <= 500) return; //On tire pas de suite ;)
			
			this._lastShot = new Date();
			var mousePos:Point = new Point(e.stageX, e.stageY);
			var mouseLocalPos:Point = this.globalToLocal(mousePos);
			this._player.gunShot();
			var req:ServerRequest = new ServerRequest();
			req.writeTypes(3, 10);
			this.server.send(req);
		}
		
		private function onMouseMoving(e:MouseEvent):void 
		{
			var mousePos:Point = new Point(e.stageX, e.stageY);
			var mouseLocalPos:Point = this.globalToLocal(mousePos);
			
			var coords:Point = new Point(mouseLocalPos.x - this._player.x, mouseLocalPos.y - this._player.y);
			var rad:Number = Math.atan2(coords.y, coords.x);
			var deg:Number = rad * 180 / Math.PI;
			this._player.mesh.rotation = deg;
			
			this.updatePerso(1);
			
			e.updateAfterEvent();
		}
		
		private function gameLoop(e:Event):void 
		{
			var haut:Boolean = (this._keys[38] || this._keys[90]) && this._player.y >= -stage.stageHeight;
			var droite:Boolean = (this._keys[39] || this._keys[68]) && this._player.x <= this._map.width-stage.stageWidth;
			var bas:Boolean = (this._keys[40] || this._keys[83]) && this._player.y <= this._map.height-stage.stageHeight;
			var gauche:Boolean = (this._keys[37] || this._keys[81]) && this._player.x >= -stage.stageWidth;

			this._player.directions.x = gauche ? -1 : droite ? 1 : 0;
			this._player.directions.y = haut ? -1 : bas ? 1 : 0;
			
			if (this._previousDir.x != this._player.directions.x || this._previousDir.y != this._player.directions.y) {
				this.updatePerso(3);
				if ((this._previousDir.x != 0 && this._player.directions.x == 0) || (this._previousDir.y != 0 && this._player.directions.y == 0)) {
					this.updatePerso(2);
				}
				this._previousDir.x = this._player.directions.x;
				this._previousDir.y = this._player.directions.y;
			}
			
			for (var p in this.players) {
				this.players[p].update();
			}
			
			/*if ((this._keys[38] || this._keys[90]) && this._player.y >= -stage.stageHeight) {
				this._player.y -= 5;
			}
			if ((this._keys[39] || this._keys[68]) && this._player.x <= this._map.width-stage.stageWidth) {
				this._player.x += 5;
			}
			if ((this._keys[40] || this._keys[83]) && this._player.y <= this._map.height-stage.stageHeight) {
				this._player.y += 5;
			}
			if ((this._keys[37] || this._keys[81]) && this._player.x >= -stage.stageWidth) {
				this._player.x -= 5;
			}*/
			
			//cam
			var cam:Rectangle = new Rectangle(this._player.x - stage.stageWidth / 2, this._player.y - stage.stageHeight / 2, stage.stageWidth, stage.stageHeight);
			
			if (cam.x <= -stage.stageWidth)
				cam.x = -stage.stageWidth;
			if (cam.x >= this._map.width - stage.stageWidth - stage.stageWidth)
				cam.x = this._map.width - stage.stageWidth - stage.stageWidth;
			if (cam.y <= -stage.stageHeight)
				cam.y = -stage.stageHeight;
			if (cam.y >= this._map.height - stage.stageHeight - stage.stageHeight)
				cam.y = this._map.height - stage.stageHeight - stage.stageHeight;
			
			this.scrollRect = cam;
		}
		
		private function onKeyboardEvent(e:KeyboardEvent):void 
		{
			
			this._keys[e.keyCode] = e.type == KeyboardEvent.KEY_DOWN ? true : false;
		}
		
		/*private function addZombieWave(nb:int):void {
			this._zombies = new Vector.<Zombie>();
			var zombie:Zombie;
			var zombieZones:ZombieZones;
			for (var i:int = 0; i < nb; i++) {
				zombie  = new Zombie(new Vector3D(Math.random() * 800, Math.random() * 60), 10 + Math.random() * 10);
				zombie.game = this;
				zombie.rotation = Math.random() * 360;
				this.addChild(zombie);
				this._zombies.push(zombie);
			}
		}*/
		
		public function get zombies():Vector.<Zombie> 
		{
			return _zombies;
		}
		
		public function get map():Map 
		{
			return _map;
		}
		
	}

}