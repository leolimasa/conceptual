package game.concepts;

import game.interfaces.ControlledByArrowInput;
import conceptual.model.Linker;
import conceptual.bases.SimpleConcept;

class Square extends SimpleConcept
    implements ControlledByArrowInput {

    public function new(linker : Linker) {
        super(linker);
    }

    public function increment_x(by:Float) {
        broadcast("increment_x", [by]);
    }

    public function increment_y(by:Float) {
        broadcast("increment_y", [by]);
    }

    public function on_arrow_up():Void {
        broadcast("on_arrow_up");
    }

    public function on_arrow_down():Void {
        broadcast("on_arrow_down");
    }
}