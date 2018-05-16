package 
{
	import laya.display.Sprite;

	/**
	 * ...
	 * @author
	 */
	public class BallIcon extends Sprite{
		private var _canDispose:Boolean = false;
		private var _type:int = 0;
		
		public function BallIcon()
		{
			super();
		}
		
		
		public function setType(type:int):void
		{
			this._type = type;
			this.loadImage("res/image/ballicon" + _type + ".png");
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