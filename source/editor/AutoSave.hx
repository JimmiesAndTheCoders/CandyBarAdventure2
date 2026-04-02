package editor;

import flixel.util.FlxSave;

class AutoSave {
    var saveInstance:FlxSave;
    var timer:Float = 0;
    var interval:Float = 300;
    
    public function new() {
        saveInstance = new FlxSave();
        saveInstance.bind("EditorAutoSave");
    }

    public function update(elapsed:Float, fgData:Array<Int>, bgData:Array<Int>):Void {
        timer += elapsed;
        if (timer >= interval) {
            performSave(fgData, bgData);
            timer = 0;
        }
    }

    public function performSave(fgData:Array<Int>, bgData:Array<Int>):Void {
        saveInstance.data.fg = fgData;
        saveInstance.data.bg = bgData;
        saveInstance.flush();
        trace("Autosave complete.");
    }

    public function loadLastAutoSave():{fg:Array<Int>, bg:Array<Int>} {
        if (saveInstance.data.fg != null) {
            return {fg: saveInstance.data.fg, bg: saveInstance.data.bg};
        }
        return null;
    }
}