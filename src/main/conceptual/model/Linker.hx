package conceptual.model;
interface Linker {
    function initialize(concept:Concept) : Void;
    function link(concept:String, perspective:String) : Void;
    function unlink(concept:String, perspective:String) : Void;
}
