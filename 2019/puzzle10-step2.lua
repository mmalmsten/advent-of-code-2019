-- Read data from file and import to table
local function read_data()
    file = "input10.txt"
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

-- Check if table "tab" has value "val"
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- Find the monitoring_station location for the new monitoring station
local function place_monitoring_station (data)
    monitoring_station = false
    asteroids_monitoring_station = 0
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
        if #asteroids > asteroids_monitoring_station then
            monitoring_station = d
            asteroids_monitoring_station = #asteroids
        end
    end
    return monitoring_station
end

-- Get the distance and angle of the other asteroids in relation to the monitoring station
local function list_asteroids(data)
    asteroids = {}
    for k,d in pairs(data) do
        if(d ~= monitoring_station) then
            dist = math.sqrt(math.abs(
                (monitoring_station[2] - d[2]) * 2 + 
                (monitoring_station[1] - d[1]) * 2))
            angle = 0 - math.atan2(
                monitoring_station[1] - d[1], monitoring_station[2] - d[2])
            if(angle < 0) then angle = 360 + angle end
            asteroids[#asteroids + 1] = {angle, dist, d}
        end
    end
    table.sort(asteroids, function(a, b) 
        if(a[1] < b[1]) then return true
        elseif(a[1] == b[1]) then return a[2] < b[2]
        else return false end
    end)
    return asteroids
end

-- In clockwise order, vaporize closest asteroids
local function vaporize_asteroids (asteroids, vaporized)
    remaining = {}
    for k,d in pairs(asteroids) do
        if d[1] == before then 
            remaining[#remaining + 1] = d 
        else
            before = d[1]
            vaporized = vaporized + 1
        end
        if vaporized == vaporize_nth then return d end
    end
    return vaporize (remaining, vaporized)
end

vaporize_nth = 200
data = read_data()
monitoring_station = place_monitoring_station(data)
asteroids = list_asteroids(data)
nth_vaporized = vaporize_asteroids(asteroids, 0)
result = nth_vaporized[3][1] * 100 + nth_vaporized[3][2]
print(result)