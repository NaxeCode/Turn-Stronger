package entities;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

using tweenxcore.Tools;

class GameCamera extends FlxCamera
{
	public var fsm:FlxFSM<GameCamera>;

<<<<<<< HEAD
	public var player:Kaito;
=======
	public var player:Player;
	public var camera_point:FlxPoint;
>>>>>>> e6f651bd3a02a9386374e3d8bda16dd3194d841d

	public var realTarget:FlxPoint;

	private var active_follow:Bool = false;
	private var active_player:Bool = false;

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0)
	{
		super(X, Y, Width, Height, Zoom);

		bgColor = 0xFF17142d;
		antialiasing = false;

		initFSM();

		FlxG.watch.add(fsm, "state", "FSM state:");

		FlxG.watch.add(this, "active_follow", "active_follow");
		FlxG.watch.add(this, "active_player", "active_player");

		FlxG.watch.add(scroll, "x", "scroll X");
		FlxG.watch.add(scroll, "y", "scroll Y");
	}

	function initFSM()
	{
		camera_point = new FlxPoint(0, 0);

		fsm = new FlxFSM(this);
		fsm.transitions.add(Idle, Follow, Conditions.follow);
		fsm.transitions.add(Idle, LookingDown, Conditions.holdingDown);
		fsm.transitions.add(Idle, LookingUp, Conditions.holdingUp);

		fsm.transitions.add(Follow, Idle, Conditions.stopped);
		fsm.transitions.add(Follow, LookingDown, Conditions.holdingDown);
		fsm.transitions.add(Follow, LookingUp, Conditions.holdingUp);

		fsm.transitions.add(LookingDown, Idle, Conditions.releaseLookingDown);
		fsm.transitions.add(LookingUp, Idle, Conditions.releaseLookingUp);
		// fsm.transitions.add(LookingDown, Follow, Conditions.follow);
		fsm.transitions.start(Idle);
	}

	public function initPlayer(passThruPlayerObj:Kaito)
	{
		try
		{
			target = player = passThruPlayerObj;
			active_player = true;
			FlxG.watch.add(player, "x", "player Y");
			FlxG.watch.add(player, "y", "player Y");
		}
		catch (e)
		{
			throw "Error: " + e;
		}
	}

	override function update(elapsed:Float)
	{
		if (active_player)
		{
			fsm.update(elapsed);
		}

		super.update(elapsed);
	}

	override function destroy():Void
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}

	// a function that creates a new FlxPoint and returns it.

	public function isOverlaping():Bool
	{
		target.getMidpoint(camera_point);
		camera_point.addPoint(targetOffset);

		// FlxMath.inBounds();

		if (scroll.x != camera_point.x - width * 0.5 || scroll.y != camera_point.y - height * 0.5)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}

class Conditions
{
	public static function follow(Owner:GameCamera):Bool
	{
		return Owner.isOverlaping();
	}

	public static function stopped(Owner:GameCamera):Bool
	{
		return !Owner.isOverlaping();
	}

	public static function holdingDown(Owner:GameCamera):Bool
	{
		return Owner.player.down.triggered;
	}

	public static function holdingUp(Owner:GameCamera):Bool
	{
		return Owner.player.up.triggered;
	}

	public static function releaseLookingDown(Owner:GameCamera):Bool
	{
		return !Owner.player.down.check();
	}

	public static function releaseLookingUp(Owner:GameCamera):Bool
	{
		return !Owner.player.up.check();
	}
}

// Also the zooming class lol
class Idle extends FlxFSMState<GameCamera>
{
	public static var frameCount:Float = 0;

	public var TOTAL_FRAME:Int = 1200; // 30 Second tween

	public static function resetTween()
	{
		frameCount = 0;
	}

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		// playerStill = new FlxTimer().start(30, );
	}

	override function update(elapsed:Float, owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		spacingOut(owner);
	}

	function spacingOut(owner:GameCamera)
	{
		var rate = frameCount / TOTAL_FRAME;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			var zoomRate = rate.circInOut().lerp(owner.zoom, 1.75);
			if (owner.scroll.x != owner.target.x && owner.scroll.y != owner.target.y)
			{
				var rateX = rate.circInOut().lerp(owner.scroll.x, owner.target.x);
				var rateY = rate.circInOut().lerp(owner.scroll.y, owner.target.y);
				owner.scroll.set(rateX, rateY);
			}
			// var yRate = rate.circInOut().lerp(owner.scroll.y, owner.realTarget.y - 25);
			owner.zoom = zoomRate;
			// owner.scroll.y = yRate;
			frameCount += 1;
		}
	}

	override function exit(owner:GameCamera)
	{
		frameCount = 0;
	}
}

class Follow extends FlxFSMState<GameCamera>
{
	public static var frameCount:Float = 0;

	public var TOTAL_FRAME:Int = 180; // 3 Second tween

	public static function resetTween()
	{
		frameCount = 0;
	}

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void {}

	override function update(elapsed:Float, owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		followPlayer(owner);
	}

	function followPlayer(owner:GameCamera)
	{
		var rate = frameCount / TOTAL_FRAME;

		var offsetAmount:Int = 50;
		if (owner.player.flipX)
			offsetAmount = -offsetAmount;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.target.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.target.y);
			var zoomRate = rate.circIn().lerp(owner.zoom, 1.25);
			owner.zoom = zoomRate;
			owner.scroll.set(rateX, rateY);
			frameCount += 0.50;
		}
		else
		{
			frameCount = 0;
		}
	}

	override function exit(owner:GameCamera)
	{
		frameCount = 0;
	}
}

class LookingDown extends FlxFSMState<GameCamera>
{
	public var frameCount:Float = 0;
	public var TOTAL_FRAME:Int = 180; // 3 Second tween

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		frameCount = 0;
	}

	override function update(elapsed:Float, owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		followPlayer(owner);
	}

	function followPlayer(owner:GameCamera)
	{
		var rate = frameCount / TOTAL_FRAME;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.target.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.target.y + 100);
			var zoomRate = rate.circIn().lerp(owner.zoom, 1.25);
			owner.zoom = zoomRate;
			owner.scroll.set(rateX, rateY);
			frameCount += 0.50;
		}
		else
		{
			frameCount = 0;
		}
	}

	override function exit(owner:GameCamera)
	{
		frameCount = 0;
	}
}

class LookingUp extends FlxFSMState<GameCamera>
{
	public var frameCount:Float = 0;
	public var TOTAL_FRAME:Int = 180; // 3 Second tween

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		frameCount = 0;
	}

	override function update(elapsed:Float, owner:GameCamera, fsm:FlxFSM<GameCamera>):Void
	{
		followPlayer(owner);
	}

	function followPlayer(owner:GameCamera)
	{
		var rate = frameCount / TOTAL_FRAME;

		// An animation when rate is 0 to 1.
		if (rate <= 1)
		{
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.target.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.target.y - 100);
			var zoomRate = rate.circIn().lerp(owner.zoom, 1.25);
			owner.zoom = zoomRate;
			owner.scroll.set(rateX, rateY);
			frameCount += 0.50;
		}
		else
		{
			frameCount = 0;
		}
	}

	override function exit(owner:GameCamera)
	{
		frameCount = 0;
	}
}

abstract class Animatable
{
	public var frameCount:Float;
	public var TOTAL_FRAME:Int; // 3 Second tween
}
