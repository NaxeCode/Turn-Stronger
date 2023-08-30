package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import utils.assets.AssetPaths;
import utils.dialog.Reg;

class Player extends FlxSprite
{
	var jumpPower:Int = 200;

	var splatSound:FlxSound;

	static var actions:FlxActionManager;

	var up:FlxActionDigital;
	var down:FlxActionDigital;
	var left:FlxActionDigital;
	var right:FlxActionDigital;

	var jump:FlxActionDigital;

	// var moveAnalog:FlxActionAnalog;
	var trigger1:FlxActionAnalog;
	var trigger2:FlxActionAnalog;

	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X, Y);

		splatSound = FlxG.sound.load(AssetPaths.splat__ogg, 1);

		// makeGraphic(16, 16, FlxColor.fromInt(0xFF273769));
		loadGraphic(AssetPaths.player_no_glass__png, true, 32, 32);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

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

		addInputs();
	}

	function addInputs()
	{
		// digital actions allow for on/off directional movement
		up = new FlxActionDigital();
		down = new FlxActionDigital();
		left = new FlxActionDigital();
		right = new FlxActionDigital();

		jump = new FlxActionDigital();

		// these actions don't do anything, but their values are exposed in the analog visualizer
		trigger1 = new FlxActionAnalog();
		trigger2 = new FlxActionAnalog();

		// this analog action allows for smooth movement
		// move = new FlxActionAnalog();

		actions = FlxG.inputs.add(new FlxActionManager());
		actions.addActions([up, down, left, right, trigger1, trigger2, jump]);

		// Add keyboard inputs
		up.addKey(UP, PRESSED);
		up.addKey(W, PRESSED);
		down.addKey(DOWN, PRESSED);
		down.addKey(S, PRESSED);
		left.addKey(LEFT, PRESSED);
		left.addKey(A, PRESSED);
		right.addKey(RIGHT, PRESSED);
		right.addKey(D, PRESSED);
		jump.addKey(SPACE, PRESSED);
		jump.addKey(J, PRESSED);

		// Add gamepad DPAD inputs
		up.addGamepad(DPAD_UP, PRESSED);
		down.addGamepad(DPAD_DOWN, PRESSED);
		left.addGamepad(DPAD_LEFT, PRESSED);
		right.addGamepad(DPAD_RIGHT, PRESSED);
		jump.addGamepad(A, PRESSED);

		// Add gamepad analog stick (as simulated DPAD) inputs
		up.addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
		down.addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);
		left.addGamepad(LEFT_STICK_DIGITAL_LEFT, PRESSED);
		right.addGamepad(LEFT_STICK_DIGITAL_RIGHT, PRESSED);

		// Add gamepad analog trigger inputs
		trigger1.addGamepad(LEFT_TRIGGER, MOVED);
		trigger2.addGamepad(RIGHT_TRIGGER, MOVED);
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

		if (left.triggered)
		{
			acceleration.x = -maxVelocity.x * 4;
			facing = LEFT;
		}

		if (right.triggered)
		{
			acceleration.x = maxVelocity.x * 4;
			facing = RIGHT;
		}

		if (jump.triggered && isTouching(FLOOR))
		{
			velocity.y = -jumpPower;
		}
	}

	function handleSound()
	{
		if (justTouched(FLOOR))
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
		else if (this.isTouching(FLOOR) && velocity.x != 0)
		{
			animation.play("run");
		}
		else if (this.isTouching(FLOOR) && velocity.x == 0 && velocity.y == 0)
		{
			animation.play("idle");
		}
	}
}
