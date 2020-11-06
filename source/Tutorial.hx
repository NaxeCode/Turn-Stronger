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
	public var npcs:FlxTypedGroup<NPC>;

	public var floor:FlxObject;
	public var exitTrigger:FlxObject;

	static var youDied:Bool = false;

	override public function create()
	{
		super.create();

		player = new Player(0, 0);

		npcs = new FlxTypedGroup<NPC>(0);

		level = new TiledLevel("assets/tiled/tutorial.tmx", this);

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
