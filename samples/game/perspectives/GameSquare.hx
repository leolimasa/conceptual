package game.perspectives;
import game.interfaces.ControlledByArrowInput;
import game.concepts.Square;
import conceptual.bases.SimplePerspective;

class GameSquare extends SimplePerspective
    implements ControlledByArrowInput {

    public function new() {
    }

    public function on_arrow_up():Void {
        get_square().increment_y(10);
    }

    public function on_arrow_down():Void {
        get_square().increment_y(-10);
    }

    public function get_square() : Square {
        return cast concept;
    }
}
