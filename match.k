require "../Syntax/rhosyntax.k"
require "../Is-In/is-in.k"
require "../Pattern-Match/pattern-match.k"

module MATCH-SYNTAX
import RHOSYNTAX
import IS-IN
import PATTERN-MATCH

endmodule

module MATCH
import MATCH-SYNTAX

// Matching by using types and the type inclusion predicate
// if a single match case
rule match P:Proc { P1:ProcPat => { P2:Proc } }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  Nil
     #fi

// if multiple match cases
rule match P:Proc { P1:ProcPat => { P2:Proc } M:MatchCases }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  match P:Proc { M:MatchCases }
     #fi

endmodule
