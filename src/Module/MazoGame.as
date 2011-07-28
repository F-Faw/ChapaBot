package Module {
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.xml.*;
	import flash.events.*;
	
	public class MazoGame extends EventDispatcher {
		private var servChapa:ServeurChapatiz;
		public static var mazoEnCours:Boolean;
		private var attenteEntreDeux:Timer = new Timer(2011);
		private var scoreVoulu:int;
		private var currentScore:int;
		
		public function MazoGame(servChapa:ServeurChapatiz):void {
			this.servChapa = servChapa;
			MazoGame.mazoEnCours = false;
		}
		
		public function start(score:int = 1) {
			if (!MazoGame.mazoEnCours) {
				MazoGame.mazoEnCours = true;
				this.scoreVoulu = score;
				this.currentScore = 0;
				this.attenteEntreDeux.addEventListener(TimerEvent.TIMER, onMazote);
				this.servChapa.addEventListener(DataEvent.DATA, onReception);
				this.servChapa.Send('<c t="Allons-y pour '+this.scoreVoulu+' mazos !" />');
				attenteEntreDeux.start();
			}else {
				this.servChapa.Send('<c t="Je suis deja entrain de faire un score de '+this.scoreVoulu+' !" />');
			}
		}
		
		private function onMazote(e:TimerEvent):void 
		{
			if (this.currentScore != this.scoreVoulu) {
				this.servChapa.Send('<mazoshot />');
			}else {
				e.target.stop();
				e.target.removeEventListener(TimerEvent.TIMER, onMazote);
				this.servChapa.removeEventListener(DataEvent.DATA, onReception);
				this.servChapa.Send('<c t="Le score est atteint !" />');
				MazoGame.mazoEnCours = false;
			}
		}

		
		private function onReception(e:DataEvent):void 
		{
			var Message:String = e.data;
			var MessageXML:XMLDocument = new XMLDocument(Message.substr(0, Message.length - 1));
			var Action:String = MessageXML.firstChild.nodeName;
			switch(Action) {
				case 'mazoshot':
					this.currentScore = MessageXML.firstChild.attributes.s;
				break;
				
			} 
		}
		
	}
	
}