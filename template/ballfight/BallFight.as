package mmo.app.ballfight
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import mmo.common.ModalDialog;
	import mmo.common.dialog.NewDialog;
	import mmo.framework.comm.SocketClient;
	import mmo.framework.comm.SocketClientEvent;
	import mmo.scenecommon.CommonUtil;
	import mmo.scenecommon.DialogHelper;
	import mmo.scenecommon.EffectHelper;
	import mmo.scenecommon.ItemHelper;
	import mmo.scenecommon.LoaderHelper;
	
	public class BallFight extends MovieClip
	{
		private var roadYs:Array = [205,285,370,450];
		private var roadBorder:Array = [135,213,297,381,459];
		
		private var conveyer:MovieClip;
		private var ci:MovieClip;
		private var dropArea:MovieClip;
		private var container:MovieClip;
		private var mcGuage:MovieClip;
		
		private var ciWidth:Number;
		private var iconSpeed:Number = 3.0;
		private var ballSpeed:Number = 5.0;
		private var zombieSpeed:Number = 2.0;
		private var createIconCounter:int = 0;
		private var createIconInterval:int = 1.6 * 25;
		private var createZombieCounter:int = 0;
		private var timeCounter:int = 0;
		private var passTime:int = 0;
		private var gameTime:int = 60;
		private var ballWidth:Number = 57.6;
		private var bombWidth:Number = ballWidth * 4;
		
		private var zombieRate:Array = [
			[1,0,0],
			[2,3,0],
			[1,1,0],
			[2,2,1],
			[2,2,1],
			[1,1,1],
		];
		
		private var zombieInterval:Array = [2 * 25,2 * 25,1 * 25,2 * 25,2 * 25,1 * 25];
		private var zombieSpeedFactor:Array = [1,1.2,1.5];
		
		private var icons:Array = [];
		private var balls:Array = [];
		private var zombies:Array = [];
		
		private var killNums:Array = [0,0,0];
		private var addByKill:Array = [2,2,2];
		private var lastKillNum:int = 0;
		private var lastAddNum:int = 0;
		
//		private var gaId:int = 2865;
		
		private var downPoint:Point;
		
		private var curBall:Ball = null;
		private var curBallIcon:BallIcon = null;
		private var isPickIcon:Boolean = false;
		private var lastDownIcon:Boolean = false;
		private var isWin:Boolean = false;
		private var isPause:Boolean = false;
		
		public function BallFight()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		
		private function onAdd(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			initElement();
		}
		
		
		private function initElement():void
		{
			SocketClient.instance.sendXtMsgAndCallBack(833,"833-3",null,{"index":0});
			
			conveyer = this.getChildByName("_conveyer") as MovieClip;
			ci = conveyer.getChildByName("_conveyerInner") as MovieClip;
			ciWidth = ci.width;
			dropArea = this.getChildByName("_dropArea") as MovieClip;
			container = this.getChildByName("_container") as MovieClip;
			
			mcGuage = this.getChildByName("_mcGuage") as MovieClip;
			mcGuage.gotoAndStop(1);
			
			startGame();
		}	
		
		
		private function startGame():void
		{
			this.addEventListener(MouseEvent.CLICK,onClickThis);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpThis);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUpThis);
		}
			
		
		private function onKeyUpThis(evt:KeyboardEvent):void
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
			if(icons.length >= 9)//icon不用存太多
				return ;
			
			if(++createIconCounter == createIconInterval)
			{
				createIconCounter = 0;
				var ri:int = Math.floor(Math.random() * 2);
				var cls:Class = getDefinitionByName("mmo.app.ballfight.BallIcon" + ri) as Class;
				var icon:BallIcon = new cls() as BallIcon;
				icon.setType(ri);
				var lastIcon:MovieClip = icons[icons.length - 1];
				if(lastIcon != null && lastIcon.x + lastIcon.width >= ciWidth)
					icon.x = lastIcon.x + lastIcon.width + 1;
				else
					icon.x = ciWidth;
				ci.addChild(icon);
				icon.buttonMode = true;
				icon.addEventListener(MouseEvent.CLICK,onClickIcon);
				icon.addEventListener(MouseEvent.MOUSE_DOWN,onDownIcon);
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
					ci.removeChild(icon);
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
			if(dropArea.hitTestPoint(curBall.x,curBall.y,true))
			{
				curBall.alpha = 1.0;
			}
			else
			{
				curBall.alpha = 0.5;
			}
		}
		
		
		private function onClickIcon(evt:MouseEvent):void
		{
			if(isPickIcon)
				return ;

			evt.stopImmediatePropagation();
			curBallIcon = evt.currentTarget as BallIcon;
			handlePick();
		}	
		
		
		private function onDownIcon(evt:MouseEvent):void
		{
			if(isPickIcon)
				return ;
			
			evt.stopImmediatePropagation();
			lastDownIcon = true;
			downPoint = new Point(mouseX,mouseY);
			curBallIcon = evt.currentTarget as BallIcon;
			handlePick();
		}			
		
		
		private function onUpThis(evt:MouseEvent):void
		{
			if(isPickIcon == false)
				return ;
			
			if(downPoint == null)
				return ;
			
			var nowPoint:Point = new Point(mouseX,mouseY);
			if(Point.distance(downPoint,nowPoint) > 10)
			{
				downPoint = null;
				checkDropBall();
			}
		}	
		
		
		private function handlePick():void
		{
			isPickIcon = true;
			curBallIcon.pick();
			var cls:Class = getDefinitionByName("mmo.app.ballfight.Ball" + curBallIcon.type) as Class;
			curBall = new cls();
			curBall.setType(curBallIcon.type);
			this.addChild(curBall);
			curBall.mouseChildren = false;
			curBall.mouseEnabled = false;
		}		
		
		
		private function onClickThis(evt:MouseEvent):void
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
			
			if(evt.target.name == "btnClose")
			{
				isPause = true;
				DialogHelper.showDialog(new ComfirmExit(),function(bName:String){
					if(bName == "btnOK")
						endGame();
					else 
						isPause = false;
				},true,true);
			}
		}	
				
		
		private function checkDropBall():Boolean
		{
			if(isPickIcon == false)
				return false;
			
			if(dropArea.hitTestPoint(mouseX,mouseY,true))
			{
				dropBall();
			}
			else
			{
				EffectHelper.showFadeText("不可以放在这里哦~",755 / 2,475 / 2);
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
			container.addChild(curBall);
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
					container.removeChild(ball);
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
			var timeIndex:int = Math.floor(passTime / 10);
			timeIndex = Math.min(5,timeIndex);
			var rate:Array = zombieRate[timeIndex];
			var timeInterval:int = zombieInterval[timeIndex];
			if(++createZombieCounter >= timeInterval)
			{
				createZombieCounter = 0;
				var index:int = CommonUtil.getRandomIndex(rate);
				var cls:Class = getDefinitionByName("mmo.app.ballfight.Monster" + index) as Class;
				var z:Zombie = new cls() as Zombie;
				z.setType(index);
				z.setSpeed(zombieSpeed * zombieSpeedFactor[index]);
				z.x = 800;
				var roadIndex:int = Math.floor(Math.random() * roadYs.length);
				z.y = roadYs[roadIndex];
				z.setRoadIndex(roadIndex);
				container.addChild(z);
				zombies.push(z);
			}
		}	
		
		
		private function updateZombies():void
		{
			for(var i:int = zombies.length - 1;i >= 0;i--)
			{
				var z:Zombie = zombies[i] as Zombie;
				if(z.canDispose())
				{
					container.removeChild(z);
					zombies.splice(i,1);
				}
				if(dropArea.hitTestPoint(z.x,z.y,true))
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
			if(++timeCounter == 25)
			{
				timeCounter = 0;
				passTime++;
				
				if(passTime == 20 || passTime == 50)
					showBigWaveMV();
				
				var cf:int = int(passTime / gameTime * mcGuage.totalFrames);
				mcGuage.gotoAndStop(cf);
				
				if(passTime >= gameTime)
				{
					isWin = true;
					endGame();
				}
			}
		}	
		
		
		private function showBigWaveMV():void
		{
			var mv:MovieClip = new BigWaveMV();
			mv.mouseChildren = false;
			mv.mouseEnabled = false;
			CommonUtil.playToEnd(mv,function(){
				removeChild(mv);
			});
			this.addChild(mv);
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
			var mv:MovieClip = new BombMV();
			mv.x = px;
			mv.y = py;
			mv.addFrameScript(mv.totalFrames - 1,function(){
				mv.addFrameScript(mv.totalFrames - 1,null);
				mv.gotoAndStop(mv.totalFrames);
				removeChild(mv);
			});
			this.addChild(mv);
		}
		
		
		private function killEnemy(type:int):void
		{
			killNums[type]++;
			lastKillNum++;
			lastAddNum += addByKill[type];
			TextField(this.getChildByName("_txtEnemy")).text = "" + lastKillNum;
			TextField(this.getChildByName("_txtAddNum")).text = "" + lastAddNum;
		}	
		
		
		private function endGame():void
		{
			clearListener();
			var mv:MovieClip;
			mv = new EndMV();
			DialogHelper.playMC(mv,calculate);
		}		
		
		
		private function calculate():void
		{
			if(lastKillNum > 0)
				SocketClient.instance.sendXtMsgAndCallBack(833,"833-1",onAddBack,{"enemy":lastKillNum});
			else
				showEndPanel(0);
		}		
		
		
		private function onAddBack(evt:SocketClientEvent):void
		{
			var realAdd:int = int(evt.params.inc);
//			ItemHelper.addAndShowOneItemInClient(ItemHelper.GaMaterial,gaId,realAdd);
			showEndPanel(realAdd);
		}		
		
		
		private function showEndPanel(realAdd:int):void
		{
			var endPanel:MovieClip = new EndPanel();
			TextField(endPanel.getChildByName("_txtKill")).text = "" + lastKillNum;
			TextField(endPanel.getChildByName("_txtAdd")).text = "" + realAdd;
//			endPanel.getChildByName("_mcFull").visible = realAdd < lastAddNum;
			DialogHelper.showDialog(endPanel,dispose,true);
		}		
		
		
		private function showExchangePanel():void
		{
			new LoaderHelper().loadAndShowDialogAt00("factivity/romanticstreet","mmo.factivity.romanticstreet.RSExcPanel");
		}
		
		
		private function clearListener():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUpThis);
			this.removeEventListener(MouseEvent.CLICK,onClickThis);
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		
		private function dispose():void
		{
			ModalDialog.closeDialog(this);
			
			NewDialog.getCustomDialog(new BallFightStartPanel(),0,0).show();
		}
	}
}