module RECEIVE
imports RHO-SYNTAX
imports IS-PUBLIC

// Receives
// Linear
rule <thread> ... <k> for( Ptn:NamePats <- Chn:Name ){ Body:Proc } </k> ... </thread>
  => #if #isPublic Chn #then
     <thread> ... <k> Nil </k> ... </thread>
     #else
     <In>
       <mailfrom> Chn  </mailfrom>
       <guard>    Ptn  </guard>
       <body>     Body </body>
       <linear>   true </linear>
     </In>
     #fi

// Peek
//rule <thread> ... <k> for( Ptn:NamePats <! Chn:Name ){ Body:Proc } </k> ... </thread>

// Repeated
rule <thread> ... <k> for( Ptn:NamePats <= Chn:Name ){ Body:Proc } </k> ... </thread>
  => #if #isPublic Chn #then
     <thread> ... <k> Nil </k> ... </thread>
     #else
     <In>
       <mailfrom> Chn  </mailfrom>
       <guard>    Ptn  </guard>
       <body>     Body </body>
       <linear>   true </linear>
     </In>
     #fi

// Contracts
rule contract N:Name ( NPs:NamePats ) = { Body:Proc }
  => for( NPs <= N ){ Body } [alias]

// Joined Receives
//rule <thread> <k> for( Ptn:NamePats <- Chn:Name ; LinearBinds   ){ Body:Proc } </k> </thread>
//rule <thread> <k> for( Ptn:NamePats <! Chn:Name ; LinearBinds   ){ Body:Proc } </k> </thread>
//rule <thread> <k> for( Ptn:NamePats <= Chn:Name ; RepeatedBinds ){ Body:Proc } </k> </thread>


endmodule
