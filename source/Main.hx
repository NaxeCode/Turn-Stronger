package;

import flixel.FlxGame;
import levels.BetterTutorial;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, BetterTutorial, 60, 60, true));
	}
}
