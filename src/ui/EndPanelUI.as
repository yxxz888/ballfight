/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class EndPanelUI extends View {
		public var _txtKill:Label;
		public var _txtTime:Label;
		public var btnOK:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":755,"height":475},"child":[{"type":"Image","props":{"y":-1,"x":0,"skin":"endpanel/endpanelbg.png"}},{"type":"Label","props":{"y":200,"x":383,"width":38,"var":"_txtKill","text":"0","strokeColor":"#990066","stroke":5,"height":18,"font":"Microsoft YaHei","color":"#FF66FF","bold":true,"align":"center"}},{"type":"Label","props":{"y":224,"x":374,"width":37,"var":"_txtTime","text":"00","strokeColor":"#990066","stroke":5,"height":18,"font":"Microsoft YaHei","color":"#FF66FF","bold":true,"align":"center"}},{"type":"Button","props":{"y":274,"x":338,"var":"btnOK","stateNum":1,"skin":"endpanel/endpanelbtnok.png"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}