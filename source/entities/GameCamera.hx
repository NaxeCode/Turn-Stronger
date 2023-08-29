package entities;

import flixel.FlxCamera;
import flixel.FlxSprite;

using tweenxcore.Tools;

class GameCamera extends FlxCamera
{
	public var player:Player;

	private var frameCount = 0;

	public static var TOTAL_FRAME:Int = 120;

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0)
	{
		super(X, Y, Width, Height, Zoom);

		bgColor = 0xFF17142d;
		follow(player, NO_DEAD_ZONE, 5);
	}

	public function initPlayer(passThruPlayerObj:Player)
	{
		if (passThruPlayerObj != null)
			player = passThruPlayerObj;
		else
			trace("arg player null");

		// follow(player, NO_DEAD_ZONE, 5);
	}

	override function update(elapsed:Float)
	{
		// dynamicStateActive();
		super.update(elapsed);
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
