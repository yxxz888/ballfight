package {
	import view.BallFightStartPanel;
	import laya.webgl.WebGL;
	import laya.utils.Handler;
	import view.BallFight;
	import laya.display.Animation;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import util.DialogHelper;
	import util.CommonUtil;
	import laya.display.Stage;
	import laya.net.URL;
	import ui.WaitingPanelUI;
	import laya.display.Sprite;
	import laya.wx.mini.MiniAdpter;
	import laya.renders.Render;

	public class DocBallFight {
		
		private var waitingPanel:WaitingPanelUI;
		public function DocBallFight() {

			MiniAdpter.init();

			//初始化引擎
			Laya.init(755, 475);
			Laya.stage.bgColor = "#000000";
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;

			 URL.basePath = "https://ballfight-1256352381.cos.ap-guangzhou.myqcloud.com/";
			// URL.basePath = "https://ballfight-1256352381.cosgz.myqcloud.com/";
			// URL.basePath = "http://sinacloud.net/ballfight/";//load不到swf资源

			// loadResource();

			var ani:Animation = new Animation();
			ani.loadAtlas("res/customatlas/endmv.atlas");
			Laya.stage.addChild(ani);
		}		


		private function loadResource():void
		{
			var resource:Array = [
				"ballfight/ballfightbg.png",
				"endpanel/endpanelbg.png",
				"startpanel/startpanelbg.png",

				"res/atlas/startpanel.atlas",
				"res/atlas/endpanel.atlas",
				"res/atlas/ballfight.atlas",

				"res/customatlas/ball0.atlas",
				"res/customatlas/ball1.atlas",
				"res/customatlas/endmv.atlas",
				"res/customatlas/monster0.atlas",
				"res/customatlas/monster1.atlas",
				"res/customatlas/monster2.atlas",
				"res/customatlas/mvbigwave.atlas",
				"res/customatlas/mvbomb.atlas",

				"res/image/ballicon0.png",
				"res/image/ballicon1.png",
			];

			Laya.loader.load(resource,Handler.create(this,onComplete),Handler.create(this,onProgress,null,false));

			waitingPanel = new WaitingPanelUI();
			Laya.stage.addChild(waitingPanel);
		}


		private function onProgress(progress:Number):void
		{
			waitingPanel._txtProgress.text = Math.floor(progress * 100) + "%";
		}


		private function onComplete(isAllFinish:Boolean):void
		{
			if(isAllFinish == false)
				return ;
			
			waitingPanel._txtProgress.text = "加载完毕";
			Laya.stage.removeChild(waitingPanel);
			waitingPanel = null;
			showStartPanel();
		}


		private function showStartPanel():void
		{
			Laya.loader.load("res/atlas/startpanel.atlas",Handler.create(this,onLoaded));
		}


		private function onLoaded():void
		{
			var sp:BallFightStartPanel = new BallFightStartPanel(Handler.create(this,showGamePanel));
			Laya.stage.addChild(sp);
		}


		private function showGamePanel():void
		{
			Laya.loader.load("res/atlas/ballfight.atlas",Handler.create(this,onLoadedBallFight));
		}


		private function onLoadedBallFight():void
		{
			var game:BallFight = new BallFight(Handler.create(this,onLoaded));
			Laya.stage.addChild(game);
		}
	}
}