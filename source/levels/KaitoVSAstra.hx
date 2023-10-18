package levels;

import entities.GameCamera;
import entities.Kaito;
import entities.NPC;
import entities.UiCamera;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import utils.assets.AssetPaths;
import utils.dialog.DialogueBox;
import utils.dialog.Reg;

using tweenxcore.Tools;

class KaitoVSAstra extends FlxState
{
	public var player:Kaito;

	var collider:FlxSpriteGroup;
	var background:FlxSpriteGroup;

	public var noah:NPC;
	public var npcs:FlxTypedGroup<NPC>;

	public var dialogueBox:DialogueBox;

	public static var gameCamera:GameCamera;

	var uiCamera:UiCamera;

	override public function create()
	{
		super.create();

		FlxG.log.redirectTraces = true;

		loadDialog();
		loadCamera();

		buildWorld();

		setCamera();
		addCamera();
	}

	function loadDialog()
	{
		dialogueBox = new DialogueBox();
		add(dialogueBox);
	}

	function loadCamera()
	{
		gameCamera = new GameCamera(0, 0, FlxG.width, FlxG.height, 1.25);
		uiCamera = new UiCamera(0, 0, FlxG.width, FlxG.height);
	}

	function setCamera()
	{
		gameCamera.flash(FlxColor.BLACK, 4);

		dialogueBox.cameras = [uiCamera];
		uiCamera.ui_element.push(dialogueBox);
		dialogueBox.scrollFactor.set(0, 0);

		gameCamera.follow(player, PLATFORMER, 0.5);
	}

	function addCamera()
	{
		FlxG.cameras.reset(gameCamera);
		FlxG.cameras.add(uiCamera, false);
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

		player = new Kaito(x, y);
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
