package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X, Y);

		makeGraphic(22, 22, FlxColor.RED);

		acceleration.y = 200;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
