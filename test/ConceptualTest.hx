package;

import mcover.coverage.MCoverage;
import buddy.reporting.ConsoleReporter;
import buddy.SuitesRunner;

class ConceptualTest {
    public static function main() {

        var reporter = new ConsoleReporter();
        var runner = new SuitesRunner([
            new SimpleConceptTest(),
            new SimplePerspectiveTest(),
            new SimpleLinkerTest()
        ], reporter);


        runner.run();

        var coverage_logger = MCoverage.getLogger();
        coverage_logger.report();

        return runner.statusCode();
    }
}
