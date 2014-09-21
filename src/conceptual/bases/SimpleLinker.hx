package conceptual.bases;

import conceptual.model.Concept;
import conceptual.model.Linker;
class SimpleLinker implements Linker {

    /**
    * A map of a concept class name and all the associated perspective class
    * names.
    **/
    var links : Map<String, Array<String>>;

    public function new() {
        links = new Map<String, Array<String>>();
    }

    public function initialize(concept:Concept):Void {
        concept.set_linker(this);
        var class_name = Type.getClassName(Type.getClass(concept));
        var perspective_names = links.get(class_name);
        if (perspective_names == null) {
            return;
        }
        for (persp_class_name in perspective_names) {
            var cls = Type.resolveClass(persp_class_name);
            var inst = Type.createInstance(cls, []);
            concept.add_perspective(inst);
        }
    }

    public function link(concept:String, perspective:String):Void {
        var concept_array : Array<String> = links.get(concept);
        if (concept_array == null) {
            concept_array = new Array<String>();
            links.set(concept, concept_array);
        }
        concept_array.push(perspective);
    }

    public function unlink(concept:String, perspective:String):Void {
        var concept_array : Array<String> = links.get(concept);
        if (concept_array == null) {
            return;
        }
        concept_array.remove(perspective);
    }
}
