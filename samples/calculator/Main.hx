package calculator;
import calculator.concepts.Calculator;
import conceptual.bases.SimpleLinker;
import calculator.perspectives.MainCalculator;
import calculator.perspectives.TerminalCalculator;

class Main {
    public function new() {
    }

    public static function main() {
        trace("Linking...");
        var linker = new SimpleLinker();
        linker.link("calculator.concepts.Calculator", "calculator.perspectives.MainCalculator");
        linker.link("calculator.concepts.Calculator", "calculator.perspectives.TerminalCalculator");
        trace("starting calculator");
        var calculator = new Calculator(linker);
        calculator.ready_for_input();
    }
}
