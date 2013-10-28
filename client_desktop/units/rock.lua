Rock = Actor:new()
Rock.kind = "rock"
Rock.energy = 300
function Rock:draw()
    drawCircle(self.position, 15, {r=128,g=128,b=128})
end

function Rock:update()
    if self.energy == 0 then
        self.flaggedForDeletion = true
    end
end

return Rock