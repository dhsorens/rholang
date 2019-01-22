require "../Syntax/rhosyntax.k"

module CONFIGURATION-SYNTAX
imports RHOSYNTAX

endmodule

module CONFIGURATION
import CONFIGURATION-SYNTAX

configuration 
  <T>
    <threadpool>
      <thread color="red" multiplicity="*">
        <k> $PGM:Proc </k>
      </thread>
    </threadpool>
    <tuplespace>
      <receives color="purple">
        <receive color="green" multiplicity="*">
          <fromchan> .K  </fromchan>              // list of names
          <guard>    .K     </guard>              // list of patterns
          <body>     .K      </body>
          <linear>   .K    </linear>              // Bool to determine whether or not is persistent
        </receive>
      </receives>
      <sends color="blue">
        <send color="teal" multiplicity="*">
            <tochan> .K  </tochan>                // channel
            <msg>    .K     </msg>                // message
            <single> .K  </single>                // Bool to determine whether or not is persistent
        </send>
      </sends>
    </tuplespace>
  </T>

endmodule
