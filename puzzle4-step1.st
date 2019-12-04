matching := 0.
284639 to: 748759 do: [:key | 
    keystring := key asString.
    before := 0.
    increasing := true.
    has_two := false.
    keystring do: [:number | 
        number = number asInteger.
        number < before ifTrue: [increasing := false].
        number == before ifTrue: [has_two := true].
        before := number
    ].  
    (increasing & has_two) ifTrue: [matching := matching + 1]
].
Transcript show: matching printString; cr.