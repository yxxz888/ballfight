package mmo.app.ballfight
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mmo.common.ModalDialog;
	import mmo.common.dialog.NewDialog;
	import mmo.scenecommon.LoaderHelper;
	
	public class BallFightStartPanel extends MovieClip
	{
		public function BallFightStartPanel()
		{
			super();
			this.addEventListener(MouseEvent.CLICK,onClickThis);
		}
		
		
		private function onClickThis(evt:MouseEvent):void
		{
			switch(evt.target.name)
			{
				case "btnClose":
					dispose();
					break ;
				case "btnOK":
					dispose();
					NewDialog.getCustomDialog(new BallFight(),0,0).show()
					break ;
				case "btnExchange":
					new LoaderHelper().loadAndShowDialogAt00("factivity/romanticstreet","mmo.factivity.romanticstreet.RSExcPanel");
					break ;
			}
		}
		
		
		private function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK,onClickThis);
			ModalDialog.closeDialog(this);
		}
	}
}