module PATTERN-MATCH
imports TYPE
imports TYPE2PROC

// The #patternMatch function
// Performs substitutions

syntax Match ::=
              // Matching processes
                "#patternMatch" Proc "#via" ProcPat "#in" Proc
              // Matching names
              | "#patternMatch" Name "#via" NamePat "#in" Proc



endmodule
