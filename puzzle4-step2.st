matching := 0.
284639 to: 748759 do: [:key |
    keystring := key asString.
    before := 0.
    increasing := true.
    has_two := false.
    n := 1.
    keystring do: [:number | 
        number = number asInteger.
        number < before ifTrue: [increasing := false].
        (has_two == false) & (number == before) ifTrue: [
            has_two := true.
            (n == 6) ifTrue: [
                x := keystring at: 4.
                has_two := x ~~ number
            ].
            (n == 2) ifTrue: [
                x := keystring at: 3.
                has_two := x ~~ number
            ].
            (n > 2) & (n < 6) ifTrue: [
                x := keystring at: (n + 1).
                y := keystring at: (n - 2).
                has_two := (x ~~ number) & (y ~~ number)
            ]
        ].
        before := number.
        n := n + 1
    ].  
    (increasing & has_two) ifTrue: [matching := matching + 1]
].
Transcript show: matching printString; cr.