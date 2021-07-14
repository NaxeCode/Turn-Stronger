package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var jumpPower:Int = 200;

	var splatSound:FlxSound;

	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X, Y);

		splatSound = FlxG.sound.load(AssetPaths.splat__ogg, 1);

		// makeGraphic(16, 16, FlxColor.fromInt(0xFF273769));
		loadGraphic(AssetPaths.player_no_glass__png, true, 32, 32);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1, 2, 3], 10, true);
		animation.add("run", [4, 5, 6, 7, 8], 10, true);
		animation.add("jump", [9, 10, 11], 30, true);

		width = 13;
		height = 13;
		offset.y += 12;
		offset.x += 9;

		maxVelocity.set(100, 400);
		acceleration.y = 400;
		drag.x = maxVelocity.x * 4;
	}

	override function update(elapsed:Float)
	{
		handleAnimation();

		handleMovement();

		handleSound();

		super.update(elapsed);
	}

	function handleMovement()
	{
		acceleration.x = 0;

		if (!Reg.canMove)
			return;

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			acceleration.x = -maxVelocity.x * 4;
			facing = FlxObject.LEFT;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			acceleration.x = maxVelocity.x * 4;
			facing = FlxObject.RIGHT;
		}

		if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && isTouching(FlxObject.FLOOR))
		{
			velocity.y = -jumpPower;
		}
	}

	function handleSound()
	{
		if (justTouched(FlxObject.FLOOR))
		{
			splatSound.play();
		}
	}

	function handleAnimation()
	{
		if (velocity.y != 0)
		{
			animation.play("jump");
		}
		else if (this.isTouching(FlxObject.FLOOR) && velocity.x != 0)
		{
			animation.play("run");
		}
		else if (this.isTouching(FlxObject.FLOOR) && velocity.x == 0 && velocity.y == 0)
		{
			animation.play("idle");
		}
	}
}
