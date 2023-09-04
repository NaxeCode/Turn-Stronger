package;

import flixel.FlxGame;
import levels.Playground;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, Playground, 60, 60, true));
	}
}
