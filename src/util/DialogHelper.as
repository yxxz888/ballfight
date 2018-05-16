package util
{
	import laya.display.Animation;
	import laya.maths.Rectangle;
	import laya.utils.Handler;
	import laya.events.Event;
	import util.DialogHelper;
	import laya.maths.Point;
	import laya.display.Sprite;

	/**
	 * ...
	 * @author
	 */
	public class DialogHelper{
		public function DialogHelper(){
			
		}


		public static function playDialogMV(atlasUrl:String,onPlayEnd:Handler = null):void
		{
			new DialogHelper().playMVInner(atlasUrl,onPlayEnd);
		}


		public static function playMV(atlasUrl:String,parent:Sprite,position:Point = null,pivot:Point = null,onPlayEnd:Handler = null):void
		{
			new DialogHelper().playMVInner2(atlasUrl,parent,position,pivot,onPlayEnd);
		}


		private var mv:Animation;
		private var onPlayEnd:Handler;
		private var parent:Sprite;
		private function playMVInner(atlasUrl:String,onPlayEnd:Handler = null):void
		{
			trace(atlasUrl);
			this.onPlayEnd = onPlayEnd;
			mv = new Animation();
			mv.hitArea = new Rectangle(0,0,755,475);
			mv.on(Event.CLICK,this,onClickMV);
			mv.loadAtlas(atlasUrl,Handler.create(this,onLoadedEndMV));
		}


		private function playMVInner2(atlasUrl:String,parent:Sprite,position:Point = null,pivot:Point = null,onPlayEnd:Handler = null):void
		{
			this.onPlayEnd = onPlayEnd;
			this.parent = parent;
			if(position == null)
				position = new Point(0,0);
			if(pivot == null)
				pivot = new Point(0,0);
			mv = new Animation();
			mv.x = position.x;
			mv.y = position.y;
			mv.pivot(pivot.x,pivot.y);
			mv.on(Event.CLICK,this,onClickMV);
			mv.loadAtlas(atlasUrl,Handler.create(this,onLoadedEndMV));
		}


		private function onClickMV(e:Event):void
		{
			e.stopPropagation;
		}

		private function onLoadedEndMV():void
		{
			trace("onLoadedEndMV");
			mv.once(Event.COMPLETE,this,onPlayEndMV);
			if(parent == null)
				parent = Laya.stage;
			parent.addChild(mv);
			mv.play();
		}

		private function onPlayEndMV():void
		{
			trace("onPlayEndMV");
			parent.removeChild(mv);
			mv.off(Event.CLICK,this,onClickMV);
			mv = null;

			if(onPlayEnd != null)
				onPlayEnd.run();
		}
	}
}