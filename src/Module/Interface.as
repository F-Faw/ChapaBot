package Module {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import fr.Interface.InfoBulle;
	import Module.Events.*;
	import fr.Interface.Ascenseur;
	import fr.Bases.GlobalApp;
	import Events.*;
	import fr.Interface.CheckCase;
	
	public class Interface extends MovieClip {
		private var scrollChat:Ascenseur;
		private var scrollConnectes:Ascenseur;
		private var scrollReq:Ascenseur;
		private var styleTexte:StyleSheet;
		private var modeBarre:CheckCase;
		private var tooltipMode:InfoBulle;
		
		public function Interface():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			scrollChat = new Ascenseur(Chat, 0xffffff, 0x0099FF, 0x00FFFF);
			scrollConnectes = new Ascenseur(Connectes, 0xffffff, 0x0099FF, 0x00FFFF);
			scrollReq = new Ascenseur(Req, 0xffffff, 0x0099FF, 0x00FFFF);
			Req.visible = false;
			scrollReq.alpha = 0;
			modeBarre = new CheckCase(95, 502);
			tooltipMode = new InfoBulle("Cochez cette case si vous souhaitez envoyer des données au serveur sous format brut (XML)", modeBarre);
			this.addChild(modeBarre);
			Envoi.addEventListener(MouseEvent.CLICK, onSendSaisie);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyInterface);
			listeRooms.addEventListener(Event.CHANGE, roomSelect); 
			styleTexte = new StyleSheet();
			styleTexte.setStyle('.info', { color:"#ff2fb6", fontStyle:"italic" } );
			styleTexte.setStyle('.rouge', { color:"#ff0000" } );
			styleTexte.setStyle('.pseudo', { color:"#008464", fontWeight:"bold" } );
			styleTexte.setStyle('.pseudomp', { color:"#6eaf20", fontWeight:"bold" } );
			styleTexte.setStyle('.pseudo_spe', { color:"#d67d00", fontWeight:"bold", textDecoration:"underline" } );
			styleTexte.setStyle('.or', { color:"#d67d00"});
			styleTexte.setStyle('.png', { color:"#ff7e03" } );
			styleTexte.setStyle('.message', { color:"#0075bd" } );
			Object(Chat).styleSheet = styleTexte;
			Object(Req).styleSheet = styleTexte;
		}
		
		private function roomSelect(e:Event):void 
		{
			this.dispatchEvent(new ChangeRoomEvent(Event.SELECT, e.target.selectedItem.label));
		}
		
		private function onKeyInterface(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13) {
				if (stage.focus == Saisie) {
					onSendSaisie(null);
				}
			}else if (e.keyCode == 82 && stage.focus != Saisie) {
				Req.visible = !Req.visible;
				scrollReq.alpha = int(Req.visible);
				Chat.visible = !Chat.visible;
				scrollChat.alpha = int(Chat.visible);
			}
		}
		
		private function onSendSaisie(e:MouseEvent):void 
		{
			if(Saisie.text != ''){
				var modeEnvoi = (modeBarre.checked) ? EnvoiSaisieEvent.REQUETE : EnvoiSaisieEvent.MESSAGE;
				this.dispatchEvent(new EnvoiSaisieEvent(modeEnvoi, Saisie.text));
				Saisie.text = '';
			}
		}
		
		public function hydrateConnectes(texte:String) {
			this.Connectes.text = '';
			this.Connectes.htmlText = texte;
			this.Connectes.dispatchEvent(new Event(Ascenseur.MAJ));
		}
		
		
		public function ecrireReq(req:String, type:int = 0) {
			var requete:String;
			if (type > 0) {
				requete = '<span class="or"><u>Reception</u> : '+req+'</span>';
			}else {
				requete = '<span class="info"><u>Envoie</u> : '+req+'</span>';
			}
			Req.htmlText += String(requete) + "\n";
			Req.dispatchEvent(new Event(Ascenseur.MAJ));
		}
		
		public function ecrireChat(texte):void {
			Chat.htmlText += String(texte) + "\n";
			Chat.dispatchEvent(new Event(Ascenseur.MAJ));
		}
	}
}