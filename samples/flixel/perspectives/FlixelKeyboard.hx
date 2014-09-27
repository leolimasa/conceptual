package flixel.perspectives;
import conceptual.bases.SimplePerspective;
import game.interfaces.ControlledByArrowInput;

class FlixelKeyboard extends SimplePerspective {

    var flxState:FlxState;

    public function new() {
    }

    public function set_flixel_state(scene:FlxState) {
       flxState = scene;

    }

    public function get_controlled_concept() : ControlledByArrowInput {
        return cast concept;
    }


}
