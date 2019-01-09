module SEND
import RHO-SYNTAX
import IS-PUBLIC

// Sends
//   single
rule <thread>... <k> N:Name !  (P:Proc)    </k> ...</thread>
  => #if #isPublic N
     #then
     <thread>... <k> Nil </k> ...</thread> //do we want to rewrite N!(P) to Nil?
     #else
     <Out>
       <mailto> N     </mailto>
       <msg>    P     </msg>
       <single> true  </single>
     </Out>
     #fi

rule <thread>... <k> N:Name !  RT:RhoTuple </k> ...</thread>
  => #if #isPublic N
     #then
     <thread>... <k> Nil </k> ...</thread>
     #else
     <Out>
       <mailto> N     </mailto>
       <msg>    P     </msg>               //should P be RT?
       <single> true  </single>
     </Out>
     #fi

//   persistent
rule <thread>... <k> N:Name !! (P:Proc)    </k> ...</thread>
  => #if #isPublic N
     #then
     <thread>... <k> Nil </k> ...</thread>
     #else
     <Out>
       <mailto> N     </mailto>
       <msg>    P     </msg>
       <single> false </single>
     </Out>
     #fi

rule <thread>... <k> N:Name !! RT:RhoTuple </k> ...</thread>
  => #if #isPublic N #then
     <thread>... <k> Nil </k> ...</thread>
     #else
     <Out>
       <mailto> N     </mailto>
       <msg>    P     </msg>               //should P be RT?
       <single> false </single>
     </Out>
     #fi

endmodule
