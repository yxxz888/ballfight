package 
{
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.utils.Handler;
	import laya.events.Event;
	import laya.maths.Point;
	import util.CommonUtil;

	/**
	 * ...
	 * @author
	 */
	public class Ball extends Sprite{
		private var view:Animation;
		
		private var pivotPositions:Array = [
			new Point(32.5,65),
			new Point(31.5,65),
		];

		private var _type:int = 0;
		private var _roadIndex:int = 0;
		
		private var isLoaded:Boolean = false;
		private var _canDispose:Boolean = false;
		private var _isDead:Boolean = false;
		
		public function Ball()
		{
			super();
			view = new Animation();
		}
		
		
		public function setType(type:int):void
		{
			this._type = type;
			view.loadAtlas("res/customatlas/ball" + _type + ".atlas",Handler.create(this,onLoadAtlas));
		}
		
		
		public function setRoadIndex(index:int):void
		{
			this._roadIndex = index;
		}
		
		
		public function getRoadIndex():int
		{
			return _roadIndex;
		}
		
		
		public function get canDispose():Boolean
		{
			return _canDispose;
		}
		
		
		public function set canDispose(value:Boolean):void
		{
			_canDispose = value;
		}
		
		
		public function get type():int
		{
			return _type;
		}
		
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		
		public function drop():void
		{
			view.play(0,true,"roll");
		}
		
		
		public function canRoll():Boolean
		{
			return _isDead == false && _canDispose == false;
		}
		
		
		public function bang():void
		{
			_isDead = true;

			view.once(Event.COMPLETE,this,function(){
				_canDispose = true;
			});
			view.play(0,false,"bomb");
		}

		
		private function onLoadAtlas():void
		{
			isLoaded = true;
			this.addChild(view);
			
			Animation.createFrames(CommonUtil.getUrls("ball" + _type + "/normal",1),"normal");
			Animation.createFrames(CommonUtil.getUrls("ball" + _type + "/roll",20),"roll");
			Animation.createFrames(CommonUtil.getUrls("ball" + _type + "/bomb",10),"bomb");		
			view.pivot(pivotPositions[_type].x,pivotPositions[_type].y);
			view.play(0,true,"normal");


			Animation.createFrames(["ball0/normal0.png","ball0/normal1.png","ball0/normal2.png"],"normal");
			view.play(0,true,"normal");
		}
	}
}