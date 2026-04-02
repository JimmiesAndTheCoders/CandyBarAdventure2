package ui;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import level.Level;
import level.LevelGraphics;

class TilePalette extends FlxSpriteGroup {
    public var selectedTile:Int = 1;
    var background:FlxSprite;
    var icons:Array<FlxSprite> = [];
    var selectionHighlight:FlxSprite;

    public function new(numTiles:Int) {
        super();
        scrollFactor.set(0, 0);

        var tilesetBmp:BitmapData = LevelGraphics.createTileset();

        background = new FlxSprite(10, FlxG.height - Level.TILE_SIZE - 20);
        background.makeGraphic(numTiles * (Level.TILE_SIZE + 10) + 10, Level.TILE_SIZE + 10, FlxColor.BLACK);
        background.alpha = 0.6;
        add(background);

        for (i in 0...numTiles) {
            var icon = new FlxSprite(20 + (i * (Level.TILE_SIZE + 10)), background.y + 5);
            var tileGraphic = new BitmapData(Level.TILE_SIZE, Level.TILE_SIZE, true, 0);
            var rect = new Rectangle(i * Level.TILE_SIZE, 0, Level.TILE_SIZE, Level.TILE_SIZE);
            tileGraphic.copyPixels(tilesetBmp, rect, new Point(0, 0));

            icon.pixels = tileGraphic;
            add(icon);
            icons.push(icon);
        }

        selectionHighlight = new FlxSprite();
        selectionHighlight.makeGraphic(Level.TILE_SIZE + 4, Level.TILE_SIZE + 4, FlxColor.TRANSPARENT);
        flixel.util.FlxSpriteUtil.drawRect(selectionHighlight, 0, 0, Level.TILE_SIZE + 4, Level.TILE_SIZE + 4, FlxColor.TRANSPARENT, {thickness: 2, color: FlxColor.YELLOW});
        add(selectionHighlight);

        updateHighlight();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.mouse.justPressed) {
            for (i in 0...icons.length) {
                if (FlxG.mouse.overlaps(icons[i])) {
                    selectedTile = i;
                    updateHighlight();
                    break;
                }
            }
        }
    }

    function updateHighlight() {
        if (icons.length > 0 && icons[selectedTile] != null) {
            selectionHighlight.setPosition(icons[selectedTile].x - 2, icons[selectedTile].y - 2);
        }
    }

    public function isMouseOver():Bool {
        return background != null && FlxG.mouse.overlaps(background);
    }
}