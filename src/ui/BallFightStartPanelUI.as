/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class BallFightStartPanelUI extends View {
		public var btnOK:Button;
		public var spIntroMovieContainer:Sprite;
		public var spMask:Sprite;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":755,"height":475},"child":[{"type":"Image","props":{"y":0,"x":0,"skin":"startpanel/startpanelbg.png"}},{"type":"Button","props":{"y":332,"x":334,"var":"btnOK","stateNum":1,"skin":"startpanel/startbutton.png"}},{"type":"Sprite","props":{"y":153,"x":256,"width":32,"var":"spIntroMovieContainer","height":32},"child":[{"type":"Sprite","props":{"y":0,"x":0,"var":"spMask","renderType":"mask"},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":290,"lineWidth":1,"height":180,"fillColor":"#ff0000"}}]}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}