package utils;

import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import haxe.CallStack;
import lime.app.Application;

#if sys
import sys.io.File;
import sys.FileSystem;
import Sys;
#end

class CrashHandler {
    public static function init():Void {
        Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
    }

    private static function onUncaughtError(e:UncaughtErrorEvent):Void {
        e.preventDefault();
        e.stopImmediatePropagation();

        var message:String = "Firey's Candy Bar Adventure 2 - Crash Report\n";
        message += "------------------------------------------\n";
        
        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        for (stackItem in callStack) {
            switch (stackItem) {
                case FilePos(s, file, line, column):
                    message += '$file (line $line)\n';
                case Method(classname, method):
                    message += '$classname.$method\n';
                default:
                    message += '$stackItem\n';
            }
        }

        message += "\nUncaught Error: " + e.error;

        #if sys
        try {
            var path:String = "crash_logs/";
            var dateNow:String = Date.now().toString().split(" ").join("_").split(":").join("-");
            
            if (!FileSystem.exists(path)) FileSystem.createDirectory(path);
            File.saveContent(path + "crash_" + dateNow + ".txt", message);
        } catch (err:Dynamic) {
            trace("Could not save crash log: " + err);
        }
        #end

        Application.current.window.alert(
            "The game has crashed!\n\n" + e.error + 
            "\n\nA log has been saved to the 'crash_logs' folder.",
            "Unexpected Error!"
        );
        
        #if sys
        Sys.exit(1);
        #else
        openfl.system.System.exit(1);
        #end
    }
}