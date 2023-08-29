package entities;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

using tweenxcore.Tools;

class GameCamera extends FlxCamera
{
	public var player:Player;

	public var realTarget:FlxPoint;

	private var active_follow:Bool = false;
	private var active_player:Bool = true;

	private var frameCount:Float = 0;

	public static var TOTAL_FRAME:Int = 180; // 3 Second tween

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0)
	{
		super(X, Y, Width, Height, Zoom);

		bgColor = 0xFF17142d;
		antialiasing = false;

		FlxG.watch.add(this, "active_follow", "active_follow");
		FlxG.watch.add(this, "active_player", "active_player");

		FlxG.watch.add(scroll, "x", "scroll X");
		FlxG.watch.add(scroll, "y", "scroll Y");
	}

	public function initPlayer(passThruPlayerObj:Player)
	{
		if (passThruPlayerObj != null)
		{
			player = passThruPlayerObj;
			FlxG.watch.add(player, "x", "player Y");
			FlxG.watch.add(player, "y", "player Y");
		}
		else
			trace("arg player null");
	}

	override function update(elapsed:Float)
	{
		checkState();
		flowState();

		super.update(elapsed);
	}

	function checkState()
	{
		if (scroll.x != player.x - (this.width / 2.5) || scroll.y != player.y - (this.height / 2.5))
			active_follow = true;
		else
			active_follow = false;
	}

	function flowState()
	{
		if (active_player)
		{
			initRealTarget();
			updateRealTarget();
		}

		if (active_follow)
			followPlayer();
	}

	function initRealTarget()
	{
		if (realTarget == null)
			realTarget = new FlxPoint(player.x - (this.width / 2.5), player.y - (this.height / 2.5));

		FlxG.watch.add(realTarget, "x", "realTarget X:");
		FlxG.watch.add(realTarget, "y", "realTarget Y:");
	}

	function updateRealTarget()
	{
		realTarget.set(player.x - (this.width / 2.5), player.y - (this.height / 2.5));
	}

	function followPlayer()
	{
		var rate = frameCount / TOTAL_FRAME;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			var rateX = rate.circInOut().lerp(scroll.x, realTarget.x);
			var rateY = rate.circInOut().lerp(scroll.y, realTarget.y);
			scroll.set(rateX, rateY);
			frameCount += 0.25;
		}
		else
		{
			frameCount = 0;
		}
	}

	function dynamicStateActive()
	{
		var rate = frameCount / TOTAL_FRAME;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			// Move x from 0 to 450 according to the value of rate.
			// square.x = rate.quintOut().lerp(0, 450);
			var realX = (scroll.x - player.x);
			var realY = (scroll.y + player.y);
			scroll.x = rate.quintOut().lerp(player.x, player.x);
			scroll.y = rate.quintOut().lerp(player.y, player.y);
		}
		frameCount++;
	}
}
