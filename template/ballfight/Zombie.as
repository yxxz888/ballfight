package mmo.app.ballfight
{
	import flash.display.MovieClip;
	
	import mmo.scenecommon.DialogHelper;

	public class Zombie extends MovieClip
	{
		private var view:MovieClip;
		
		private var _type:int = 0;
		private var _roadIndex:int = 0;
		
		private var speed:Number;
		
		private var _isDead:Boolean = false;
		private var _canDispose:Boolean = false;
		
		public function Zombie()
		{
			view = this;
			view.gotoAndStop(1);
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
			view.x -= speed;
		}
		
		
		public function dead():void
		{
			_isDead = true;
			DialogHelper.addFrameScriptByFrameLabel(view,"ndEnd",function(){
				DialogHelper.addFrameScriptByFrameLabel(view,"ndEnd",null);
				
				view.gotoAndStop(view.totalFrames);
				_canDispose = true;
			});
			this.gotoAndPlay("nd");
		}
		
		
		public function burn():void
		{
			_isDead = true;
			DialogHelper.addFrameScriptByFrameLabel(view,"bdEnd",function(){
				DialogHelper.addFrameScriptByFrameLabel(view,"bdEnd",null);
				
				view.gotoAndStop(view.totalFrames);
				_canDispose = true;
			});
			view.gotoAndPlay("bd");
		}
	}
}