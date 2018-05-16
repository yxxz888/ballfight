/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class BallFightUI extends View {
		public var aniConveyer:FrameAnimation;
		public var _txtEnemy:TextArea;
		public var _txtTime:TextArea;
		public var _dropArea:Sprite;
		public var _container:Sprite;
		public var _conveyer:Sprite;
		public var _square:Image;
		public var _conveyerInner:Sprite;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":755,"height":475},"child":[{"type":"Image","props":{"y":0,"x":0,"skin":"ballfight/ballfightbg.png"}},{"type":"TextArea","props":{"y":441,"x":281,"width":42,"var":"_txtEnemy","type":"number","text":"0","strokeColor":"#874343","stroke":5,"multiline":false,"height":25,"fontSize":13,"font":"Microsoft YaHei","color":"#ff9900","align":"center"}},{"type":"TextArea","props":{"y":441,"x":420,"width":43,"var":"_txtTime","type":"number","text":"0","strokeColor":"#874343","stroke":5,"multiline":false,"height":25,"fontSize":13,"font":"Microsoft YaHei","color":"#ff9900","align":"center"}},{"type":"Sprite","props":{"y":2,"x":0,"var":"_dropArea","alpha":0},"child":[{"type":"Rect","props":{"y":136,"x":0,"width":192,"lineWidth":1,"height":325,"fillColor":"#ff0000"}}]},{"type":"Sprite","props":{"y":0,"x":0,"var":"_container"}},{"type":"Sprite","props":{"y":2,"x":0,"var":"_conveyer"},"child":[{"type":"Sprite","props":{"y":6.300000000000001,"x":9.5,"alpha":0.72},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":304.5,"lineWidth":1,"height":60.5,"fillColor":"#666666"}}]},{"type":"Animation","props":{"y":59,"x":6,"width":0,"height":0},"child":[{"type":"Image","props":{"y":0,"x":0,"skin":"ballfight/conveyerbottom1.png"},"compId":21}]},{"type":"Image","props":{"y":-2,"x":0,"var":"_square","skin":"ballfight/conveyersquare.png"}},{"type":"Sprite","props":{"y":6,"x":9,"var":"_conveyerInner"},"child":[{"type":"Sprite","props":{"y":0,"x":0,"alpha":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":305,"lineWidth":1,"height":53.8,"fillColor":"#ff0000"}}]}]}]}],"animations":[{"nodes":[{"target":21,"keyframes":{"x":[{"value":0,"tweenMethod":"linearNone","tween":true,"target":21,"key":"x","index":0},{"value":0,"tweenMethod":"linearNone","tween":true,"target":21,"key":"x","index":5},{"value":0,"tweenMethod":"linearNone","tween":true,"target":21,"key":"x","index":10}],"skin":[{"value":"ballfight/conveyerbottom1.png","tweenMethod":"linearNone","tween":false,"target":21,"key":"skin","index":0},{"value":"ballfight/conveyerbottom2.png","tweenMethod":"linearNone","tween":false,"target":21,"key":"skin","index":5},{"value":"ballfight/conveyerbottom1.png","tweenMethod":"linearNone","tween":false,"target":21,"key":"skin","index":10}]}}],"name":"aniConveyer","id":1,"frameRate":24,"action":0}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}