package ;

import conceptual.bases.SimpleLinker;
import conceptual.model.Linker;
import conceptual.bases.SimpleConcept;
import conceptual.bases.SimplePerspective;
import conceptual.model.Concept;
import buddy.BuddySuite;
import mockatoo.Mockatoo;
import buddy.Should;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
using buddy.Should;

class MockPerspective1 extends SimplePerspective {
    public static var instantiated:Bool = false;

    public function new() {
        super();
        instantiated = true;
    }
}

class MockPerspective2 extends SimplePerspective {
    public static var instantiated:Bool = false;

    public function new() {
        super();
        instantiated = true;
    }
}

class SimpleLinkerTest extends BuddySuite {
    public function new() {
        super();

        describe("A simple linker", function() {
            var concept : Concept = null;
            var linker : Linker = null;
            var persp1_instantiated : Bool = false;
            var persp2_instantiated : Bool = false;
            var no_exceptions : Bool = true;

            before(function() {
                MockPerspective1.instantiated = false;
                MockPerspective2.instantiated = false;

                concept = mock(SimpleConcept);
                linker = new SimpleLinker();
                linker.link("conceptual.bases.SimpleConceptMocked", "MockPerspective1");
                linker.link("conceptual.bases.SimpleConceptMocked", "MockPerspective2");
            });

            it("should instantiate all perspectives in a linked concept", function() {
                linker.initialize(concept);
                persp1_instantiated = MockPerspective1.instantiated;
                persp2_instantiated = MockPerspective2.instantiated;
                concept.add_perspective(cast any).verify(times(2));
                persp1_instantiated.should.be(true);
                persp2_instantiated.should.be(true);
            });

            it("should not instantiate perspectives in an unlinked concept", function() {
                linker.unlink("conceptual.bases.SimpleConceptMocked", "MockPerspective1");
                linker.initialize(concept);
                persp1_instantiated = MockPerspective1.instantiated;
                persp2_instantiated = MockPerspective2.instantiated;
                persp1_instantiated.should.be(false);
                persp2_instantiated.should.be(true);
            });

            it("should register itself as the linker of the concept", function() {
                linker.initialize(concept);
                concept.set_linker(linker).verify();
                no_exceptions.should.be(true);
            });

            it("should not fail to initialize an unregistered concept", function() {
                var unregistered = new SimpleConcept();
                linker.initialize(unregistered);
                no_exceptions.should.be(true);
            });

            it("should not fail to unlink if nothing was linked", function() {
                linker.unlink("NonExistingConcept","NonExistingPerspective");
                no_exceptions.should.be(true);
            });
        });
    }
}