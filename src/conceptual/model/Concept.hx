package conceptual.model;

interface Concept extends Linkable extends Broadcasteable {
    function add_perspective(perspective:Perspective) : Void;
    function remove_perspective(perspective:Perspective) : Void;
}
