package 
{
	/**
	 * ...
	 * @author
	 */
	public class Test{

		public var a:int;

		public function Test(){
			a = 1;

			Laya.timer.loop(1000,this,showA);
		}


		private function inc():void
		{
			a++;
		}


		private function showA():void
		{
			trace(a);
			inc();
		}
	}
}