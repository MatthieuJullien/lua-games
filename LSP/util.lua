Block = require("Block")
Level = require("Level")

local Util = {}

Util.checkCollision = function(pX, pY, pW, pH)
  local left_tile = math.floor(pX / Block.WIDTH) + 1
  local right_tile = math.floor((pX + pW) / Block.WIDTH) + 1
  local top_tile = math.floor(pY / Block.HEIGHT) + 1
  local bottom_tile = math.floor((pY + pH) / Block.HEIGHT) + 1

  collision = "false"
  for i = left_tile, right_tile do
    for j = top_tile, bottom_tile do
      if j < 1 or j > Level.height then
        return "out"
      end
      blockType = string.sub(Level.map[j], i, i)
      if blockType == "" then
        collision = "out"
      elseif Block[blockType].deadly == true then
        collision = "deadly"
      elseif Block[blockType].final == true then
        collision = "final"
      elseif Block[blockType].blink == true then     
        
        local n
        for n = #gListBBlocks, 1, -1 do
          local bb = gListBBlocks[n]
          if bb.id == tostring(i)..","..tostring(j) then
            if bb.state == "off" then
              bb.state = "start"
              collision = "solid"
            elseif bb.state == "start" then
              collision = "solid"
            else
              collision = "deadly"
            end
          end
        end
      elseif Block[blockType].solid == true then
        collision = "solid"
      end
    end
  end
  return collision
end



return Util