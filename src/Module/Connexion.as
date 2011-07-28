package Module {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.*;
	import Module.Events.ConnexionEvent;
	import com.adobe.crypto.*;
	import flash.external.*;
	import fr.Outils.CookieManager;
	import fr.Interface.InfoBulle;
	
	public class Connexion extends MovieClip {
		
		private var link:String = "http://webopload.net/getSidKey.php";
		private var tooltipMail:InfoBulle;
		private var tooltipPass:InfoBulle;
		
		public function Connexion() {
			tooltipMail = new InfoBulle("Entrez l'adresse e-mail de votre compte ici.", this.mail);
			tooltipPass = new InfoBulle("Entrez le mot de passe de votre compte ici même.", this.pass);
			this.mail.text = "Votre email...";
			this.pass.text = "Votre pass...";
			var cM:CookieManager = new CookieManager("ConnexionPerso");
			if (cM.lire('email')) {
				this.mail.text = cM.lire('email');
				this.pass.text = cM.lire('pass');
			}
			this.mail.addEventListener(MouseEvent.CLICK, onFocus);
			this.pass.addEventListener(MouseEvent.CLICK, onFocus);
			this.ValideConnexion.addEventListener(MouseEvent.CLICK, onConnexion);
		}
		
		private function onConnexion(e:MouseEvent):void 
		{
			if (this.mail.text != '' && this.mail.text != "Votre email..." && this.pass.text != '' && this.pass.text != "Votre pass...") {
				var requete:URLRequest = new URLRequest(this.link+"?keytime="+int(Math.random()*15020)+'&');
				requete.method = "get";
				var params:URLVariables = new URLVariables();
				params.email = this.mail.text;
				params.password = this.pass.text;
				requete.data = params;
				var loadVars:URLLoader = new URLLoader();
				loadVars.dataFormat = "variables";
				loadVars.load(requete);
				loadVars.addEventListener("complete", onGetSID);
			}else {
				this.mail.htmlText = '<font color="#ff0000">Remplissez correctement...</font>';
			}
		}
		
		private function onGetSID(e:Event):void 
		{
			try{
				e.currentTarget.removeEventListener("complete", onGetSID);
				var datas = e.currentTarget.data;
				this.dispatchEvent(new ConnexionEvent(ConnexionEvent.CONNEXION_OK, datas.SID, MD5.hash(datas.SID + "naz" + datas.KEY)));
			}catch (e:Error) {
				this.mail.htmlText = '<font color="#ff0000">Remplissez correctement...</font>';
			}
		}
		
		public function Save():void {
			var cM:CookieManager = new CookieManager("ConnexionPerso");
			cM.ecrire('email', this.mail.text);
			cM.ecrire('pass', this.pass.text);
		}
		
		private function onFocus(e:MouseEvent):void 
		{
			if (e.target.text == "Votre email..." || e.target.text == "Votre pass..." || e.target.text == "Remplissez correctement...") {
				e.target.htmlText = '<font color="#000000"></font>';
			}
		}
		
		public function Supprime():void {
			this.parent.removeChild(this);
		}
	}
}