require "point"
require'lfs'

units = { }

for file in lfs.dir[[./units]] do
    --print ("checking file " .. file)
    if lfs.attributes("./units/"..file,"mode") == "file" then 
       --print ("is a file " .. file)
       if string.sub(file, -4, -1) == ".lua" then
            print("loading file, "..file)      
            local unit = dofile("./units/" .. file)
        
            if not unit.kind then
                error "Loaded unit didn't export its kind"
            end
            
            units[unit.kind] = unit
       end
    end 
end

return units




