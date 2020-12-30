local function read_data()
    file = "puzzle10.txt"
    lines = {}
    y = 0
    for line in io.lines(file) do 
        for x=0,(string.len(line) - 1) do
            char = string.sub(line, x + 1, x + 1)
            if char == "#" then 
                lines[#lines + 1] = {x,y}  
            end
        end
        y = y + 1
    end
    return lines
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

data = read_data()

best = false
asteroids_best = 0

for k,d in pairs(data) do
    asteroids = {}
    for k1,d1 in pairs(data) do
        if(k ~= k1) then
            angle = math.atan2(d[1] - d1[1], d[2] - d1[2])
            if has_value(asteroids, angle) == false then
                asteroids[#asteroids + 1] = angle 
            end
        end
    end
    if #asteroids > asteroids_best then
        best = d
        asteroids_best = #asteroids
    end
end

print(best[1],best[2])
print(asteroids_best)