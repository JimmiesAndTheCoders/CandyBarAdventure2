package level;

class LevelData {
    public static function arrayToCSV(grid:Array<Array<Int>>) {
        var rows = [];
        for (row in grid) {
            rows.push(row.join(","));
        }
        return rows.join("\n");
    }
}