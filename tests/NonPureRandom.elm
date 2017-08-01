module NonPureRandom exposing (int)

import Native.NonPureRandom


int : Int -> Int
int =
    Native.NonPureRandom.int
