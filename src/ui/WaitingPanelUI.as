/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class WaitingPanelUI extends Dialog {
		public var _txtProgress:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Dialog","props":{"width":755,"height":475},"child":[{"type":"Label","props":{"y":202,"x":258,"width":239,"text":"游戏正在加载，请稍等……","height":30,"fontSize":20,"font":"Microsoft YaHei","color":"#ffffff","bold":true}},{"type":"Label","props":{"y":241,"x":336,"width":83,"var":"_txtProgress","text":"0%","height":28,"fontSize":18,"font":"Microsoft YaHei","color":"#ffffff","bold":true,"align":"center"}},{"type":"Rect","props":{"y":0,"x":0,"width":755,"lineWidth":1,"lineColor":"#000000","height":475,"fillColor":"#000000"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}