package conceptual.bases;
import conceptual.model.Concept;
import conceptual.model.Linker;
class SimpleLinker implements Linker {

    var links : Map<String, Array<String>>;

    public function initialize(concept:Concept):Void {
        concept.linker = this;
        var class_name = Type.getClassName(Type.getClass(concept));
        for (persp_class_name in links.get(class_name)) {
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

    }

    public function new() {
    }
}
