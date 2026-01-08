package;

import flixel.FlxG;

class StateController {
    public static function checkToggle():Void {
        if (FlxG.keys.justPressed.TAB) {
            if (Std.isOfType(FlxG.state, PlayState)) {
                FlxG.switchState(() -> new EditorState());
            } else {
                FlxG.switchState(() -> new PlayState());
            }
			
		}
    }
}