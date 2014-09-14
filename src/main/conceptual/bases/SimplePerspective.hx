package conceptual.bases;
import conceptual.model.Concept;
import conceptual.model.Linker;
import conceptual.model.Perspective;

class SimplePerspective implements Perspective {

    public var linker(get, set):Linker;
    var _linker:Linker;
    var concept:Concept;

    public function new() {}

    public function get_linker():Linker {
        return _linker;
    }

    public function set_linker(linker:Linker):Linker {
        _linker = linker;
        return linker;
    }

    public function add_to_concept(concept:Concept):Void {
        this.concept = concept;
        linker = concept.linker;
    }

    public function remove_from_concept(concept:Concept):Void {
        this.concept = null;
        linker = null;
    }

    public function broadcast(method_name:String, ?args:Array<Dynamic>):Void {
        concept.broadcast(method_name, args);
    }
}
