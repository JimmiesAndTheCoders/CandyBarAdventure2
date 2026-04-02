package editor;

class LevelMetadata {
    public var levelName:String = "Untitled Level";
    public var author:String = "Unknown Artist";
    public var description:String = "A custom level for Firey's Adventure.";

    public function new() {}

    public function serialize():Dynamic {
        return {
            name: levelName,
            author: author,
            desc: description
        };
    }
}