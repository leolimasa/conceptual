package conceptual.model;

interface Linkable {
    var linker(get, set):Linker;

    function get_linker():Linker;
    function set_linker(linker:Linker):Linker;
}
