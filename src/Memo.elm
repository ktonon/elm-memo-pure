module Memo exposing (Memo, memo, call)

{-| Memoization library in pure elm.

@docs Memo, memo, call
-}

import Dict exposing (Dict)


{-| A memoized single argument function.
-}
type Memo comparable result
    = Memo (comparable -> result) (Dict comparable result)


{-| Creates a memoized single argument function.

The argument to `memo` is the function which will be memoized. Only single
argument functions for which the argument is comparable can be memoized.
Use [Memo.call](#call) to apply the function to an argument.

    memo (\x -> x * x)
-}
memo : (comparable -> r) -> Memo comparable r
memo func =
    Memo func Dict.empty


{-| Calls a memoized single argument function.

The output of the function is a tuple `(newMemo, result)`, for example:

    let
        m0 = memo (\x -> x * x)
        m1 = call m0 4 |> Tuple.first
    in
        [ (call m0 4 |> Tuple.first)  /= m0
        , (call m1 4 |> Tuple.first)  == m1
        , (call m0 4 |> Tuple.second) == 16
        , (call m1 4 |> Tuple.second) == 16
        ]
        |> List.all identity
    --> True

To work with values that are not comparable, first map them to a comparable
value with a hash function and compose with a call to the memoized function:

    import TestHelpers exposing (Person)

    let
        barney = Person "Bob" 3
        hash = (\person -> ( person.name, person.age ))
        m0 = memo (\(name, age) -> List.repeat age name)
        m1 = (hash >> call m0) barney |> Tuple.first
    in
        [ (==)
              ((hash >> call m1) barney |> Tuple.first)
              m1
        , (==)
              ((hash >> call m1) barney |> Tuple.second)
              ["Bob", "Bob", "Bob"]
        ]
        |> List.all identity
    --> True

You can be sure that the source function is only called when needed. This
example shows how a non-pure (natively implemented) function is not called twice
for the same argument:

    import NonPureRandom as Random

    let
        upper = 1000000000
        randIntMemo = call (memo Random.int) upper
            |> Tuple.first
    in
        [ (/=)
              (Random.int upper)
              (Random.int upper)
        , (==)
              (call randIntMemo upper |> Tuple.second)
              (call randIntMemo upper |> Tuple.second)
        ]
        |> List.all identity
    --> True
-}
call : Memo comparable r -> comparable -> ( Memo comparable r, r )
call memo arg =
    case memo of
        Memo func dict ->
            case Dict.get arg dict of
                Just result ->
                    ( Memo
                        func
                        dict
                    , result
                    )

                Nothing ->
                    let
                        result =
                            func arg
                    in
                        ( Memo
                            func
                            (Dict.insert arg result dict)
                        , result
                        )
