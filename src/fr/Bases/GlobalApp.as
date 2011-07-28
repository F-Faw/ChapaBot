package fr.Bases {
	import flash.display.MovieClip;
	import flash.display.Stage;
	public class GlobalApp extends MovieClip {
		public static var GLOBAL_STAGE:Stage = null;
		public static var GLOBAL_APPLICATION:GlobalApp;
		
		public function GlobalApp() {
			if(GlobalApp.GLOBAL_STAGE == null){
				GlobalApp.GLOBAL_STAGE = stage;
			}else{
				trace('STAGE OK');
			}
		}
	}
}