require "../Is-Public/is-public.k"
require "../Syntax/rhosyntax.k"

module SEND-SYNTAX
import RHOSYNTAX
import IS-PUBLIC

endmodule

module SEND
import SEND-SYNTAX

// Sends
//   single
rule #if #isPublic N:Name
     #then
     <k> N ! (P:Proc) => . ...</k>
     #else
     <k> N ! (P:Proc) => . ...</k>
     (. => <sends>
             <mailto>  N    </mailto>
             <msg>     P       </msg>
             <single> true  </single>
           </sends>)
     #fi

rule #if #isPublic N:Name
     #then
     <k> N !  RT:RhoTuple => . ...</k>
     #else
     <k> N !  RT:RhoTuple => . ...</k>
     (. => <sends>
             <mailto>  N   </mailto>
             <msg>     RT     </msg>
             <single> true </single>
           </sends>)
     #fi

//   persistent
rule #if #isPublic N:Name
     #then
     <k> N !! (P:Proc) => . ...</k>
     #else
     <k> N !! (P:Proc) => . ...</k>
     (. => <sends>
             <mailto>   N   </mailto>
             <msg>      P      </msg>
             <single> false </single>
           </sends>)
     #fi

rule #if #isPublic N:Name
     #then
     <k> N !! RT:RhoTuple => . ...</k>
     #else
     <k> N !! RT:RhoTuple => . ...</k>
     (. => <sends>
             <mailto>   N   </mailto>
             <msg>      RT     </msg>
             <single> false </single>
           </sends>)
     #fi

endmodule

