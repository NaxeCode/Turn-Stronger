package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var text:String;

	public var typeText:TypeText;

	public function new(X:Int = 0, Y:Int = 0, MXS:Int = 0)
	{
		super(X, Y, MXS);

		initGraphicBox();
		initTypeText();
		this.visible = false;
	}

	function initGraphicBox()
	{
		box = new FlxSprite(0, 0);
		box.makeGraphic(FlxG.width, Std.int(FlxG.height / 3), FlxColor.BLACK);
		box.alpha = 0.5;
		add(box);

		this.y = (FlxG.height - this.height);
	}

	function initTypeText()
	{
		typeText = new TypeText(15, 10, this.box.frameWidth,
			"Hello, this is a good example of some pretty long text that has to be typed down by any given character parsing dialog :)", 20);
		add(typeText);
	}

	public function say(dialog:String)
	{
		Reg.canMove = false;
		typeText.resetText(dialog);
		this.visible = true;
		typeText.start(0.1, false, false, null);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.visible == true) {}
		else {}
	}
}
