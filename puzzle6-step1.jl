orbits = Dict()
open("/Users/madde/Sites/advent-of-code-2019/input/puzzle6.txt") do file
    for ln in eachline(file)
        ln = split(ln, ")")
        orbits[ln[2]]=ln[1]
    end    
end

x = 0
for orb in keys(orbits)
    while haskey(orbits, orb)
        orb = orbits[orb]
        global x += 1
    end
end

println("$(x)")