package calculator.perspectives;

import calculator.interfaces.ExpressionEvaluator;
import calculator.interfaces.ResultHandler;
import conceptual.bases.SimplePerspective;

class TerminalCalculator extends SimplePerspective
    implements ResultHandler {

    public function display_result(result:String):Void {
        Sys.stdout().writeString(">> " + result + "\n");
        Sys.stdout().flush();
        var handler : ResultHandler = cast get_concept();
        handler.ready_for_input();
    }

    public function ready_for_input() {
        Sys.stdout().writeString("Write an arithmetic operation: ");
        Sys.stdout().flush();
        var input = Sys.stdin().readLine();
        var evaluator : ExpressionEvaluator = cast get_concept();
        evaluator.evaluate_expression(input);
    }

    public function new() {
        super();
    }
}
