package calculator.concepts;
import calculator.interfaces.ResultHandler;
import calculator.interfaces.ExpressionEvaluator;
import conceptual.model.Linker;
import conceptual.bases.SimpleConcept;

class Calculator extends SimpleConcept
    implements ExpressionEvaluator
    implements ResultHandler {

    public function new(linker:Linker) {
        super(linker);
    }

    public function ready_for_input():Void {
        broadcast("ready_for_input");
    }

    public function evaluate_expression(expression:String) {
        broadcast("evaluate_expression", [expression]);
    }

    public function display_result(result:String) {
        broadcast("display_result", [result]);
    }
}
