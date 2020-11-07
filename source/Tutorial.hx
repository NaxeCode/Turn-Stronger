package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;

class Tutorial extends FlxState
{
	public var level:TiledLevel;

	public var player:Player;
	public var enemy:FlxGroup;
	public var noah:NPC;
	public var npcs:FlxTypedGroup<NPC>;

	public var floor:FlxObject;
	public var exitTrigger:FlxObject;

	static var youDied:Bool = false;

	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = 0xFF202e45;

		player = new Player(0, 0);

		noah = new NPC(0, 0);
		noah.loadGraphic(AssetPaths.Noah__png, false, 32, 64);
		noah.setFacingFlip(FlxObject.LEFT, true, false);
		noah.setFacingFlip(FlxObject.RIGHT, false, false);

		level = new TiledLevel("assets/tiled/tutorial.tmx", this);

		add(noah);
		noah.facing = FlxObject.LEFT;

		add(level.backgroundLayer);

		add(level.objectsLayer);

		add(player);

		add(level.foregroundTiles);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		level.collideWithLevel(player);

		if (FlxG.overlap(player, floor))
		{
			youDied = true;
			FlxG.resetState();
		}
	}

	function handleEnemy(plr:FlxSprite, enm:FlxSprite)
	{
		if (enm.justTouched(FlxObject.CEILING) && plr.justTouched(FlxObject.FLOOR))
			plr.velocity.y = -plr.maxVelocity.y / 2;
		else
			plr.kill();
	}
}
