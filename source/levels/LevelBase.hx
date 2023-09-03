package levels;

import entities.NPC;
import entities.Player;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import utils.assets.AssetPaths;

class LevelBase extends FlxState
{
	public var player:Player;

	public var collider:FlxSpriteGroup;
	public var background:FlxSpriteGroup;

	public var noah:NPC;
	public var npcs:FlxTypedGroup<NPC>;

	override public function create()
	{
		super.create();

		buildWorld();
	}

	function buildWorld()
	{
		var project = new LdtkProject();

		// Create a FlxGroup for all level layers
		collider = new FlxSpriteGroup();

		background = new FlxSpriteGroup();
		add(background);

		// Iterate all world levels
		for (level in project.all_worlds.Default.levels)
		{
			// Place it using level world coordinates (in pixels)
			collider.setPosition(level.worldX, level.worldY);
			background.setPosition(level.worldX, level.worldY);

			createEntities(level.l_Entities);

			// Attach level background image, if any
			if (level.hasBgImage())
				background.add(level.getBgSprite());

			// Render layer "Background"
			level.l_Background.render(background);

			// Render layer "Collisions"
			level.l_Collisions.render(collider);
		}

		for (tile in collider)
		{
			tile.immovable = true;
		}
		add(collider);
	}

	function createEntities(entityLayer:LdtkProject.Layer_Entities)
	{
		var x:Int;
		var y:Int;

		x = entityLayer.all_Noah[0].pixelX;
		y = entityLayer.all_Noah[0].pixelY;

		npcs = new FlxTypedGroup<NPC>();

		noah = new NPC(x, y);
		noah.text = entityLayer.all_Noah[0].f_string;
		noah.loadGraphic(AssetPaths.Noah__png, false, 32, 64);
		// trace(noah.width);
		// trace(noah.height);
		noah.setFacingFlip(LEFT, true, false);
		noah.setFacingFlip(LEFT, false, false);

		// npcs.add(noah);
		// add(noah);

		noah.facing = LEFT;

		x = entityLayer.all_Player[0].pixelX;
		y = entityLayer.all_Player[0].pixelY;

		player = new Player(x, y);
		trace("X: " + x);
		trace("Y: " + y);
		trace("player X: " + player.x);
		trace("player Y: " + player.y);
		add(player);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
