package fr.Outils {
	import flash.net.SharedObject;
	
	public class CookieManager extends Object {
		private var Cookie;
		
		public function CookieManager(nomCookie:String):void {
			this.Cookie = SharedObject.getLocal(nomCookie);
		}
		
		public function lire(_get) {
			return this.Cookie.data[_get];
		}
		
		public function ecrire(_get,_set) {
			this.Cookie.data[_get] = _set;
			this.Cookie.flush();
		}
		
	}
}