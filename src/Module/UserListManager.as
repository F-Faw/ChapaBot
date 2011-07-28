package Module {
	import flash.events.*;
	import Events.*;
	import flash.xml.*;
	import Module.Events.*;
	
	public class UserListManager extends EventDispatcher {
		private var userList:Array;
		
		public function UserListManager():void {
			this.userList = new Array();
		}
		public function addUsr(item:XMLNode) {
			if (!getByI(item.attributes.i)) {
				var infoUser:Array = new Array();
				infoUser['i'] = item.attributes.i;
				infoUser['n'] = item.attributes.n;
				infoUser['mid'] = item.attributes.mid;
				infoUser['at'] = item.attributes.at;
				infoUser['type'] = item.nodeName;
				this.userList.push(infoUser);
			}
		}
		public function remUsr(item:XMLNode) {
			
			for (var j:int = 0; j < this.userList.length; j++) {
				if (this.userList[j]['i'] == item.attributes.i) {
					this.userList.splice(j,1);
				}
			}
			
		}
		
		public function getByI(Id:String):* {
			for (var i:int = 0; i < this.userList.length; i++) {
				if (this.userList[i]['i'] == Id) {
					return this.userList[i];
				}
			}
			return false;
		}
		
		public function reset() {
			this.userList = new Array();
		}
		
		public function colorPseudo(pseudo:String, type) {
			var pseudo_colore:String;
			if (type == 'b') {
				pseudo_colore = '<font color="#ff7e03"><b>'+pseudo+'</b> [PNJ]</font>';
			}else if (type == 5) {
				pseudo_colore = '<font color="#666666"><b>'+pseudo+'</b> [Def]</font>';
			}
			else if (type == 1) {
				pseudo_colore = '<font color="#ff0000"><b>'+pseudo+'</b> [MT]</font>';
			}
			else if (type == 2) {
				pseudo_colore = '<font color="#0963ca"><b>'+pseudo+'</b> [MBBS]</font>';
			}
			else if (type == 3) {
				pseudo_colore = '<font color="#9b20b3"><b>'+pseudo+'</b> [ChzFan]</font>';
			}
			else if (type == 4) {
				pseudo_colore = '<font color="#d4c100"><b>'+pseudo+'</b> [RT]</font>';
			}
			else if (type == 6) {
				pseudo_colore = '<font color="#d34c00"><b>'+pseudo+'</b> [Anim]</font>';
			}
			else if (type == 7) {
				pseudo_colore = '<font color="#0f8a00"><b>'+pseudo+'</b> [Helpz]</font>';
			}else {
				pseudo_colore = pseudo;
			}
			return pseudo_colore;
		}
	
		public function export() {
			var resultat:String = "";
			for (var e:int = 0; e < this.userList.length; e++) {
				if (this.userList[e] != null) {
					resultat += colorPseudo(this.userList[e]['n'],((this.userList[e]['type'] == 'b') ? this.userList[e]['type'] : this.userList[e]['at']))+"\n";
				}
			}
			return resultat;
		}
	}
	
}