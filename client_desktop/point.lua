Point = { 
    x = 0,
    y = 0
}

function Point:new(x, y)
    o = { x = x, y = y }
    setmetatable(o, self)
    return o
end

Point.__index = Point
setmetatable(Point, { __call = Point.new })

function distance (a, b)
    local x = b.x-a.x
    local y = b.y-a.y
    return math.sqrt(x*x + y*y)
end

function direction(a,b)
    return math.atan2(b.y-a.y, b.x-a.x)    
end
