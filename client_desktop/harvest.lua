require "point"
require "drawing"

-- harvest game logic
Actor = {
    id = nil,
    energy = 0,
    position = Point(0,0),
    kind = "actor", -- turret, rock, plant
}
lastActorId = 1
function Actor:new(o)
    o = o or { }
    setmetatable(o, self)
    self.__index = self
    
    o.id = lastActorId
    o.position = Point(0,0)
    lastActorId = lastActorId + 1
    return o
end
function Actor:update() end

---------------------
-- Actual game logic

objects = { }
clickmode = 'idle' -- 'build_turret' etc.

function update()
    for _,object in pairs(objects) do
        object:update()
    end
    for _,object in pairs(objects) do
           if object.flaggedForDeletion then
            objects[_] = nil
        end
    end
end

function draw()
    for _,object in pairs(objects) do
        object:draw()
    end
end

units = require"units"

function mouse_callback(but, pressed, x, y, status)
    if but == iup.BUTTON3 and pressed==1 then clickmode = 'idle' end

    local modemappings = {
        build_harvester = units.harvester,
        build_energylink = units.energy_link,
        build_solarplant = units.solar_plant,
        build_rock = units.rock
    }
    if clickmode ~= 'idle' then
        print ("building "..clickmode)
        m = modemappings[clickmode]
        o = m:new()
        o.position.x, o.position.y = x,y
        table.insert(objects, o)
    end
end

function keyboard_callback(key)
    if key == iup.K_h then clickmode = 'build_harvester' end
    if key == iup.K_s then clickmode = 'build_solarplant' end
    if key == iup.K_e then clickmode = 'build_energylink' end
    if key == iup.K_r then clickmode = 'build_rock' end --for debug
end

function query(location, range, idFilter, kindFilter) 
    local function icontains(table, elem)
        for k,v in ipairs(table) do
            if v == elem then
                return true
            end
        end
        return false
    end

    kindFilter = kindFilter or { }

    local result = { }
    for _,object in pairs(objects) do
        if distance(object.position, location) <= range then
            if object.id ~= i then
                if icontains(kindFilter, object.kind) then
                    table.insert(result, object)
                end
            end
        end
    end
    return result
end


