require "../Type/type.k"

module IS-PUBLIC-SYNTAX
import TYPE

// Determines if a name is a public channel or not
// Anything sent to or received from public channels doesn't make it into the tuplespace
syntax Bool ::= "#isPublic" Name

endmodule

module IS-PUBLIC
import IS-PUBLIC-SYNTAX

endmodule
