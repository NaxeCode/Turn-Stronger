package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		var startFullscreen:Bool = false;
		var save:FlxSave = new FlxSave();
		save.bind("TurnStronger");
		#if desktop
		if (save.data.fullscreen != null)
		{
			startFullscreen = save.data.fullscreen;
		}
		#end

		super();
		addChild(new FlxGame(640, 480, BetterTutorial, 1, 60, 60, true));

		if (save.data.volume != null)
		{
			FlxG.sound.volume = save.data.volume;
		}
		save.close();
	}
}
