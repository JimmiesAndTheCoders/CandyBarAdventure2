package editor;

import flixel.FlxG;
import states.PlayState;
import Type;
import Reflect;

class PlaytestManager {
    /**
     * @param fgData
     * @param bgData
     */
    public static function start(fgData:Array<Int>, bgData:Array<Int>):Void {
        var dataObj:Dynamic = {
            fg: fgData.copy(),
            bg: bgData.copy()
        };

        try {
            var stateControllerClass:Class<Dynamic> = Type.resolveClass("data.StateController");
            
            if (stateControllerClass != null) {
                Reflect.setField(stateControllerClass, "tempLevelData", dataObj);
            } else {
                trace("Error: Could not resolve class 'data.StateController'. Ensure the package and class name are correct.");
            }
        } catch (e:Dynamic) {
            trace("Exception while setting tempLevelData via Reflection: " + e);
        }
        
        FlxG.switchState(() -> new PlayState());
    }
}