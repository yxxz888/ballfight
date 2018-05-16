package view
{
	import ui.BallFightUI;
	import laya.maths.Point;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.ani.swf.MovieClip;
	import laya.ui.DialogManager;
	import laya.display.Animation;
	import laya.maths.Rectangle;
	import util.DialogHelper;
	import view.EndPanel;
	import util.CommonUtil;
	import laya.display.Sprite;

	/**
	 * ...
	 * @author
	 */
	public class BallFight extends BallFightUI{

		private var callback:Handler;

		private var roadYs:Array = [205,285,370,450];
		private var roadBorder:Array = [135,213,297,381,459];
		
		private var _conveyerInnerWidth:Number;
		private var iconSpeed:Number = 2.0;
		private var ballSpeed:Number = 2.0;
		private var zombieSpeed:Number = 0.7;
		private var createIconCounter:int = 0;
		// private var createIconInterval:int = 1.6 * 60;
		private var createIconIntervals:Array = [1.5 * 60,3.0 * 60];
		private var createZombieCounter:int = 0;
		private var timeCounter:int = 0;
		private var passTime:int = 0;
		private var ballWidth:Number = 57.6;
		private var bombWidth:Number = ballWidth * 4;
		private var maxIconNum:int = 15;

		private var difficultyTime:int = 60;//秒。N秒后达到最高难度
		private var difficultyLevelTime:int = 10;//秒.每N秒提高一次难度

		private var zombieRate:Array = [
			[1,0,0],
			[2,3,0],
			[1,1,0],
			[2,2,1],
			[2,2,1],
			[1,1,1],
		];
		
		// private var zombieInterval:Array = [1.5 * 60,2 * 60,1 * 60,2 * 60,2 * 60,1 * 60];
		private var zombieInterval:Array = [2 * 60,1 * 60];
		private var zombieSpeedFactor:Array = [1,1.2,1.5];
		
		private var icons:Array = [];
		private var balls:Array = [];
		private var zombies:Array = [];
		
		private var killNums:Array = [0,0,0];
		private var lastKillNum:int = 0;
		
		private var downPoint:Point;
		
		private var curBall:Ball = null;
		private var curBallIcon:BallIcon = null;
		private var isPickIcon:Boolean = false;
		private var lastDownIcon:Boolean = false;
		private var isWin:Boolean = false;
		private var isPause:Boolean = false;

		public function BallFight(callback:Handler){
			
			this.callback = callback;
			
			aniConveyer.play();

			_conveyerInnerWidth = _conveyerInner.getBounds().width;

			//用clipRect方法实现遮罩效果
			_conveyer.graphics.clipRect(0,0,_square.width,_square.height);

			startGame();
		}	
		
		
		private function startGame():void
		{
			this.on(Event.CLICK,this,onClickThis);
			Laya.timer.frameLoop(1,this,onEnterFrame);
			this.on(Event.KEY_UP,this,onKeyUpThis);
			this.on(Event.MOUSE_UP,this,onUpThis);

			Laya.timer.once(2000,this,endGame);
		}


		private function onKeyUpThis(evt:Event):void
		{
			if(isPause)
				return ;
			
			var keyCode:int = evt.keyCode;
			if(keyCode >= 49 && keyCode <= 57)
			{
				if(isPickIcon)
					return ;
				
				var index:int = keyCode - 49;
				if(icons[index] != null)
				{
					curBallIcon = icons[index];
					handlePick();
				}
			}
		}			
		
		
		private function onEnterFrame(evt:Event):void
		{
			if(isPause)
				return ;
			
			createIcons();
			
			updateIcons();
			
			handleReadyBall();
			
			updateBalls();
			
			createZombies();
			
			updateZombies();
			
			updateTime();
		}	
						
		
		private function createIcons():void
		{
			if(icons.length >= maxIconNum)
				return ;
			
			var rate:Number = passTime / difficultyTime;
			var createIconInterval:int = createIconIntervals[0] + (createIconIntervals[1] - createIconIntervals[0]) * rate;
			if(++createIconCounter >= createIconInterval)
			{
				createIconCounter = 0;
				var ri:int = Math.floor(Math.random() * 2);
				var icon:BallIcon = new BallIcon();
				icon.setType(ri);
				var lastIcon:MovieClip = icons[icons.length - 1];
				if(lastIcon != null && lastIcon.x + lastIcon.width >= _conveyerInnerWidth)
					icon.x = lastIcon.x + lastIcon.width + 2;
				else
					icon.x = _conveyerInnerWidth;
				_conveyerInner.addChild(icon);
				icon.on(Event.CLICK,this,onClickIcon);
				icon.on(Event.MOUSE_DOWN,this,onDownIcon);
				icons.push(icon);
			}
		}		
		
		
		private function updateIcons():void
		{
			var i:int = 0;
			var targetXs:Array = [];
			for(i = 0;i < icons.length;i++)
			{
				if(i > 0)
					targetXs[i] = targetXs[i - 1] + icons[i - 1].width;
				else
					targetXs[i] = 0;
			}
			for(i = icons.length - 1;i >= 0;i--)
			{
				var icon:BallIcon = icons[i] as BallIcon;
				if(icon.canDispose)
				{
					icon.off(Event.CLICK,this,onClickIcon);
					icon.off(Event.MOUSE_DOWN,this,onDownIcon);
					_conveyerInner.removeChild(icon);
					icons.splice(i,1);
				}
				else if(icon.x - targetXs[i] < iconSpeed)
					icon.x = targetXs[i];
				else
					icon.x -= iconSpeed;
			}
		}		
		
		
		private function handleReadyBall():void
		{
			if(isPickIcon == false)
				return ;
			
			curBall.x = mouseX;
			curBall.y = mouseY;
			if(_dropArea.hitTestPoint(curBall.x,curBall.y))
			{
				curBall.alpha = 1.0;
			}
			else
			{
				curBall.alpha = 0.5;
			}
		}
		
		
		private function onClickIcon(evt:Event):void
		{
			if(isPickIcon)
				return ;

			evt.stopPropagation();
			curBallIcon = evt.currentTarget as BallIcon;
			handlePick();
		}	
		
		
		private function onDownIcon(evt:Event):void
		{
			if(isPickIcon)
				return ;
			
			evt.stopPropagation();
			lastDownIcon = true;
			downPoint = new Point(mouseX,mouseY);
			curBallIcon = evt.currentTarget as BallIcon;
			handlePick();
		}			
		
		
		private function onUpThis(evt:Event):void
		{
			if(isPickIcon == false)
				return ;
			
			if(downPoint == null)
				return ;
			
			if(downPoint.distance(mouseX,mouseY) > 10)
			{
				downPoint = null;
				checkDropBall();
			}
		}	
		
		
		private function handlePick():void
		{
			isPickIcon = true;
			curBallIcon.pick();
			curBall = new Ball();
			curBall.setType(curBallIcon.type);
			this.addChild(curBall);
		}		
		
		
		private function onClickThis(evt:Event):void
		{
			if(isPause)
				return ;
			
			if(lastDownIcon)//当次拖曳动作的下一个点击不生效
			{
				lastDownIcon = false;
				return ;
			}
			else if(checkDropBall())
				return ;
		}	
				
		
		private function checkDropBall():Boolean
		{
			if(isPickIcon == false)
				return false;
			
			if(_dropArea.hitTestPoint(mouseX,mouseY))
			{
				dropBall();
			}
			else
			{
				CommonUtil.showFadeText("不可以放在这里哦~",755 / 2,475 / 2,this);
				putBackBall();
			}
			return true;
		}		
		
		
		private function dropBall():void
		{
			curBall.alpha = 1.0;
			var index:int = 0;
			for(var i:int = 0;i < roadBorder.length - 1;i++)
			{
				if(mouseY >= roadBorder[i] && mouseY < roadBorder[i + 1])
				{
					index = i;
					break ;
				}
			}
			curBall.x = mouseX;
			curBall.y = roadYs[index];
			curBall.setRoadIndex(index);
			_container.addChild(curBall);
			balls.push(curBall);
			curBall.drop();
			
			curBallIcon.canDispose = true;
			curBall = null;
			isPickIcon = false;
		}
		
		
		private function putBackBall():void
		{
			curBallIcon.put();
			this.removeChild(curBall);
			curBall = null;
			isPickIcon = false;
		}
		
		
		private function updateBalls():void
		{
			for(var i:int = balls.length - 1;i >= 0;i--)
			{
				var ball:Ball = balls[i] as Ball;
				if(ball.canDispose)
				{
					_container.removeChild(ball);
					balls.splice(i,1);
				}
				else if(ball.canRoll())
					ball.x += ballSpeed;
				
				for(var j:int = zombies.length - 1;j >= 0;j--)
				{
					var z:Zombie = zombies[j] as Zombie;
					if(z.getRoadIndex() == ball.getRoadIndex() && z.isAlive() && Math.abs(z.x - ball.x) <= ballSpeed + z.getSpeed())
					{
						ball.bang();
						if(ball.type == 0)
						{
							z.dead();
							killEnemy(z.type);
						}
						else
						{
							handleBomb(ball.x,ball.y,ball.getRoadIndex());
						}
					}
				}
			}
		}	
		
		
		private function createZombies():void
		{
			var rate:Number = passTime / difficultyTime;
			var timeInterval:int = zombieInterval[0] + (zombieInterval[1] - zombieInterval[0]) * rate;
			if(++createZombieCounter >= timeInterval)
			{
				createZombieCounter = 0;
				createZombie();
			}
		}	


		private function createZombie():void
		{
			var timeIndex:int = Math.floor(passTime / difficultyLevelTime);
			timeIndex = Math.min(5,timeIndex);
			var rate:Array = zombieRate[timeIndex];
			var index:int = CommonUtil.getRandomIndex(rate);
			var z:Zombie = new Zombie();
			z.setType(index);
			z.setSpeed(zombieSpeed * zombieSpeedFactor[index]);
			z.x = 800;
			var roadIndex:int = Math.floor(Math.random() * roadYs.length);
			z.y = roadYs[roadIndex];
			z.setRoadIndex(roadIndex);
			_container.addChild(z);
			zombies.push(z);
		}
		
		
		private function updateZombies():void
		{
			for(var i:int = zombies.length - 1;i >= 0;i--)
			{
				var z:Zombie = zombies[i] as Zombie;
				if(z.canDispose())
				{
					_container.removeChild(z);
					zombies.splice(i,1);
				}
				if(_dropArea.hitTestPoint(z.x,z.y))
				{
					endGame();
				}
				else if(z.isAlive())
				{
					z.update();
				}
			}
		}	
		
		
		private function updateTime():void
		{
			if(++timeCounter == 60)
			{
				timeCounter = 0;
				passTime++;
				
				if(passTime % difficultyLevelTime == 0)
					showBigWaveMV();			
			}

			_txtTime.text = "" + passTime;
		}	
		
		
		private function showBigWaveMV():void
		{
			DialogHelper.playMV("res/customatlas/mvbigwave.atlas",this);			
		}		
		
		
		private function handleBomb(px:Number,py:Number,roadIndex:int):void
		{
			addExploreMV(px,py);
			var affectRoad:Array = [];
			affectRoad.push(roadIndex);
			var upIndex:int = Math.max(0,roadIndex - 1);
			if(affectRoad.indexOf(upIndex) == -1)
				affectRoad.push(upIndex);
			var downIndex:int = Math.min(roadIndex + 1,roadYs.length - 1);
			if(affectRoad.indexOf(downIndex) == -1)
				affectRoad.push(downIndex);
			for(var i:int = zombies.length - 1;i >= 0;i--)
			{
				var z:Zombie = zombies[i] as Zombie;
				if(affectRoad.indexOf(z.getRoadIndex()) > -1 && Math.abs(z.x - px) <= bombWidth / 2)
				{
					killEnemy(z.type);
					z.burn();
				}
			}
		}				
		
		
		private function addExploreMV(px:Number,py:Number):void
		{
			DialogHelper.playMV("res/customatlas/mvbomb.atlas",this,new Point(px,py),new Point(168.5,192.5));
		}
		
		
		private function killEnemy(type:int):void
		{
			killNums[type]++;
			lastKillNum++;
			_txtEnemy.text = "" + lastKillNum;
		}	
		
		
		private function endGame():void
		{
			clearListener();
			trace("endGame");
			var res = Laya.loader.getRes("res/customatlas/endmv.png");
			trace(res);
			DialogHelper.playDialogMV("res/customatlas/endmv.atlas",Handler.create(this,calculate));
		}		

		
		private function calculate():void
		{
			trace("calculate");
			Laya.loader.load("res/atlas/endpanel.atlas",Handler.create(this,showEndPanel));
		}		
		
		
		private function showEndPanel():void
		{
			trace("showEndPanel");
			var endPanel:EndPanel = new EndPanel(lastKillNum,passTime,Handler.create(this,dispose));
		}		
		
		
		private function clearListener():void
		{
			this.off(Event.KEY_UP,this,onKeyUpThis);
			this.off(Event.CLICK,this,onClickThis);
			
			// Laya.timer.clearAll(this);
			Laya.timer.clear(this,onEnterFrame);
		}
		
		
		private function dispose():void
		{
			Laya.stage.removeChild(this);
			
			callback.run();
		}
	}
}