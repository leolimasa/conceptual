package calculator.perspectives;

import calculator.interfaces.ResultHandler;
import calculator.interfaces.ExpressionEvaluator;
import conceptual.bases.SimplePerspective;


class MainCalculator extends SimplePerspective
    implements ExpressionEvaluator {

    public function evaluate_expression(expression:String):Void {
        var operations = ["+","-","*","/"];
        var result = 0;
        for (op in operations) {
            var splitted = expression.split(op);
            if (splitted.length == 2) {
                result = eval(op, splitted[0], splitted[1]);
                break;
            }
        }
        var result_handler : ResultHandler = cast get_concept();
        result_handler.display_result(Std.string(result));
    }

    private function eval(operator:String, lhs:String, rhs:String) : Int {
        var lhs_i = Std.parseInt(lhs);
        var rhs_i = Std.parseInt(rhs);
        if (operator == "+") {
            return lhs_i + rhs_i;
        }
        if (operator == "-") {
            return lhs_i - rhs_i;
        }
        if (operator == "*") {
            return lhs_i * rhs_i;
        }
        if (operator == "/") {
            return cast lhs_i / rhs_i;
        }
        return 0;
    }

    public function new() {
        super();
    }
}
