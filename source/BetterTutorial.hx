package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class BetterTutorial extends FlxState
{
	public var player:Player;

	var collider:FlxSpriteGroup;
	var background:FlxSpriteGroup;

	public var noah:NPC;
	public var npcs:FlxTypedGroup<NPC>;

	public var dialogueBox:DialogueBox;

	public static var gameCamera:FlxCamera;

	var uiCamera:FlxCamera;

	override public function create()
	{
		super.create();

		FlxG.camera.flash(FlxColor.BLACK, 4);

		dialogueBox = new DialogueBox();
		add(dialogueBox);

		gameCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);

		gameCamera.bgColor = 0xFF17142d;
		uiCamera.bgColor = FlxColor.TRANSPARENT;

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

		gameCamera.follow(player);
		gameCamera.zoom = 2;

		// FlxG.cameras.reset(gameCamera);

		FlxG.cameras.add(gameCamera, true);
		FlxG.cameras.add(uiCamera, false);

		// gameCamera = uiCamera;
		// gameCamera.camera.setScrollBoundsRect(0, 0, background.width, background.height, true);
		dialogueBox.cameras = [uiCamera];

		dialogueBox.scrollFactor.set(0, 0);
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
		trace(noah.width);
		trace(noah.height);
		noah.setFacingFlip(LEFT, true, false);
		noah.setFacingFlip(LEFT, false, false);

		npcs.add(noah);
		add(noah);

		noah.facing = LEFT;

		x = entityLayer.all_Player[0].pixelX;
		y = entityLayer.all_Player[0].pixelY;

		player = new Player(x, y);
		add(player);
	}

	override public function update(elapsed:Float)
	{
		handleDialogBox();

		super.update(elapsed);

		FlxG.collide(collider, player);
	}

	function handleDialogBox()
	{
		if (FlxG.keys.justPressed.Z)
		{
			if (dialogueBox.visible)
			{
				if (!dialogueBox.typeText._typing)
				{
					FlxTween.tween(gameCamera, {zoom: 2}, 0.5, {ease: FlxEase.backOut});
					Reg.canMove = true;
					dialogueBox.visible = false;
				}
				else
				{
					dialogueBox.typeText.skip();
				}
			}
			else if (!dialogueBox.visible)
			{
				for (member in npcs)
				{
					if (FlxMath.isDistanceWithin(member, player, 50))
					{
						dialogueBox.say(member.text);
						FlxTween.tween(gameCamera, {zoom: 4}, 0.5, {ease: FlxEase.backOut});
					}
				}
			}
		}
	}
}
