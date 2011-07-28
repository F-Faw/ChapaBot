package Module {
	import flash.events.EventDispatcher;
	import Module.*;
	import Module.Events.*;
	
	public class Commandes extends EventDispatcher {
		private var servChapa:ServeurChapatiz;
		private var jakenpoGame:JakenpoGame;
		private var mazoGame:MazoGame;
		public function Commandes(servChapa:ServeurChapatiz):void {
			this.servChapa = servChapa;
			jakenpoGame = new JakenpoGame(this.servChapa);
			mazoGame = new MazoGame(this.servChapa);
		}
		public function traite(commande:String, auteurCommande:Array):void {
			commande = unescape(commande.split('!').join(''));
			var action:Array = commande.split(' ');
			var params:String = commande.substr(action[0].length+1);
			trace(action[0]);
			switch(action[0]) {
				case 'parler':
					this.servChapa.Send('<c t="'+params+'" />');
				break;
				case 'game':
					if (JakenpoGame.jeuDispo) {
						this.jakenpoGame.playWith(auteurCommande);
						this.servChapa.Send('<c t="Je vais gagner '+auteurCommande['n']+', je suis le plus fort vv !" />');
					}else {
						if (JakenpoGame.joueurEnCours['i']) {
							this.servChapa.Send('<c t="'+escape('@'+auteurCommande['n']+' : Je m\'amuse avec '+JakenpoGame.joueurEnCours['n']+', patience')+'" />');
						}else {
							this.servChapa.Send('<c t="'+escape('@' + auteurCommande['n'] + ' : Patiente 10 petites secondes avant de jouer avec moi.')+'" />');
						}
					}
				break;
				case 'mazo':
					mazoGame.start(int(params));
				break;
				case 'hypermood':
					if (!params) {
						this.servChapa.Send("<fx id='01107' n='"+auteurCommande['n']+"' />");
					}else {
						this.servChapa.Send("<fx id='"+params+"' n='"+auteurCommande['n']+"' />");
					}
				break;
				case 'assis':
					this.servChapa.Send("<sm a='4'/>");
				break;
				case 'saute':
					this.servChapa.Send("<sm a='5'/>");
				break;
				case 'bouger':
				
				break;
				case 'goto':
					this.servChapa.Send('<login rid="' + action[1] + '" force="1" />');
					if ((action[2] + action[3]) > 0) {
						this.servChapa.Send('<ready x="' + int(action[2]) + '" y="'+action[3]+'" />');
					}else {
						this.servChapa.Send('<ready x="0" y="0" />');
					}
				break;
				case 'pos':
					this.servChapa.Send('<em a="'+action[1]+';'+action[2]+'" />');
				break;
			}
		}
	}
}