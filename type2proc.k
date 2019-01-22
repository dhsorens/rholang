require "../Type/type.k"

module TYPE2PROC-SYNTAX
import TYPE
// Converts a process's type back to the original process (or something equivalent to it)

syntax Proc ::= "#type2proc" Type

// Sort of a reverse to the type generator. This is for substitution in the `pattern-match`
// module.

endmodule

module TYPE2PROC
import TYPE2PROC-SYNTAX

endmodule
