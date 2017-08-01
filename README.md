# elm-pure-memo

Single argument function memoization in pure elm.

Motivated by the [deprecation of elm-lang/lazy][]. This library is inspired by [eeue56/elm-lazy][] in that it makes memoization explicit. The memoized function is encapsulated as a `Memo`. Calling a memoized function returns both the result of the original function, and a new `Memo` containing the possibly newly cached result.

See the [documentation][] for examples.

[deprecation of elm-lang/lazy]:https://github.com/elm-lang/lazy/commit/c9c3f8525d22978cd7ee6e463ebf208f30fa1f91
[documentation]:http://package.elm-lang.org/packages/ktonon/elm-pure-memo/latest/Memo
[eeue56/elm-lazy]:http://package.elm-lang.org/packages/eeue56/elm-lazy/latest
