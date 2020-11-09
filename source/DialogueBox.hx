package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var text:FlxText;

	public function new(X:Int = 0, Y:Int = 0, MXS:Int = 0)
	{
		super(X, Y, MXS);

		box = new FlxSprite(0, 0);
		box.makeGraphic(FlxG.width, Std.int(FlxG.height / 3), FlxColor.BLACK);
		box.alpha = 0.5;
		add(box);

		this.y = (FlxG.height - this.height);

		text = new FlxText(20, 15, FlxG.width / 2, "this is a really really really really really long sentence");
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
