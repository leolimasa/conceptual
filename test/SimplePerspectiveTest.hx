package ;
import conceptual.bases.SimpleLinker;
import conceptual.model.Linker;
import conceptual.bases.SimplePerspective;
import conceptual.bases.SimpleConcept;
import conceptual.model.Perspective;
import conceptual.model.Concept;
import buddy.BuddySuite;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;
using buddy.Should;

class SimplePerspectiveTest extends BuddySuite {
    public function new() {
        describe("A simple perspective", function() {
            var concept : Concept = null;
            var perspective : Perspective = null;
            var linker : Linker = null;
            var verified : Bool = false;

            before(function() {
                concept = mock(SimpleConcept);
                linker = mock(SimpleLinker);
                concept.get_linker().returns(linker);
                perspective = new SimplePerspective();
            });

            it("attaches to the linker of the concept on addition", function() {
                perspective.add_to_concept(concept);
                perspective.get_concept().should.be(concept);
                perspective.get_linker().should.be(linker);

            });

            it("invalidates the concept and linker on removal", function() {
                perspective.remove_from_concept(concept);
                perspective.get_concept().should.be(null);
                perspective.get_linker().should.be(null);
            });

            it("forwards local broadcasts to the concept", function() {
                perspective.add_to_concept(concept);
                var arg1 = ["arg1"];
                perspective.broadcast("my_method",arg1);
                verified = concept.broadcast("my_method", arg1).verify();
                verified.should.be(true);
            });
        });
    }
}
