package 
{
	import laya.display.Sprite;
	import laya.display.Animation;
	import laya.maths.Point;
	import laya.utils.Handler;
	import laya.events.Event;
	import util.CommonUtil;

	/**
	 * ...
	 * @author
	 */
	public class Zombie extends Sprite{
		private var view:Animation;

		private var pivotPositions:Array = [
			new Point(51,103),
			new Point(35,102),
			new Point(59,97),
		];
		private var repeatCountByType:Array = [3,2,3];
		private var normalCountByType:Array = [3,4,4];
		
		private var _type:int = 0;
		private var _roadIndex:int = 0;
		
		private var speed:Number;
		
		private var isLoaded:Boolean = false;
		private var _isDead:Boolean = false;
		private var _canDispose:Boolean = false;
		
		public function Zombie()
		{
			view = new Animation();
		}
		
		
		public function setSpeed(speed:Number):void
		{
			this.speed = speed;
		}
		
		
		public function getSpeed():Number
		{
			return speed;
		}
		
		
		public function setType(type:int):void
		{
			this._type = type;
			view.loadAtlas("res/customatlas/monster" + _type + ".atlas",Handler.create(this,onLoadAtlas));
		}
		
		
		public function setRoadIndex(index:int):void
		{
			this._roadIndex = index;
		}
		
		
		public function getRoadIndex():int
		{
			return _roadIndex;
		}
		
		
		public function canDispose():Boolean
		{
			return _canDispose;
		}
		
		
		public function get type():int
		{
			return _type;
		}
		
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		
		public function isAlive():Boolean
		{
			return _isDead == false && _canDispose == false;
		}
		
		
		public function update():void
		{
			this.x -= speed;
		}
		
		
		public function dead():void
		{
			_isDead = true;

			view.once(Event.COMPLETE,this,function(){
				_canDispose = true;
			});
			view.play(0,false,"normaldead");
		}
		
		
		public function burn():void
		{
			_isDead = true;

			view.once(Event.COMPLETE,this,function(){
				_canDispose = true;
			});
			view.play(0,false,"bombdead");
		}


		private function onLoadAtlas():void
		{
			isLoaded = true;
			this.addChild(view);
			Animation.createFrames(CommonUtil.getUrls("monster" + _type + "/normal",normalCountByType[_type],repeatCountByType[_type]),"normal");
			Animation.createFrames(CommonUtil.getUrls("monster" + _type + "/normaldead",20),"normaldead");
			Animation.createFrames(CommonUtil.getUrls("monster" + _type + "/bombdead",25),"bombdead");		
			view.pivot(pivotPositions[_type].x,pivotPositions[_type].y);
			view.play(0,true,"normal");
		}
		
	}
}