package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import Module.*;
	import Module.Events.*;
	import fr.Interface.Ascenseur;
	import fr.Bases.GlobalApp;
	import Events.*;
	
	public class ClientChapatiz extends GlobalApp {
		private var servChapa:ServeurChapatiz;
		public var InterfaceClip:Interface;
		public var ulManager:UserListManager;
		public function ClientChapatiz() {
			trace('Client lancé');
			GlobalApp.GLOBAL_APPLICATION = this;
			ConnexionClip.addEventListener(ConnexionEvent.CONNEXION_OK, onConnexion);
		}
		
		private function onConnexion(e:ConnexionEvent):void 
		{
			ulManager = new UserListManager();
			ConnexionClip.Save();
			ConnexionClip.Supprime();
			this.InterfaceClip = new Interface();
			this.InterfaceClip.x = 32.0;
			this.InterfaceClip.y = 29.0;
			this.addChild(InterfaceClip);
			InterfaceClip.ecrireChat('<span class="info">Tentative de connexion au serveur...</span>');
			InterfaceClip.addEventListener(EnvoiSaisieEvent.REQUETE, onRequeteSaisie);
			InterfaceClip.addEventListener(EnvoiSaisieEvent.MESSAGE, onRequeteSaisie);
			InterfaceClip.addEventListener(Event.SELECT, onChangeRoom);
			servChapa = new ServeurChapatiz(e.Sid, e.Key);
			servChapa.addEventListener(TraceChatEvent.TRACE_CHAT, onTraceChat);
			servChapa.addEventListener(ConnecteUserEvent.CONNEXION, onUserConnexion);
			servChapa.addEventListener(ConnecteUserEvent.DECONNEXION, onUserConnexion);
			servChapa.addEventListener(ConnecteUserEvent.RESET_LIST, onUserConnexion);
		}
		
		private function onChangeRoom(e:ChangeRoomEvent):void 
		{
			this.servChapa.Send('<login rid="'+e.chimberg+'" force="1" />');
			this.servChapa.Send('<ready x="0" y="0" />');
			InterfaceClip.ecrireChat('<span class="info">Direction la room '+e.chimberg+"</span>");
		}
		
		private function onUserConnexion(e:ConnecteUserEvent):void 
		{
			if (e.type == ConnecteUserEvent.CONNEXION) {
				ulManager.addUsr(e.item);
			}else if(e.type == ConnecteUserEvent.DECONNEXION){
				ulManager.remUsr(e.item);
			}else if (e.type == ConnecteUserEvent.RESET_LIST) {
				ulManager.reset();
			}
			InterfaceClip.hydrateConnectes(ulManager.export());
		}
		
		private function onRequeteSaisie(e:EnvoiSaisieEvent):void 
		{	
			var infoMess:Object = new Object();
			switch(e.type) {
				case EnvoiSaisieEvent.MESSAGE:
					this.servChapa.Send('<c t="' + escape(e.Message).split('/').join('%2F') + '" />');
					infoMess.Pseudo = 'Moi';
					infoMess.Message = e.Message;
					infoMess.Type = 2;
					onTraceChat(infoMess);
				break;
				case EnvoiSaisieEvent.REQUETE:
					this.servChapa.Send(e.Message);
					infoMess.Message = 'Requête envoyée : ' + htmlspecialchars(e.Message);
					infoMess.Type = 0;
					onTraceChat(infoMess);
				break;
			}
		}
		
		private function htmlspecialchars(str) {
			return str.split("<").join("&lt;").split(">").join("&gt;");      
		}
		
		private function onTraceChat(e:*):void 
		{
			switch(e.Type) {
				case 0:
					InterfaceClip.ecrireChat('<span class="info">'+e.Message+'</span>');
				break;
				case 1:
					InterfaceClip.ecrireChat('<a class="pseudo">[' + e.Pseudo + ']</a><span class="message"> ' + htmlspecialchars(e.Message)+'</span>');
				break;
				case 2:
					InterfaceClip.ecrireChat('<a class="pseudo_spe">[' + e.Pseudo + ']</a> <span class="message">' + htmlspecialchars(e.Message)+"</span>");
				break;
				case 3:
					InterfaceClip.ecrireChat('<span class="info">'+e.Message+"</span>");
				break;
				case 4:
					InterfaceClip.ecrireReq(htmlspecialchars(e.Message));
				break;
				case 5:
					InterfaceClip.ecrireReq(htmlspecialchars(e.Message),1);
				break;
				case 6:
					InterfaceClip.ecrireChat('<a class="pseudomp">[MP DE ' + e.Pseudo + ']</a><span class="message"> ' + htmlspecialchars(e.Message)+'</span>');
				break;
			}
		}
	}
}