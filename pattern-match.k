require "../Type/type.k"
require "../Type2Proc/tupe2proc.k"

module PATTERN-MATCH-SYNTAX
import TYPE
import TYPE2PROC

// The #patternMatch function
// Performs substitutions

syntax Match ::=
              // Matching processes
                "#patternMatch" Proc "#via" ProcPat "#in" Proc
              // Matching names
              | "#patternMatch" Name "#via" NamePat "#in" Proc



endmodule

module PATTERN-MATCH
import PATTERN-MATCH-SYNTAX

endmodule
