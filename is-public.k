module IS-PUBLIC
imports TYPE

// Determines if a name is a public channel or not
// Anything sent to or received from public channels doesn't make it into the tuple space
syntax Bool ::= "#isPublic" Name



endmodule
