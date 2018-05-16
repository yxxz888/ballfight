package view
{
	import ui.EndPanelUI;
	import laya.events.Event;
	import laya.utils.Handler;

	/**
	 * ...
	 * @author
	 */
	public class EndPanel extends EndPanelUI{

		private var callback:Handler;

		public function EndPanel(killNum:int,passTime:int,callback:Handler){
			_txtKill.text = "" + killNum;
			_txtTime.text = "" + passTime;
			this.callback = callback;

			btnOK.once(Event.CLICK,this,onClickOK);

			Laya.stage.addChild(this);
		}


		private function onClickOK(e:Event):void
		{
			Laya.stage.removeChild(this);
			callback.run();
		}
	}
}