package {
	import flash.display.*;
	import flash.events.*;
	import fr.Bases.GlobalApp;
	import flash.net.*;
	import Events.*;
	import Module.MessageManager;
	import Module.Events.*;
	import com.adobe.crypto.MD5;
	
	public class ServeurChapatiz extends XMLSocket {
		private var Sid:String;
		private var Key:String;
		private var Compteur:int = 0;
		private var messageManager:MessageManager;
		
		public function ServeurChapatiz(SID:String, KEY:String) {
			this.Sid = SID;
			this.Key = KEY;
			this.connect("chat.chapatiz.com", 9299);
			//this.connect("95.131.137.52", 9299);
			this.addEventListener(Event.CLOSE, onDeconexion);
            this.addEventListener(Event.CONNECT, onConnexion);
            this.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			messageManager = new MessageManager(this);
			messageManager.addEventListener(TraceChatEvent.TRACE_CHAT, onManagerTraceChat);
			messageManager.addEventListener(ConnecteUserEvent.CONNEXION, onManagerUserConnexion);
			messageManager.addEventListener(ConnecteUserEvent.DECONNEXION, onManagerUserConnexion);
			messageManager.addEventListener(ConnecteUserEvent.RESET_LIST, onManagerUserConnexion);
		}
		
		private function onManagerUserConnexion(e:ConnecteUserEvent):void 
		{
			this.dispatchEvent(new ConnecteUserEvent(e.type, e.item));
		}
		
		private function onManagerTraceChat(e:TraceChatEvent):void 
		{
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT,e.Message,e.Type,e.Pseudo));
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Un problème de sécurité bloque la connexion', 2, 'Client'));
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Une IOError bloque la connexion', 2, 'Client'));
		}
		
		
		private function onConnexion(e:Event):void 
		{
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'La connexion a réussi', 3, 'Client'));
			this.Send('<newauth sid="' + this.Sid + '" k="' + this.Key + '" />');
			//this.Send('<newauth sid="1064708" k="' + MD5.hash("1064708naz") + '" />');
		}
		
		private function onDeconexion(e:Event):void 
		{
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'La connexion a été intérrompue', 3, 'Client'));
		}

		
		public function Send(Requete:*):void {
			this.send(Requete + String(Compteur));
			Compteur++;
			//trace('Envoi de : ' + Requete);
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, Requete, 4, 'Client'));
		}
		
	}
}