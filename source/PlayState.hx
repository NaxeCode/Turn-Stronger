package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var level:TiledLevel;

	public var player:Player;
	public var enemy:FlxGroup;

	public var score:FlxText;
	public var status:FlxText;
	public var coins:FlxGroup;
	public var floor:FlxObject;
	public var exit:FlxSprite;

	static var youDied:Bool = false;

	var ground:FlxSprite;

	var gameCamera:FlxCamera;
	var uiCamera:FlxCamera;

	override public function create()
	{
		super.create();

		bgColor = 0xFF269bff;

		player = new Player(0, 0);

		/*

			level = new TiledLevel("assets/tiled/smb.tmx", this);

			add(level.backgroundLayer);

			add(level.imagesLayer);

			add(level.objectsLayer);

			add(player);

			add(level.foregroundTiles);
		 */

		// enemy = new Enemy(300, 250);
		// add(enemy);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		super.update(elapsed);

		// level.collideWithLevel(player);

		// FlxG.overlap(exit, player, win);

		if (FlxG.overlap(player, floor))
		{
			youDied = true;
			FlxG.resetState();
		}
	}

	public function win(Exit:FlxObject, Player:FlxObject):Void
	{
		// status.text = "Yay, you won!";
		// score.text = "SCORE: 5000";
		// player.kill();
	}

	function handleEnemy(plr:FlxSprite, enm:FlxSprite)
	{
		if (enm.justTouched(FlxObject.CEILING) && plr.justTouched(FlxObject.FLOOR))
			plr.velocity.y = -plr.maxVelocity.y / 2;
		else
			plr.kill();
	}
}
