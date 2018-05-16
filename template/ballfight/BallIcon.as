package mmo.app.ballfight
{
	import flash.display.MovieClip;
	
	public class BallIcon extends MovieClip
	{
		private var _canDispose:Boolean = false;
		private var _type:int = 0;
		
		public function BallIcon()
		{
			super();
		}
		
		
		public function setType(type:int):void
		{
			this._type = type;
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
		
		
		public function pick():void
		{
			this.alpha = 0.5;
		}
		
		
		public function put():void
		{
			this.alpha = 1.0;
		}
	}
}