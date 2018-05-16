package mmo.app.ballfight
{
	import flash.display.MovieClip;
	
	public class Ball extends MovieClip
	{
		private var view:MovieClip;
		
		private var _type:int = 0;
		private var _roadIndex:int = 0;
		
		private var _canDispose:Boolean = false;
		private var _isDead:Boolean = false;
		
		public function Ball()
		{
			super();
			view = this;
			view.gotoAndStop(1);
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
			view.gotoAndStop(2);
		}
		
		
		public function canRoll():Boolean
		{
			return _isDead == false && _canDispose == false;
		}
		
		
		public function bang():void
		{
			_isDead = true;
			view.addFrameScript(view.totalFrames - 1,function(){
				view.addFrameScript(view.totalFrames - 1,null);
				view.gotoAndStop(view.totalFrames);
				
				_canDispose = true;
			});
			view.gotoAndPlay(3);
		}
	}
}