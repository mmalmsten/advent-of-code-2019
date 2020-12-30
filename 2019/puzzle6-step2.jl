orbits = Dict()
open("/Users/madde/Sites/advent-of-code-2019/input/puzzle6.txt") do file
    for ln in eachline(file)
        ln = split(ln, ")")
        orbits[ln[2]]=ln[1]
    end    
end

"Get the total number of direct orbits and indirect orbits for YOU"
youOrbits = Dict()
orb = "YOU"
n = 0
while haskey(orbits, orb)
    global orb = orbits[orb]
    youOrbits[orb] = n
	global n += 1
end

"Get all orbits for SAN until reaching an orbit exisiting in youOrbits"
global orb = "SAN"
global n = 0
while haskey(orbits, orb)
    global orb = orbits[orb]
	if haskey(youOrbits, orb)
		println(youOrbits[orb] + n)
		break
	end
	global n += 1
end
