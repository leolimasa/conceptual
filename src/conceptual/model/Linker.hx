package conceptual.model;

interface Linker {
    function initialize(concept:Concept) : Void;
    function link(concept:String, perspective:String) : Void;
    function link_classes(cls1:Class<Dynamic>, cls2:Class<Dynamic>) : Void;
    function unlink(concept:String, perspective:String) : Void;
}
