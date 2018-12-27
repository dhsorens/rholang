# Rholang
This is the most up-to-date K Framework for Rholang. It will kompile in K5, but apart from the structural type system implemented in `type.k`, most of the rest of the code is just an outline.

This design is minimalist in the number of cells required in the configuration. Modulo small modifications to accommodate joins in receives, the configuration probably doesn't need to change
or get more cells.

Most of the computation in matching is done via the structural type system. The type system is set up in such a way that pattern-matching is type inclusion. Thus, pattern matching is done via the type inclusion predicate `#isIn` in `is-in.k`.

Generating a type does not require any extra cells in the configuration because we use strict functions with carefully chosen syntactic categories so that K will do those computations for us, without needing to outline the exact computation somewhere in a cell. That means we only need threads with a `<k>`-cell and a tuplespace to model Rholang's computation.

The auxiliary functions `#isEqualTo`, `#isProc`, `#isName`, `#type2proc`, etc. should also lend themselves to computation with strict functions instead of explicit cells. The inclusion predicate is nearly finished, except for some comments in the algorithm itself.

The tuplespace is modeled in `tuple-space.k`. The rules for matching ought to be able to match simply by using a `required` clause at the end (see the given e.g. rule). That makes it so we don't have to explicitly keep track of which matches have been checked. How to handle joins is still an unsolved problem, but I suspect one could either slightly modify the type system or write a nice function, without using cells, to do it.

Rules should be written without cells as much as possible.

## Type System
The type system is the mathematical core of the framework, and greatly simplifies pattern-matching in a nice, coherent theory. In Rholang, any program can be thought of as a pattern that only matches to one thing. This observation unifies all of Rholang code as patterns.

In this line of thought, for each pattern (or process) in Rholang we can assign a type, written as an abstract syntax tree (AST). The AST is defined recursively. For example:
```
    for( NamePatterns <- Channel ){ Body }
```

might yield
```
                      "LinearListen"
                       /          \
                    "bind"       type(Channel)
                    /    \
    type(NamePatterns)  type(Body)
```

A pattern such as
```
    Name!(TupleOfProcesses)
```

might yield something like
```
          "SingleSend"
           /        \
    type(Name)    type(TupleOfProcesses)
```

and
```
    @{Process}
```

might yield something like
```
       "quote"
          |
    type(Process)
```

*(Note that the resulting type doesn't have to be a binary tree, but in the implementation it is for simplicity. In cases like quote, the second branch is a special `#truncate` node.)*

We complete the AST recursively by expanding along the leaves.

For Rholang, this kind of type system is natural because terms are defined and matched in an inherently recursive way. When we match, we check that the top level matches, and then move inward. Since this type system is explicitly for matching, we think of a listen (`for`) as purely syntax, and not as a tagged function type where the tag is the channel it's listening on and the function type is `type(NamePatterns) -> type(Body)`. In the future, it might be useful to enrich the type system to include this, or to give channels types that include the pattern being listened for, or the pattern being sent. This might open the door to a more extensive set of provable properties for Rholang code.

The type system's full definition can be found in `type.k`. Each node has the syntax
```
    [ "NodeName" ;; type[LeftNode] ;; type[RightNode] ]
```

which is a format admittedly difficult for a human to read, but natural for K.

## The Inclusion Predicate
A `Process` matches a `Pattern` if one can start with `type(Pattern)` and end up with `type(Process)` by doing any combination of the following:
- attaching a process onto a free process variable leaf on `type(Pattern)`
- attaching a name onto a free name variable leaf on `type(Pattern)`
- attaching anything to a free wildcard leaf on `type(Pattern)`
- attaching anything to a simple type leaf on `type(Pattern)` that matches the simple type
- choosing one of the subtrees spawning from a free `\/` node on `type(Pattern)`
- replacing the subtree spawning from a free `/\` node into a type matching both of the branches in `type(Pattern)` and the corresponding subtree in `type(Process)`
- replacing the subtree spawning from a free `~` with a subtree whose type does *not* match that subtree

Here "free" refers to a subtree that's not part of a self contained pattern within the term. One could think of `/\` and `\/` alternatively as type unions and intersections. The inclusion predicate `#isIn` checks that these steps can be made via a recursive algorithm outlined in `is-in.k` and rewrites to a boolean.

## Equality of Types
We say two types are equal iff `Type1 #isIn Type2` and `Type2 #isIn Type1` are both `true`. This is just checking tree equality.


## Deciding if a type corresponds to a process or a name
The predicate `#isProc` (resp. `#isName`) checks to see that a given type is a process (resp. name), which checks that they only match one process (resp. name), or that the type only has one inhabitant.

This amounts to checking that there are no globally free variables (i.e. free variable leaves), or wildcards outside of self-contained patterns, or logical connectives where they ought not be, etc. Essentially, checking that the operations for inclusions don't yield any other types.

## Future work
Formal writeup and proof that this type system behaves as intended. It would make for a good paper.

The finished implementation will come with a detailed exposition of the type system, along with these proofs.

