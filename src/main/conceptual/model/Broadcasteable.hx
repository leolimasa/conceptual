package conceptual.model;
interface Broadcasteable {
    function broadcast(method_name:String, ?args:Array<Dynamic>) : Void;
}
