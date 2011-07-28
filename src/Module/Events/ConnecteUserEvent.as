package Module.Events {
	import flash.events.Event;
	import flash.xml.*;
	
	public class ConnecteUserEvent extends Event {
		public static var CONNEXION:String = "connexion";
		public static var DECONNEXION:String = "déconnexion";
		public static var RESET_LIST:String = "resetlist";
		public var item:XMLNode;
		
		public function ConnecteUserEvent(TypeEvent:String, Item:XMLNode ) {
			super(TypeEvent);
			this.item = Item;
		}
	}
	
}