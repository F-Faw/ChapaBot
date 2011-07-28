package Events {
	import flash.events.Event;
	public class TraceChatEvent extends Event {
		public static var TRACE_CHAT:String = 'traceChat';
		public var Message:String;
		public var Type:int;
		public var Pseudo:String;
		
		public function TraceChatEvent(TypeEvent:String,Message:String,Type:int,Pseudo:String):void {
			super(TypeEvent);
			this.Message = Message;
			this.Type = Type;
			this.Pseudo = Pseudo;
		}
	}
}