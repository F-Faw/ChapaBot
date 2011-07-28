package Module.Events {
	import flash.events.Event;
	
	public class ConnexionEvent extends Event {
		public static var CONNEXION_OK:String = "connexionOK";
		public var Sid:String;
		public var Key:String;
		
		public function ConnexionEvent(TypeEvent:String, SID:String, KEY:String ) {
			super(TypeEvent);
			this.Sid = SID;
			this.Key = KEY;
		}
	}
	
}