Harvester = Actor:new()
Harvester.kind = 'harvester'
function Harvester:draw()
    drawCircle(self.position, 12, {r=20,g=170,b=30})
end

function Harvester:update()
    local target = self.target
    local possibleTargets = {"rock"}
    if target then
        if target.energy > 0 then
            if self.energy > 0 then
                drawLine(self.position, self.target.position, 3, {r=80,g=220,b=120})
                --add moniez hier
                target.energy = target.energy - 1
                self.energy = self.energy - 0.005
            end
        else
            self.target = nil
        end
    else
        local neighbours = query(self.position, 100, 0, possibleTargets)
        if #neighbours > 0 then
            self.target = neighbours[math.random(1, #neighbours)]
        end
    end
end

return Harvester