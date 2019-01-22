require "../Type/type.k"
require "../Syntax/rhosyntax.k"

module PROCESSES-SYNTAX
import RHOSYNTAX
import TYPE

endmodule

module PROCESSES

// Semantics for basic processes

// Ground terms
rule _:Ground      => .K

// Collection
rule _:Collection  => .K

// Variables (this should be redundant)
rule _:ProcVar     => .K
rule _:NameVar     => .K

// The empty process
rule Nil           => .K

// Quoting and evaluating i.e. * and @ are inverses
rule * @{ P:Proc } =>  P
rule @{ * N:Name } =>  N

// Arithmetic expressions
rule E1:AExp *  E2:AExp => E1  *Int E2
rule E1:AExp /  E2:AExp => E1  /Int E2
rule E1:AExp %% E2:AExp => E1 %%Int E2
rule E1:AExp +  E2:AExp => E1  +Int E2
rule E1:AExp -  E2:AExp => E1  -Int E2
rule E1:AExp ++ E2:AExp => E1 ++Int E2
rule E1:AExp -- E2:AExp => E1 --Int E2

// Boolean expressions
rule I1:Int <  I2:Int => I1 <Int  I2
rule I1:Int <= I2:Int => I1 <=Int I2
rule I1:Int >  I2:Int => I1 >Int  I2
rule I1:Int >= I2:Int => I1 >=Int I2
rule I1:Int == I2:Int => I1 =Int I2
rule I1:Int != I2:Int => not (I1 =Int I2)

rule not true        => false
rule not false       => true
rule true  and true  => true
rule false and true  => false
rule true  and false => false
rule true   or false => true
rule false  or true  => true
rule false  or false => false

rule P1:Proc matches P2:Proc => #type( type[P1] ) #isIn      #type( type[P2] )
rule P1:Proc ==      P2:Proc => #type( type[P1] ) #isEqualTo #type( type[P2] )
rule P1:Proc !=      P2:Proc => not {P1 == P2}

// If ... then ... (else ...)
rule if ( B:Bool ) P1:Proc else P2:Proc => #if B #then P1 #else P2  #fi
rule if ( B:Bool ) P1:Proc              => if (B)      P1  else Nil

// New
rule new X:NameVar in { P:Proc }
  => P[ X / @{ unforgeable( !N:Int ) } ]
// unclear what to do with registries
// rule new X:NameVar ( U:Uri ) in { P:Proc }

rule new X:NameVar           NDs:NameDeclarations in { P:Proc }
  => new X    in { new NDs in { P } }
rule new X:NameVar ( U:Uri ) NDs:NameDeclarations in { P:Proc }
  => new X(U) in { new NDs in { P } }

// Parallel Processes
// Note that this separation happens from the left b/c of the way the syntax is written
// i.e. P1 | P2 | P3 first separates into P1 and P2 | P3 and then into P1, P2, and P3.
rule <k> P1:Proc | P2:Proc </k> => <k> P1 </k> <k> P2:Proc </k>

endmodule
