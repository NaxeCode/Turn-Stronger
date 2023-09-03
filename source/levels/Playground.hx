package levels;

import entities.GameCamera;
import entities.NPC;
import entities.Player;
import entities.UiCamera;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import utils.assets.AssetPaths;
import utils.dialog.DialogueBox;
import utils.dialog.Reg;

using tweenxcore.Tools;

class Playground extends LevelBase
{
	private var frameCount = 0;

	public static var TOTAL_FRAME:Int = 120;

	public var dialogueBox:DialogueBox;

	public static var gameCamera:GameCamera;

	var uiCamera:UiCamera;

	override public function create()
	{
		super.create();

		dialogueBox = new DialogueBox();
		add(dialogueBox);

		FlxG.camera.flash(FlxColor.BLACK, 4);
		gameCamera = new GameCamera(0, 0, FlxG.width, FlxG.height, 1.50);
		uiCamera = new UiCamera(0, 0, FlxG.width, FlxG.height);

		dialogueBox.cameras = [uiCamera];
		uiCamera.ui_element.push(dialogueBox);
		trace(uiCamera.ui_element);
		dialogueBox.scrollFactor.set(0, 0);

		gameCamera.initPlayer(player);
		// var w:Float = (gameCamera.width / 4);
		// var h:Float = (gameCamera.height / 3);
		// gameCamera.deadzone = FlxRect.get((gameCamera.width - w) / 2, (gameCamera.height - h) / 2 - h * 0.25, w, h);

		FlxG.cameras.add(gameCamera, true);
		FlxG.cameras.add(uiCamera, false);
	}

	override public function update(elapsed:Float)
	{
		handleDialogBox();

		super.update(elapsed);

		FlxG.collide(collider, player);
	}

	function watchForFlip():Void
	{
		var dir = player.flipX ? "LEFT" : "RIGHT";
		bounce(dir);
	}

	function bounce(dir:String)
	{
		var movementAmount = 15;
		if (dir == "LEFT")
			movementAmount = -movementAmount;

		callCameraTween(movementAmount);
	}

	function callCameraTween(movementAmount:Int)
	{
		gameCamera.target = null;
		// FlxTween.tween(gameCamera, {"scroll.x": movementAmount}, 1, {ease: FlxEase.elasticInOut, onComplete: followPlayer});
	}

	function followPlayer(tween:FlxTween):Void
	{
		// gameCamera.focusOn(new FlxPoint(player.x, player.y));
		// gameCamera.follow(player);
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
