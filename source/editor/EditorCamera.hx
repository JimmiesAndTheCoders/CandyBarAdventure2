package editor;

import flixel.FlxG;
import flixel.math.FlxPoint;

class EditorCamera {
    var lastMousePos:FlxPoint = FlxPoint.get();
    var isDragging:Bool = false;

    public function new() {}

    public function update(elapsed:Float):Void {
        if (FlxG.mouse.justPressedMiddle || (FlxG.keys.pressed.SPACE && FlxG.mouse.justPressed)) {
            isDragging = true;
            lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);
        }

        if (isDragging) {
            var dx = lastMousePos.x - FlxG.mouse.viewX;
            var dy = lastMousePos.y - FlxG.mouse.viewY;
            
            FlxG.camera.scroll.x += dx;
            FlxG.camera.scroll.y += dy;
            
            lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);

            if (FlxG.mouse.justReleasedMiddle || (FlxG.keys.justReleased.SPACE) || FlxG.mouse.justReleased) {
                isDragging = false;
            }
        }

        if (FlxG.mouse.wheel != 0) {
            FlxG.camera.zoom += FlxG.mouse.wheel * 0.1;
            if (FlxG.camera.zoom < 0.5) FlxG.camera.zoom = 0.5;
            if (FlxG.camera.zoom > 3.0) FlxG.camera.zoom = 3.0;
        }
    }
}