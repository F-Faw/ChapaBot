package Events {
	import flash.events.Event;
	
	public class ChangeRoomEvent extends Event {
		public var chimberg:String;
		public function ChangeRoomEvent(TypeEvent:String, Room:String) {
			super(TypeEvent);
			this.chimberg = Room;
		}
	}
	
}