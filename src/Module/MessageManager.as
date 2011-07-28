package Module {
	import flash.events.*;
	import Events.TraceChatEvent;
	import flash.xml.*;
	import Module.Events.*;
	import fr.Bases.GlobalApp;
	
	public class MessageManager extends EventDispatcher {
		private var servChapa:ServeurChapatiz;
		private var commandesManager:Commandes;
		
		public function MessageManager(Serv:ServeurChapatiz):void {
			this.servChapa = Serv;
			this.servChapa.addEventListener(DataEvent.DATA, this.traite);
			this.commandesManager = new Commandes(this.servChapa);
		}
		
		private function traite(e:DataEvent) {
			var Message:String = e.data;
			//trace('Reception de :: ' + Message);
			this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, Message, 5, 'Serveur'));
			var MessageXML:XMLDocument = new XMLDocument(Message.substr(0, Message.length - 1));
			var Action:String = MessageXML.firstChild.nodeName;
			switch(Action) {
				case 'punish':
					this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Vous avez été éjecté : '+MessageXML.firstChild.attributes.raison, 2, 'Serveur'));
				break;
				case 'roomps':
					this.dispatchEvent(new ConnecteUserEvent(ConnecteUserEvent.RESET_LIST, null));
					for each(var item:XMLNode in MessageXML.firstChild.childNodes) {
						if(item.nodeName == 'c' || item.nodeName == 'b'){
							this.dispatchEvent(new ConnecteUserEvent(ConnecteUserEvent.CONNEXION, item));
						}
					}
				break;
				case 'remusr':
					this.dispatchEvent(new ConnecteUserEvent(ConnecteUserEvent.DECONNEXION, MessageXML.firstChild));
				break;
				case 'addusr':
					this.dispatchEvent(new ConnecteUserEvent(ConnecteUserEvent.CONNEXION, MessageXML.firstChild));
				break;
				case 'pm':
					var auteurMP = new Array(); auteurMP['n'] = MessageXML.firstChild.attributes.fn;
						if (MessageXML.firstChild.attributes.t.charAt(0) == '!') {
							this.commandesManager.traite(MessageXML.firstChild.attributes.t.substr(1), auteurMP);
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Commande de la part de '+ auteurMP['n'] +' : '+ unescape(MessageXML.firstChild.attributes.t.substr(1)), 0, auteurMP['n']));
						}else{
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, unescape(MessageXML.firstChild.attributes.t), 6, auteurMP['n']));
						}
				break;
				case 'c':
					var auteurMsg = Object(GlobalApp.GLOBAL_APPLICATION).ulManager.getByI(MessageXML.firstChild.attributes.i);
					if (MessageXML.firstChild.attributes.t.charAt(0) == '!') {
						this.commandesManager.traite(MessageXML.firstChild.attributes.t.substr(1), auteurMsg);
						this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Commande de la part de '+ auteurMsg['n'] +' : '+ unescape(MessageXML.firstChild.attributes.t.substr(1)), 0, auteurMsg['n']));
					}else{
						this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, unescape(MessageXML.firstChild.attributes.t), 1, auteurMsg['n']));
					}
				break;
				case 'staticlist':
					for each(var itemRoom:XMLNode in MessageXML.firstChild.childNodes) {
						if(itemRoom.nodeName == 'r'){
							Object(GlobalApp.GLOBAL_APPLICATION).InterfaceClip.listeRooms.addItem( { label:itemRoom.attributes.id } );
						}
					}
				break;
				case 'roomlist':
					for each(var itemRoomD:XMLNode in MessageXML.firstChild.childNodes) {
						if(itemRoomD.nodeName == 'r'){
							Object(GlobalApp.GLOBAL_APPLICATION).InterfaceClip.listeRoomsDynamic.addItem( { label:itemRoomD.attributes.id } );
						}
					}
				break;
				case 'login':
					switch(int(MessageXML.firstChild.attributes.e)) {
						case 1:
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Vous êtes déjà dans cette salle',0,'Serveur'));
						break;
						case 2: 
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Erreur de connexion à cette salle',0,'Serveur'));
						break;
						case 3: 
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Impossible de se connecter à cette salle, elle n\'existe pas.',0,'Serveur'));
						break;
						case 4: 
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'L\'accès à cette salle ne t\'es pas permis.',0,'Serveur'));
						break;
						case 5: 
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Cette salle est déjà complète.',0,'Serveur'));
						break;
					}
				break;
				case 'user':
					if (MessageXML.firstChild.attributes.e == 1) {
						this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Vous ne pouvez pas vous connecter', 2, 'Serveur'));
						servChapa.close();
					}else{
						this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Vous êtes bien connecté en tant que ' + MessageXML.firstChild.attributes.p, 2, 'Serveur'));
						if (MessageXML.firstChild.attributes.attributes != '') {
							this.dispatchEvent(new TraceChatEvent(TraceChatEvent.TRACE_CHAT, 'Vous êtes officiel, certaines commandes supplémentaires vous sont donc disponibles.', 0, 'Client'));
						}
						this.servChapa.Send('<getstaticroomlist />');
						this.servChapa.Send('<login rid="central.game3" />');
						this.servChapa.Send('<ready x="-105" y="453" />');
						
					}
				break;
			}
		}
	}
	
}