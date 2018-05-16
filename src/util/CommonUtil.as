package util
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.filters.GlowFilter;
	import laya.utils.Tween;
	import laya.utils.Handler;

	/**
	 * ...
	 * @author
	 */
	public class CommonUtil{

		public static function getRandomIndex(rate:Array):int
		{
			var result:int = 0;
			var totalRate:int = 0;
			for(var i:int = 0;i < rate.length;i++)
				totalRate += rate[i];
			var ri:int = Math.floor(Math.random() * totalRate);
			var curRate:int = 0;
			for(i = 0;i < rate.length;i++)
			{
				curRate += rate[i];
				if(ri < curRate)
				{
					result = i;
					break ;
				}
			}
			return result;
		}


		public static function showFadeText(str:String, x:Number, y:Number, container:Sprite=null):void
		{
			if(container == null)
				container = Laya.stage;

			var txPrompt:Text = new Text();
			txPrompt.color = "#ff0000";
			txPrompt.text = str;
			txPrompt.autoSize = "center";
			txPrompt.bold = true;
			txPrompt.fontSize = 20;
			txPrompt.font = "Microsoft YaHei";
			var glowFilter:GlowFilter = new GlowFilter("#ffffff", 20,5,5);
			txPrompt.filters = [glowFilter];
			txPrompt.x = x - txPrompt.width / 2;
			txPrompt.y = y;
			container.addChild(txPrompt);
			txPrompt.mouseEnabled = false;
			Tween.to(txPrompt, {"alpha":0, "y":txPrompt.y-30},3000,null,Handler.create(null,function(){
				if(txPrompt.parent != null)
					txPrompt.parent.removeChild(txPrompt);
			}));
		}


		public static function getUrls(name:String,length:int,repeat:int = 1):Array
		{
			var result:Array = [];
			for(var i:int = 0;i < length;i++)
			{
				var fullName:String = name + addFrontZero(i + 1);
					for(var j:int = 0;j < repeat;j++)
						result.push(fullName + ".png");
			}
			return result;
		}


		private static function addFrontZero(num:int,length:int = 4):String
		{
			var result:String = num.toString();
			while (result.length < length)
				result = 0 + result;
			return result;
		}
	}
}