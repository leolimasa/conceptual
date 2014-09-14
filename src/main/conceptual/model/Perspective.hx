package conceptual.model;
interface Perspective extends Linkable extends Broadcasteable {
    function add_to_concept(concept:Concept):Void;
    function remove_from_concept(concept:Concept):Void;
}
