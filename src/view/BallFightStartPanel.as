package view
{
	import ui.BallFightStartPanelUI;
	import laya.events.Event;
	import view.BallFight;
	import laya.utils.Handler;
	import laya.ani.swf.MovieClip;

	/**
	 * ...
	 * @author
	 */
	public class BallFightStartPanel extends BallFightStartPanelUI{

		private var callback:Handler;

		public function BallFightStartPanel(callback:Handler){
			this.callback = callback;

			var mv:MovieClip = new MovieClip();
			 mv.load("res/swf/intromovie.swf",true);
//			mv.load("res/swf/1234.swf",true);
			spIntroMovieContainer.addChild(mv);

			btnOK.on(Event.CLICK,this,onClickOK);
		}
		

		private function onClickOK(e:Event):void
		{
			Laya.stage.removeChild(this);
			callback.run();
		}
	}
}