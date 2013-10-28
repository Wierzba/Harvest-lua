
-- drawing functions
function drawSquare(center, size, color)
    local x = center.x
    local y = center.y
    size = size/2
    gl.Color(color.r/255, color.g/255, color.b/255)
    gl.Begin('QUADS')
    gl.Vertex(x-size, y-size)
    gl.Vertex(x+size, y-size)
    gl.Vertex(x+size, y+size)
    gl.Vertex(x-size, y+size)
    gl.End()
end

function drawCircle(center, radius, color)
    -- works if using pixel units
    local repeats = radius * 2 * 3.1416
    local step = (1/repeats) * 2 * 3.1416
    local theta = 0.0
    
    gl.Color(color.r/255, color.g/255, color.b/255)
    gl.Begin('TRIANGLE_FAN')
    for i = 1,repeats do 
        local x = center.x + radius * math.cos(theta)
        local y = center.y + radius * math.sin(theta)
        gl.Vertex(x, y)
        theta = theta + step
    end
    gl.End()
end

function drawLine(from, to, width, color)
    -- works if using pixel units
    gl.LineWidth(width);
    gl.Color(color.r/255, color.g/255, color.b/255)
    gl.Begin('LINES');
    gl.Vertex(from.x, from.y, 0);
    gl.Vertex(to.x, to.y, 0);
    gl.End();
end
