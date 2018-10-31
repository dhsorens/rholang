# Rholang
This is the most up-to-date K-Framework for Rholang. It will kompile in K5, but apart from the
structural type system implementation in `type.k`, most of the rest of the code is just an outline.

This design is minimalist in the number of cells required in the configuration. Apart from small
modifications to accommodate joins in receives, the configuration probably doesn't need to change
or get more cells.

Most of the computation for matching is done via the structural type system. The type system is set
up in such a way that pattern-matching is type inclusion, and so pattern matching is done via the
type inclusion predicate `#isIn` in `is-in.k`.

Generating a type does not require any extra cells in the configuration because we use strict
functions with carefully chosen syntactic categories so that K will do those computations for us,
without needing to outline the exact process somewhere in a cell. That means we only need threads
with a `<k>`-cell and a tuple space to model Rholang's computation.

The auxiliary functions `#isEqualTo`, `#isProc`, `#isName`, `#type2proc`, etc. should also lend
themselves to computation with strict functions instead of explicit cells. In particular, `#isIn`
is nearly finished, except for some comments in the algorithm itself.

The tuple space is modeled in `tuple-space.k`. The rules for matching ought to be able to match
simply by using a `required` clause at the end (see the given e.g. rule). That makes it so we don't
have to explicitly keep track of which matches have been checked. How to handle joins is still an
unsolved problem, but I suspect one could either modify the type system slightly or write a nice
function, without using cells, to do it.

Rules should be written without cells as much as possible.

## Type System
The type system is the mathematical core of the framework, and greatly simplifies pattern-matching
in a nice, coherent theory. In Rholang, any program can be thought of as a pattern that only matches
to one thing. 
