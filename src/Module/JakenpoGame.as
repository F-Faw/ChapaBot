package Module {
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.xml.*;
	import flash.events.*;
	
	public class JakenpoGame extends EventDispatcher {
		private var servChapa:ServeurChapatiz;
		public static var jeuDispo:Boolean;
		public static var joueurEnCours:Array;
		private var compteNouvellePartie:Timer = new Timer(10000);
		private var compteExpiration:Timer = new Timer(25000);
		private const PAPIER:int = 01420;
		private const PIERRE:int = 01422;
		private const CISEAU:int = 01421;
		
		public function JakenpoGame(servChapa:ServeurChapatiz):void {
			this.servChapa = servChapa;
			JakenpoGame.jeuDispo = true;
			compteNouvellePartie.addEventListener(TimerEvent.TIMER, onPartiePrete);
			compteExpiration.addEventListener(TimerEvent.TIMER, onPartieExpire);
		}
		
		private function onPartieExpire(e:TimerEvent):void 
		{
			this.servChapa.Send('<c t="Excuse moi, ' + JakenpoGame.joueurEnCours['n'] + ', mais je ne vais pas attendre toute la nuit pour jouer avec toi... !" />');
			this.removePlay();
		}
		
		private function onPartiePrete(e:TimerEvent):void 
		{
			this.removePlay();
		}
		
		public function playWith(Joueur:Array) {
			if (JakenpoGame.jeuDispo) {
				
				JakenpoGame.jeuDispo = false;
				JakenpoGame.joueurEnCours = Joueur;
				this.servChapa.addEventListener(DataEvent.DATA, onReception);
				compteExpiration.start();
				
			}
		}
		
		private function removePlay():void {
			JakenpoGame.joueurEnCours = new Array();
			JakenpoGame.jeuDispo = true;
			compteNouvellePartie.stop();
			compteNouvellePartie.reset();
			compteExpiration.stop();
			compteExpiration.reset();
		}
		
		private function onReception(e:DataEvent):void 
		{
			var Message:String = e.data;
			var MessageXML:XMLDocument = new XMLDocument(Message.substr(0, Message.length - 1));
			var Action:String = MessageXML.firstChild.nodeName;
			switch(Action) {
				case 'fx':
					if (MessageXML.firstChild.attributes.i == JakenpoGame.joueurEnCours['i']) {
						switch(int(MessageXML.firstChild.attributes.id)) {
							case PAPIER:
								this.servChapa.Send("<fx id='"+CISEAU+"' n='"+JakenpoGame.joueurEnCours['n']+"' />");
							break;
							case PIERRE:
								this.servChapa.Send("<fx id='"+PAPIER+"' n='"+JakenpoGame.joueurEnCours['n']+"' />");
							break;
							case CISEAU:
								this.servChapa.Send("<fx id='"+PIERRE+"' n='"+JakenpoGame.joueurEnCours['n']+"' />");
							break;
						}
						JakenpoGame.joueurEnCours = new Array();
						compteExpiration.stop();
						compteExpiration.reset();
						compteNouvellePartie.start();
					}
				break;
				case 'remusr':
					if (MessageXML.firstChild.attributes.i == JakenpoGame.joueurEnCours['i']) {
						this.removePlay()
					}
				break;
				case 'login':
					this.removePlay();
				break;
			} 
		}
		
	}
	
}