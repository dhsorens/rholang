require "substitution.k"

module RHOSYNTAX-SYNTAX
import SUBSTITUTION
import DOMAINS-SYNTAX

// -------------
//   Processes
// -------------

// Process
syntax             Proc ::= "{" Proc "}"                                      [bracket]  // Bracket
                          | Ground                                                       // Ground terms
                          | Collection                                                   // Collection
                          | ProcVar                                                      // Process variables
                          | "Nil"                                                        // Stopped process
                          > VarRef                                                       // Variable reference
                          > "*" Name                                                     // Evaluate/Reify
                          > Proc "." Method "(" MethodArgs ")"                           // Method
                          > AExp                                                         // Arithmetic expressions
                          > Bool                                                         // Boolean expressions
                          > Name Send                                                    // Send
                          > "contract" Name "(" NamePats ")" "=" "{" Proc "}"            // Contract: needs to be given an alias which binds
                          | "for" "(" Receipt ")" "{" Proc "}"                 [binder]  // Listen
                          | "match" Proc "{" MatchCases "}"                              // Match
                          | Bundle "{" Proc "}"                                          // Bundle
                          > "if" "(" Bool ")" Proc                          [strict(1)]  // If ... then ...
                          | "if" "(" Bool ")" Proc "else" Proc              [strict(1)]  // If ... then ... else ...
                          | "new" NameDeclarations "in" "{" Proc "}"           [binder]  // New
                          > Proc "|" Proc                                        [left]  // Parallel

// Makes it so we _don't_ shadow the variable referenced
syntax           VarRef ::= "="     ProcVar
                          | "=" "*" NameVar

// General variable
syntax              Var ::= Id
syntax             Vars ::= Var
                          | Var "," Vars

// Process variable
syntax          ProcVar ::= Var
syntax         ProcVars ::= ProcVar
                          | ProcVar "," ProcVars
                          | Vars

// Ground process/value
syntax           Ground ::= Bool
                          | Int
                          | String
                          | Uri
                          | "unforgeable(" Int ")"  // The unforgeable processes used in the "new" process

// Collection
syntax       Collection ::= RhoTuple
                          | RhoList
                          | RhoSet
                          | RhoMap

//  Tuple
syntax         RhoTuple ::= "(" Proc ",)"           // Single tuple: note the ",)"
                          | "(" Proc "," Procs ")"  // Multiple tuple

//  List
syntax          RhoList ::= "[" Procs "]"

//  Set
syntax           RhoSet ::= "Set" "(" Procs ")"

//  Map
syntax           RhoMap ::= "{" RhoKeyValuePairs "}"

//   Key-value pairs
syntax RhoKeyValuePairs ::= Proc ":" Proc
                          | Proc ":" Proc "," RhoKeyValuePairs

// Expressions are anything that necessarily resolves to a single ground value or a collection
syntax             Exp  ::= Ground
                          | Collection
                          | AExp


// Arithmetic expression
syntax             AExp ::= "(" AExp ")"            [bracket]  // Parens
                          > Int "*"  Int             [strict]
                          | Int "/"  Int             [strict]
                          | Int "%%" Int             [strict]  // Remainders
                          > Int "+"  Int             [strict]
                          | Int "-"  Int             [strict]
                          | Int "++" Int             [strict]  // Plus plus
                          | Int "--" Int             [strict]  // Minus minus

// Boolean
syntax             Bool ::= "(" Bool ")"            [bracket]  // Parens
                          > Int "<"  Int
                          | Int "<=" Int
                          | Int ">"  Int
                          | Int ">=" Int
                         // Referencing processes
                          > Proc "matches" Proc
                          | Proc "==" Proc
                          | Proc "!=" Proc
                         // Connectives
                          | "not" Bool               [strict]
                          > Bool "and" Bool          [strict]
                          > Bool "or"  Bool          [strict]

// Send
syntax             Send ::= SendSingle
                          | SendMultiple

//  Single send
syntax       SendSingle ::= "!"  SendContent
                        

//  Persistent send
syntax     SendMultiple ::= "!!" SendContent

//  Content of send
syntax     SendContent  ::= "(" Proc ")"
                          | RhoTuple

// Receipts
syntax          Receipt ::= LinearBinds
                          | RepeatedBinds

//  Linear receipt
syntax       LinearBind ::= NamePats "<-" Name  // for( y <- x ){ P }
                          | NamePats "<!" Name  // Peeking

syntax      LinearBinds ::= LinearBind
                          | LinearBind ";" LinearBinds

//  Repeated receipt
syntax     RepeatedBind ::= NamePats "<=" Name

syntax    RepeatedBinds ::= RepeatedBind
                          | RepeatedBind ";" RepeatedBinds

// Match case
syntax        MatchCase ::= ProcPat "=>" Proc  [binder]
syntax       MatchCases ::= MatchCase
                          | MatchCase MatchCases

// Bundle
syntax           Bundle ::= "bundle+"  // Write bundle
                          | "bundle-"  // Read-only bundle
                          | "bundle0"  // Equiv bundle
                          | "bundle"   // Read/Write bundle

// Method
syntax       MethodArgs ::= Procs      // There is either a list of processes for args
                          | ""         // Or there is nothing

//  The list of current methods (add as more methods are defined)
syntax           Method ::= "method(nth)"
                          | "method(toByteArray)"
                          | "method(hexToBytes)"
                          | "method(union)"
                          | "method(diff)"
                          | "method(add)"
                          | "method(delete)"
                          | "method(contains)"
                          | "method(get)"
                          | "method(getOrElse)"
                          | "method(set)"
                          | "method(keys)"
                          | "method(size)"
                          | "method(length)"
                          | "method(slice)"
                          | "method(confine)"  // Not yet in the interpreter (?)


// -------------
//     Names
// -------------

// Name
syntax             Name ::= "@" Proc
                          | NameVar

// Name variable
syntax          NameVar ::= Var                   // Id
syntax         NameVars ::= NameVar               // Id or List{NameVar} or List{Var}
                          | NameVar "," NameVars
                          | Vars

// Name declaration
syntax              Uri ::= "uri(" String ")"

syntax  NameDeclaration ::= NameVar
                          | NameVar "(" Uri ")"

syntax NameDeclarations ::= NameDeclaration
                          | NameDeclaration "," NameDeclarations
                          | NameVars


// -------------
//    Both Names and Processes
// -------------

syntax            Names ::= Name
                          | Name "," Names
                          | NameVars

syntax            Procs ::= Proc
                          | Proc "," Procs
                          | ProcVars


// -------------
//    Patterns
// -------------

// Process pattern
syntax          ProcPat ::= "{" ProcPat "}"     [bracket]  // Braces
                          | CollectionPat                  // Collection patterns
                          | SimpleType                     // Simple type
                          > "~" ProcPat                    // Logical negation
                          > ProcPat "/\\" ProcPat  [left]  // Logical "and"
                          > ProcPat "\\/" ProcPat  [left]  // Logical "or"
                          > Proc                           // Process patterns can be standard processs
                          > ProcPat "|" ProcPat    [left]  // Parallel composition

syntax         ProcPats ::= ProcPat
                          | ProcPat "," ProcPats
                          | Procs

//  Collection pattern
syntax    CollectionPat ::= RhoListPat
                          | RhoSetPat

//  List pattern
syntax       RhoListPat ::= RhoList
                          | "[" ProcPats "," "..." ProcVar "]"

//  Set pattern
syntax        RhoSetPat ::= RhoSet
                          | "Set" "(" ProcPats "," "..." ProcVar ")"

// Name pattern
syntax          NamePat ::= Name         // A name pattern can be a name, or
                          | "@" ProcPat  // it can be a quoted process pattern


syntax         NamePats ::= NamePat
                          | NamePat "," NamePats
                          | Names

// General pattern, both name and process
syntax              Pat ::= NamePat      // Name pattern
                          | ProcPat      // Process pattern

syntax       SimpleType ::= "Bool"
                          | "Int"
                          | "String"
                          | "List"
                          | "Tuple"
                          | "Map"
                          | "Uri"
                          | "ByteArray"

endmodule

// -------------
//    For K
// -------------

module RHOSYNTAX
import RHOSYNTAX-SYNTAX

syntax        KVariable ::= Id
                          | ProcVar
                          | NameVar

syntax          KResult ::= Bool
                          | Int

endmodule
