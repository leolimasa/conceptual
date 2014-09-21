package;

import conceptual.bases.SimpleConcept;
import conceptual.model.Concept;
import buddy.BuddySuite;
import mockatoo.Mockatoo;
import conceptual.model.Linker;
import conceptual.bases.SimplePerspective;
import conceptual.bases.SimpleConcept;
import buddy.Should;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
using buddy.Should;

class DummyPerspective extends SimplePerspective {
    public function some_event(arg:String) {
    }
}

class SimpleConceptTest extends BuddySuite {
    public function new() {

        describe("A simple concept", function() {
            var concept: Concept = null;
            var perspective1 : DummyPerspective = null;
            var perspective2 : DummyPerspective = null;
            var linker : Linker = null;
            var verified : Bool = false;

            before(function() {

                concept = new SimpleConcept();
                perspective1 = mock(DummyPerspective);
                perspective2 = mock(DummyPerspective);
                linker = mock(Linker);

                concept.add_perspective(perspective1);
                concept.add_perspective(perspective2);

            });

            it("initializes if a linker was provided", function() {
                concept = new SimpleConcept(linker);
                verified = linker.initialize(concept).verify();
                verified.should().be(true);
            });

            it("calls the add_to_concept of the perspective", function() {
                verified = perspective1.add_to_concept(concept).verify();
                verified.should.be(true);
                verified = perspective2.add_to_concept(concept).verify();
                verified.should.be(true);
            });

            it("broadcasts actions to all perspectives", function() {
                concept.broadcast("some_event",["some_event_arg"]);
                verified = perspective1.some_event("some_event_arg").verify();
                verified.should.be(true);
            });

            it("won't fail broadcasting to methods that do not exist", function() {
                concept.broadcast("another_event");
                verified = perspective1.some_event("some_event_arg").verify(times(0));
                verified.should.be(true);
            });

            it("should not broadcast to removed perspectives", function() {
                concept.remove_perspective(perspective2);
                concept.broadcast("some_event", ["some_event_arg"]);
                verified = perspective1.some_event("some_event_arg").verify();
                verified.should.be(true);
                verified = perspective2.some_event("some_event_arg").verify(times(0));
                verified.should.be(true);
            });

            it("allows changing the associated linker", function() {
                concept.linker = null;
                concept.linker.should.be(null);
                concept.linker = linker;
                concept.linker.should.be(linker);
            });


        });
    }

}