package editor;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class ToolIndicator extends FlxSpriteGroup {
    var toolLabel:FlxText;
    var layerLabel:FlxText;
    var background:FlxSprite;
    
    public function new() {
        super();
        scrollFactor.set(0, 0);

        background = new FlxSprite();
        background.makeGraphic(160, 45, FlxColor.BLACK);
        background.alpha = 0.5;
        add(background);

        toolLabel = new FlxText(0, 5, 160, "TOOL: BRUSH");
        toolLabel.setFormat("assets/fonts/lounge.ttf", 10, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(toolLabel);

        layerLabel = new FlxText(0, 22, 160, "LAYER: FOREGROUND");
        layerLabel.setFormat("assets/fonts/lounge.ttf", 10, FlxColor.YELLOW, CENTER, OUTLINE, FlxColor.BLACK);
        add(layerLabel);

        x = (FlxG.width / 2) - (background.width / 2);
        y = 10;
    }

    public function updateStatus(toolName:String, toolColor:FlxColor, layerName:String):Void {
        toolLabel.text = "TOOL: " + toolName;
        toolLabel.color = toolColor;
        layerLabel.text = "LAYER: " + layerName;
    }
}