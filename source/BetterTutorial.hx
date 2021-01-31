package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;

class BetterTutorial extends FlxState
{
	public var player:Player;

	var collider:FlxSpriteGroup;
	var background:FlxSpriteGroup;

	override public function create()
	{
		super.create();

		var project = new LdtkProject();

		// Create a FlxGroup for all level layers
		collider = new FlxSpriteGroup();

		background = new FlxSpriteGroup();
		add(background);

		// Iterate all world levels
		for (level in project.levels)
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
		var x = entityLayer.all_Player[0].pixelX;
		var y = entityLayer.all_Player[0].pixelY;

		player = new Player(x, y);
		add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(collider, player);
	}
}
