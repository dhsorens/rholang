require "../Type/type.k"

module IS-EQUAL-TO-SYNTAX
import TYPE

// the #isEqualTo type predicate checks to see if two types are identically equal

syntax Bool ::= Type "#isEqualTo" Type  [function]


// Semantics
// This will be the same algorithm as #isIn except it
// only checks equality and never checks if patterns
// match. This difference is at the leaves; the leaves
// only check equality.

endmodule

module IS-EQUAL-TO
import IS-EQUAL-TO-SYNTAX
