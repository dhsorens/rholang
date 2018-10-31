module MATCH
imports RHO-SYNTAX
imports IS-IN
imports PATTERN-MATCH

// Matching by using types and the type inclusion predicate
// if multiple match cases
rule match P:Proc { P1:ProcPat => { P2:Proc } M:MatchCases }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  match P:Proc { M:MatchCases }
     #fi

// if a single match case
rule match P:Proc { P1:ProcPat => { P2:Proc } }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  Nil
     #fi




endmodule
