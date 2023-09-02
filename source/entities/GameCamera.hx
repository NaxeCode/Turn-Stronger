package entities;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

using tweenxcore.Tools;

class GameCamera extends FlxCamera
{
	public var fsm:FlxFSM<GameCamera>;

	public var player:Player;

	public var realTarget:FlxPoint;

	private var active_follow:Bool = false;
	private var active_player:Bool = true;

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

	public function initPlayer(passThruPlayerObj:Player)
	{
		try
		{
			player = passThruPlayerObj;
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
		fsm.update(elapsed);
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

	override function destroy():Void
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
}

class Conditions
{
	public static function follow(Owner:GameCamera):Bool
	{
		return (Owner.scroll.x != Owner.player.x - (Owner.width / 2.5) || Owner.scroll.y != Owner.player.y - (Owner.height / 2.5));
	}

	public static function stopped(Owner:GameCamera):Bool
	{
		return !(Owner.scroll.x != Owner.player.x - (Owner.width / 2.5) || Owner.scroll.y != Owner.player.y - (Owner.height / 2.5));
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
class Idle extends FlxFSMState<GameCamera> implements Animatable
{
	private var frameCount:Float = 0;
	private var TOTAL_FRAME:Int = 1200; // 30 Second tween

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
			var zoomRate = rate.circInOut().lerp(owner.zoom, 1);
			if (owner.scroll.x != owner.realTarget.x && owner.scroll.y != owner.realTarget.y)
			{
				var rateX = rate.circInOut().lerp(owner.scroll.x, owner.realTarget.x);
				var rateY = rate.circInOut().lerp(owner.scroll.y, owner.realTarget.y);
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

class Follow extends FlxFSMState<GameCamera> implements Animatable
{
	private var frameCount:Float = 0;

	private var TOTAL_FRAME:Int = 180; // 3 Second tween

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void {}

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
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.realTarget.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.realTarget.y);
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

class LookingDown extends FlxFSMState<GameCamera> implements Animatable
{
	private var frameCount:Float = 0;
	private var TOTAL_FRAME:Int = 180; // 3 Second tween

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void {}

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
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.realTarget.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.realTarget.y + 100);
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

class LookingUp extends FlxFSMState<GameCamera> implements Animatable
{
	private var frameCount:Float = 0;
	private var TOTAL_FRAME:Int = 180; // 3 Second tween

	override function enter(owner:GameCamera, fsm:FlxFSM<GameCamera>):Void {}

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
			var rateX = rate.circInOut().lerp(owner.scroll.x, owner.realTarget.x);
			var rateY = rate.circInOut().lerp(owner.scroll.y, owner.realTarget.y - 100);
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

interface Animatable
{
	private var frameCount:Float;
	private var TOTAL_FRAME:Int; // 3 Second tween
}
