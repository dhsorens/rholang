require "../Type/type.k"

module IS-NAME-SYNTAX
import TYPE
// the #isName predicate
// Checks to see if the type corresponds to a name, i.e. only has one inhabitant.

syntax Bool ::= "#isName" Type  [function]

endmodule

module IS-NAME
import IS-NAME-SYNTAX

// Semantics
// Starts at the leaves, 


endmodule
