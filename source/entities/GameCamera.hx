package entities;

import flixel.FlxCamera;
import flixel.FlxSprite;

class GameCamera extends FlxCamera
{
	public var members:Array<FlxSprite>;

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0)
	{
		super(X, Y, Width, Height, Zoom);

		members = new Array<FlxSprite>();

		bgColor = 0xFF17142d;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
