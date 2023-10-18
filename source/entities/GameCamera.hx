package entities;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class GameCamera extends FlxCamera
{
	public var objects:Array<FlxSprite>;

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0)
	{
		super(X, Y, Width, Height, Zoom);

		objects = new Array<FlxSprite>();

		bgColor = FlxColor.TRANSPARENT;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
