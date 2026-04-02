package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import entities.EditorCursor;
import level.LevelGraphics;
import level.Level;
import ui.Notification;
import ui.TilePalette;
import level.MapGenerator;
import utils.LevelIO;
import editor.EditorHistory;
import editor.EditorCamera;
import editor.GridOverlay;
import editor.FloodFill;
import editor.ToolIndicator;
import editor.TilePreview;
import editor.LevelResizer;
import editor.LayerManager;
import editor.AutoSave;
import editor.LevelMetadata;
import editor.PlaytestManager;

class EditorState extends FlxState {
    var bgMap:FlxTilemap;
    var fgMap:FlxTilemap;
    var bgData:Array<Int>;
    var fgData:Array<Int>;
    var cursor:EditorCursor;
    var palette:TilePalette;
    var tilePreview:TilePreview;
    var toolIndicator:ToolIndicator;
    var grid:GridOverlay;
    var levelIO:LevelIO;
    var history:EditorHistory;
    var editorCam:EditorCamera;
    var layerMgr:LayerManager;
    var autoSaver:AutoSave;
    var metadata:LevelMetadata;

    override public function create() {
        super.create();
        bgColor = 0x141730;

        bgData = MapGenerator.generateDefaultArray();
        fgData = MapGenerator.generateDefaultArray();

        bgMap = new FlxTilemap();
        fgMap = new FlxTilemap();
        updateMaps();
        add(bgMap);
        add(fgMap);

        grid = new GridOverlay();
        add(grid);

        tilePreview = new TilePreview();
        add(tilePreview);

        cursor = new EditorCursor();
        add(cursor);

        levelIO = new LevelIO(onLevelLoaded, showNotice);
        history = new EditorHistory();
        editorCam = new EditorCamera();
        layerMgr = new LayerManager();
        
        autoSaver = new AutoSave();
        metadata = new LevelMetadata();

        palette = new TilePalette(8);
        add(palette);

        toolIndicator = new ToolIndicator();
        add(toolIndicator);

        history.save(fgData); 
        
        var lastSession = autoSaver.loadLastAutoSave();
        if (lastSession != null) {
            bgData = lastSession.bg;
            fgData = lastSession.fg;
            updateMaps();
            showNotice("Restored last session");
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        
        editorCam.update(elapsed);
        autoSaver.update(elapsed, fgData, bgData);
        updateUIFeedback();

        if (!palette.isMouseOver()) {
            handleInteraction();
        }

        handleHotkeys();
    }

    function updateUIFeedback():Void {
        var toolName = "BRUSH";
        var toolColor = flixel.util.FlxColor.WHITE;
        
        if (FlxG.keys.pressed.SHIFT) {
            toolName = "FILL";
            toolColor = flixel.util.FlxColor.CYAN;
        } else if (FlxG.mouse.pressedRight) {
            toolName = "ERASER";
            toolColor = flixel.util.FlxColor.RED;
        }

        toolIndicator.updateStatus(toolName, toolColor, layerMgr.getName());

        tilePreview.updateTile(palette.selectedTile);
        tilePreview.x = cursor.gridX * Level.TILE_SIZE;
        tilePreview.y = cursor.gridY * Level.TILE_SIZE;
        tilePreview.visible = cursor.visible && !palette.isMouseOver();
    }

    function handleInteraction():Void {
        var activeData = (layerMgr.currentLayer == FOREGROUND) ? fgData : bgData;

        if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight) {
            history.save(activeData);
        }

        if (FlxG.keys.pressed.SHIFT && FlxG.mouse.justPressed) {
            var target = activeData[cursor.gridY * Level.LEVEL_WIDTH + cursor.gridX];
            FloodFill.fill(activeData, cursor.gridX, cursor.gridY, target, palette.selectedTile);
            updateMaps();
        } else if (FlxG.mouse.pressed) {
            modifyTile(cursor.gridX, cursor.gridY, palette.selectedTile);
        } else if (FlxG.mouse.pressedRight) {
            modifyTile(cursor.gridX, cursor.gridY, 0);
        }
    }

    function handleHotkeys():Void {
        if (FlxG.keys.justPressed.TAB) {
            layerMgr.toggle();
            showNotice("Layer: " + layerMgr.getName());
            bgMap.alpha = (layerMgr.currentLayer == BACKGROUND) ? 1.0 : 0.4;
            fgMap.alpha = (layerMgr.currentLayer == FOREGROUND) ? 1.0 : 0.7;
        }

        if (FlxG.keys.justPressed.ENTER) {
            autoSaver.performSave(fgData, bgData);
            PlaytestManager.start(fgData, bgData);
        }

        if (FlxG.keys.pressed.CONTROL) {
            if (FlxG.keys.justPressed.Z) undoLastAction();
            
            if (FlxG.keys.justPressed.RIGHT) resizeAll(Level.LEVEL_WIDTH + 1, Level.LEVEL_HEIGHT);
            if (FlxG.keys.justPressed.LEFT)  resizeAll(Level.LEVEL_WIDTH - 1, Level.LEVEL_HEIGHT);
            if (FlxG.keys.justPressed.UP)    resizeAll(Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT - 1);
            if (FlxG.keys.justPressed.DOWN)  resizeAll(Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT + 1);

            if (FlxG.keys.justPressed.S) {
                autoSaver.performSave(fgData, bgData);
                showNotice("Auto-saved locally");
            }
        }

        if (FlxG.keys.justPressed.G) grid.visible = !grid.visible;
        if (FlxG.keys.justPressed.L) levelIO.load();
    }

    function resizeAll(newW:Int, newH:Int):Void {
        if (newW < 5 || newH < 5) return;
        
        history.save(fgData); 

        bgData = LevelResizer.resize(bgData, Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT, newW, newH);
        fgData = LevelResizer.resize(fgData, Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT, newW, newH);
        
        Reflect.setField(Level, "LEVEL_WIDTH", newW);
        Reflect.setField(Level, "LEVEL_HEIGHT", newH);
        
        updateMaps();
        if (grid != null) grid.refresh();
        showNotice('Resized to ${newW}x${newH}');
    }

    function modifyTile(tx:Int, ty:Int, val:Int):Void {
        if (tx >= 0 && tx < Level.LEVEL_WIDTH && ty >= 0 && ty < Level.LEVEL_HEIGHT) {
            var activeData = (layerMgr.currentLayer == FOREGROUND) ? fgData : bgData;
            var idx = ty * Level.LEVEL_WIDTH + tx;
            if (activeData[idx] != val) {
                activeData[idx] = val;
                updateMaps();
            }
        }
    }

    function undoLastAction():Void {
        if (layerMgr.currentLayer == FOREGROUND) fgData = history.undo(fgData) else bgData = history.undo(bgData);
        updateMaps();
    }

    function updateMaps() {
        var tileset = LevelGraphics.createTileset();
        bgMap.loadMapFromArray(bgData, Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT, tileset, Level.TILE_SIZE, Level.TILE_SIZE, null, 0, 1, 1);
        fgMap.loadMapFromArray(fgData, Level.LEVEL_WIDTH, Level.LEVEL_HEIGHT, tileset, Level.TILE_SIZE, Level.TILE_SIZE, null, 0, 1, 1);
    }

    function onLevelLoaded(newData:Array<Int>, title:String) {
        this.fgData = newData; 
        updateMaps();
        if (grid != null) grid.refresh();
        showNotice("Loaded: " + title);
    }

    function showNotice(msg:String) {
        var notice = new Notification(msg);
        notice.show(this);
    }
}
