package samples.flxgame.interfaces;
import samples.flxgame.concepts.Control;
interface ControlContainer {
    function add_control(control : Control) : Void;
    function remove_control(control : Control) : Void;

}
