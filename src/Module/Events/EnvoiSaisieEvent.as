package Module.Events {
	import flash.events.Event;
	
	public class EnvoiSaisieEvent extends Event {
		public static var REQUETE:String = "req";
		public static var MESSAGE:String = "msg";
		public var Message:String;

		public function EnvoiSaisieEvent(TypeEvent:String, Message:String ) {
			super(TypeEvent);
			this.Message = Message;
		}
	}
	
}