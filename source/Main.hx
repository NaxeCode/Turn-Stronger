package;

import flixel.FlxGame;
import levels.BetterTutorial;
import levels.KaitoVSAstra;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, KaitoVSAstra, 60, 60, true));
	}
}
