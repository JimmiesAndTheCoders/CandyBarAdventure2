package editor;

enum LayerID {
    BACKGROUND;
    FOREGROUND;
}

class LayerManager {
    public var currentLayer:LayerID = FOREGROUND;

    public function new() {}

    public function toggle():Void {
        currentLayer = (currentLayer == FOREGROUND) ? BACKGROUND : FOREGROUND;
    }

    public function getName():String {
        return (currentLayer == FOREGROUND) ? "FOREGROUND" : "BACKGROUND";
    }
}