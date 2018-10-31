module SEND
imports RHO-SYNTAX
imports IS-PUBLIC

// Sends
//   single
rule <thread> ... <k> N:Name !  (P:Proc)    </k> ... </thread>
 => #if #isPublic N #then
    <thread> ... <k> Nil </k> ... </thread>
    #else
    <Out>
      <mailto> N     </mailto>
      <msg>    P     </msg>
      <single> true  </single>
    </Out>
    #fi

rule <thread> ... <k> N:Name !  RT:RhoTuple </k> ... </thread>
 => #if #isPublic N #then
    <thread> ... <k> Nil </k> ... </thread>
    #else
    <Out>
      <mailto> N     </mailto>
      <msg>    P     </msg>
      <single> true  </single>
    </Out>
    #fi

//   persistent
rule <thread> ... <k> N:Name !! (P:Proc)    </k> ... </thread>
 => #if #isPublic N #then
    <thread> ... <k> Nil </k> ... </thread>
    #else
    <Out>
      <mailto> N     </mailto>
      <msg>    P     </msg>
      <single> false </single>
    </Out>
    #fi

rule <thread> ... <k> N:Name !! RT:RhoTuple </k> ... </thread>
 => #if #isPublic N #then
    <thread> ... <k> Nil </k> ... </thread>
    #else
    <Out>
      <mailto> N     </mailto>
      <msg>    P     </msg>
      <single> false </single>
    </Out>
    #fi

endmodule
