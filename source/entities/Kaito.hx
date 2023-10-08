package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import haxe.Json;
import utils.assets.AssetPaths;
import utils.dialog.Reg;

typedef FrameTag =
{
	var name:String;
	var from:Int;
	var to:Int;
	var fps:Float;
	var looped:Bool;
}

typedef MetaData =
{
	var size:{w:Int, h:Int};
	var frameTags:Array<FrameTag>;
}

typedef MyJsonData =
{
	var meta:MetaData;
}

class Kaito extends FlxSprite
{
	var jumpPower:Int = 200;

	var splatSound:FlxSound;

	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X, Y);

		splatSound = FlxG.sound.load(AssetPaths.splat__ogg, 1);

		var jzon:MyJsonData = Json.parse(sys.io.File.getContent(AssetPaths.kaito__json));

		loadGraphic(AssetPaths.kaito__png, true, jzon.meta.size.h, jzon.meta.size.w);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		// parse through an array
		for (tag in jzon.meta.frameTags)
		{
			animation.add(tag.name, [for (i in tag.from...tag.to) i], tag.fps, tag.looped);
			#if debug
			trace("Animation Loaded: "
				+ tag.name
				+ " from "
				+ tag.from
				+ " to "
				+ tag.to
				+ " at "
				+ tag.fps
				+ " fps "
				+ (tag.looped ? " LOOPED" : ""));
			#end
		}

		// width = 13;
		// height = 13;
		offset.y -= 8;
		// offset.x += 9;

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
			facing = LEFT;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			acceleration.x = maxVelocity.x * 4;
			facing = RIGHT;
		}

		if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && isTouching(FLOOR))
		{
			velocity.y = -jumpPower;
			animation.play("jump");
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
		if (velocity.y != 0) {}
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
