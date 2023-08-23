package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import haxe.Json;

class Tutorial extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;
	public var enemy:FlxGroup;
	public var noah:NPC;
	public var oldnoah:NPC;
	public var npcs:FlxTypedGroup<NPC>;

	public var floor:FlxObject;
	public var exitTrigger:FlxObject;

	public var dialogueBox:DialogueBox;

	static var youDied:Bool = false;

	public static var gameCamera:FlxCamera;

	var _collisionMap:FlxTilemap;

	var uiCamera:FlxCamera;

	override public function create()
	{
		super.create();

		/*
			_collisionMap = new FlxTilemap();

			var p = new DeepKnight();
			var level = p.all_levels.Your_typical_2D_platformer;

			var collisionLayer = level.l_Collisions.intGrid;
			var layerWidth = level.l_Collisions.cWid;
			// FlxStringUtil.arrayToCSV(collisionLayer, layerWidth);
			trace(collisionLayer);
		 */

		FlxG.camera.flash(FlxColor.BLACK, 4);

		var dilog_boxes:Array<String> = openfl.Assets.getText(AssetPaths.tutorial__txt).split("@@");

		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			// FlxG.sound.playMusic("assets/music/Pinksand.ogg", 0.2, true);
		}

		for (di in dilog_boxes)
		{
			trace(di);
		}

		initDialogueBox();
		initCameras();

		player = new Player(0, 0);

		initNPCS();

		level = new TiledLevel("assets/tiled/tutorial.tmx", this);

		add(level.backgroundLayer);

		add(level.objectsLayer);

		add(player);

		add(level.foregroundTiles);

		gameCamera.follow(player);
		gameCamera.zoom = 2;

		FlxG.cameras.reset(gameCamera);
		FlxG.cameras.add(uiCamera);

		FlxCamera.defaultCameras = [gameCamera];
		gameCamera.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight, true);
		dialogueBox.cameras = [uiCamera];

		dialogueBox.scrollFactor.set(0, 0);
	}

	function initDialogueBox()
	{
		dialogueBox = new DialogueBox();
		add(dialogueBox);
	}

	function initCameras()
	{
		gameCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);

		gameCamera.bgColor = 0xFF17142d;
		uiCamera.bgColor = FlxColor.TRANSPARENT;
	}

	function initNPCS()
	{
		npcs = new FlxTypedGroup<NPC>();

		noah = new NPC(0, 0);
		noah.text = "suh dude, can't a guy float in peace?";
		noah.loadGraphic(AssetPaths.Noah__png, false, 32, 64);
		noah.setFacingFlip(LEFT, true, false);
		noah.setFacingFlip(RIGHT, false, false);

		oldnoah = new NPC(0, 0);
		oldnoah.text = "Hey! This is noah's old graphic";
		oldnoah.loadGraphic(AssetPaths.Noah_no_glass__png, false, 32, 64);
		oldnoah.setFacingFlip(LEFT, true, false);
		oldnoah.setFacingFlip(RIGHT, false, false);

		npcs.add(noah);
		npcs.add(oldnoah);
		add(noah);
		add(oldnoah);

		noah.facing = LEFT;
	}

	override public function update(elapsed:Float)
	{
		handleFullScreen();

		handleDialogBox();

		super.update(elapsed);

		handleLevel();
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
					if (FlxMath.isDistanceWithin(member, player, 75))
					{
						dialogueBox.say(member.text);
						FlxTween.tween(gameCamera, {zoom: 4}, 0.5, {ease: FlxEase.backOut});
					}
				}
			}
		}
	}

	function handleLevel()
	{
		level.collideWithLevel(player);

		if (FlxG.overlap(player, floor))
		{
			youDied = true;
			FlxG.resetState();
		}
	}

	function handleEnemy(plr:FlxSprite, enm:FlxSprite)
	{
		if (enm.justTouched(CEILING) && plr.justTouched(FLOOR))
			plr.velocity.y = -plr.maxVelocity.y / 2;
		else
			plr.kill();
	}

	function handleFullScreen()
	{
		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;
	}
}
