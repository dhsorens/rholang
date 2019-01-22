module TUPLESPACE
import SEND
import RECEIVE
import TYPE
import IS-EQUAL-TO
import PATTERN-MATCH

// (The idea is roughly this)
rule
      // Receive
      <In>
        <mailfrom> From:Name      </mailfrom>
        <guard>    Guard:NamePats </guard>
        <body>     Body:Proc      </body>
        <linear>   Linear:Bool    </linear>
      </In>
      // Send
      <Out>
        <mailto>   To:Name        </mailto>
        <msg>      Msg:Procs      </msg>
        <single>   Single:Bool    </single>
      </Out>
      =>
      <thread> ... <k> #patternMatch Msg #via Guard #in Body </k> ... </thread>
      requires #type( type[To] ) #isEqualTo #type( type[From] )

// Account for persistence with an #if #then
// Account for joins
// Account for peeks
//   ^^these last two may need a change in configuration

endmodule
