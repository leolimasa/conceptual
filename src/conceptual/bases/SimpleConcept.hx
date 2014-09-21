package conceptual.bases;

import conceptual.model.Perspective;
import conceptual.model.Concept;
import conceptual.model.Linker;

class SimpleConcept implements Concept {

    public var linker(get,set):Linker;
    var _linker:Linker;
    var mappings:Map<String, Array<Perspective>>;

    /**
    * If the linker is defined, it will automatically initialize this concept.
    **/
    public function new(?linker:Linker) {
        mappings = new Map<String, Array<Perspective>>();
        if (linker != null) {
            linker.initialize(this);
        }
    }

    /**
    * Grabs all the methods of the perspective and ensure they will be fired when
    * broadcast is called with the method name.
    *
    * @param {Perspective} the perspective to be added
    **/
    public function add_perspective(perspective:Perspective):Void {
        var cls = Type.getClass(perspective);
        var fields = Type.getInstanceFields(cls);
        for (field in fields) {
            var field_instance = Reflect.field(perspective, field);
            if (!Reflect.isFunction(field_instance)) {
                continue;
            }
            var mapping = mappings.get(field);
            if (mapping == null) {
                mapping = new Array<Perspective>();
                mappings.set(field, mapping);
            }
            mapping.push(perspective);
        }
        perspective.add_to_concept(this);
    }

    /**
    * Removes the perspective from this concept so that it no longer will be
    * called during broadcasts.
    *
    * This method is relatively expensive, and should be used sparingly.
    * Ideal architectures should never have to remove a perspective, since
    * they are garbage collected automatically when the concept goes out of
    * scope.
    **/
    public function remove_perspective(perspective:Perspective):Void {
        perspective.remove_from_concept(this);
        for (mapping in mappings.iterator()) {
            mapping.remove(perspective);
        }
    }

    /**
    * Calls the method specified by method_name on each perspective added
    * through add_perspective
    **/
    public function broadcast(method_name:String, ?args:Array<Dynamic>):Void {
        var perspectives = mappings.get(method_name);
        if (perspectives == null) {
            return;
        }
        for (p in perspectives) {
            Reflect.callMethod(p, Reflect.field(p, method_name), args);
        }
    }

    /**
    * Returns the linker that was used on the creation of this concept or
    * set through the linker property.
    **/
    public function get_linker():Linker {
        return _linker;
    }

    /**
    * Sets the linker that is associated to this concept
    **/
    public function set_linker(linker:Linker):Linker {
        _linker = linker;
        return linker;
    }

}
