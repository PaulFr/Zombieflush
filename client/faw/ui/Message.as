package faw.ui {
	
	
	public class Message extends Object {
		
		private var _isPrivateMessage:Boolean;
		private var _isModerator:Boolean;
		private var _isSpecial:Boolean;
		private var _sender:String;
		private var _text:String;
		private var _senderClientId:uint;
		private var _senderUserId:uint;
		
		public function Message() {
			this._isPrivateMessage = this._isModerator = this._isSpecial = false;
			this._sender = this._text = '';
			this._senderClientId = this._senderUserId = 0;
		}
		
		public function set isPrivateMessage(bool:Boolean) {
			this._isPrivateMessage = bool;
		}
		
		public function set isModerator(bool:Boolean) {
			this._isModerator = bool;
		}
		
		public function set isSpecial(bool:Boolean) {
			this._isSpecial = bool;
		}
		
		public function set sender(value:String) {
			this._sender = value;
		}
		
		public function set text(value:String) {
			this._text = value;
		}
		
		public function set senderClientId(value:uint) {
			this._senderClientId = value;
		}
		
		public function set senderUserId(value:uint) {
			this._senderUserId = value;
		}
		
		public function get isPrivateMessage():Boolean {
			return this._isPrivateMessage;
		}
		
		public function get isModerator():Boolean {
			return this._isModerator;
		}
		
		public function get isSpecial():Boolean {
			return this._isSpecial;
		}
		
		public function get isUser():Boolean {
			return (this._senderClientId + this._senderUserId > 0);
		}
		
		public function get sender():String {
			return this._sender;
		}
		
		public function get text():String {
			return this._text;
		}
		
		public function get senderClientId():uint {
			return this._senderClientId;
		}
		
		public function get senderUserId():uint {
			return this._senderUserId;
		}
		
		public function get formatedMessage():String {
			var text:String = '';
			text += '<span class="msg' + ((this._isModerator) ? '_moderator' : '') + ((this._isPrivateMessage) ? '_private_message' : '') + ((this._isSpecial) ? '_special' : '') + '">';
			if (this._senderClientId + this._senderUserId > 0)
				text += '<a href="event:user;'+this._sender+';'+this._senderClientId+';'+this._senderUserId+'">';
			text += '<span class="sender' + ((this._isModerator) ? '_moderator' : '') + ((this._isPrivateMessage) ? '_private_message' : '') + ((this._isSpecial) ? '_special' : '') + '">[' + ((this._isModerator) ? 'Modo ' : ((this._isPrivateMessage) ? 'MP de ' : '')) + this._sender + ']</span> ';
			if (this._senderClientId + this._senderUserId > 0)
				text += '</a>';
			text += this._text;
			text += '</span>';
			return text;
		}
		
		
	}
	
}