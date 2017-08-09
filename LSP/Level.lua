Maps = require("Maps")
Block = require("Block")
BBlock = require("BBlock")


local Level = {}

Level.current = 0
Level.reset = function()
  Level.mapInfos = nil
  Level.map = nil
  Level.title1 = ""
  Level.title2 = ""
  Level.xMap = 0
  Level.yMap = 0
  Level.width = 0
  Level.height = 0
end

local function victory()
  Level.reset()
  gGamestate = "victory"
  Level.current = -1
  Level.title1 = "Victory !!!"
  Level.title2 = "R to restart the game"
  Level.width = 1
  Level.height = 1
  Level.map = {"s"}
  Level.widthInPx = Block.WIDTH
  Level.heightInPx = Block.HEIGHT
  Level.xMap = (gWinWidth - Level.widthInPx) / 2
  Level.yMap = (gWinHeight - Level.heightInPx) / 2
end

Level.nextLevel = function()
  Level.current = Level.current + 1
  Level.mapInfos = Maps.mapInfos[Level.current]
  if Level.mapInfos == nil then
    victory()
    return 0, 0
  end
  gGamestate = "ingame"
  Level.title1 = Level.mapInfos[1]
  Level.title2 = Level.mapInfos[2]
  Level.width = Level.mapInfos[3]
  Level.height = Level.mapInfos[4]
  Level.map = Level.mapInfos[5]
  Level.widthInPx = Level.width * Block.WIDTH
  Level.heightInPx = Level.height * Block.HEIGHT
  Level.xMap = (gWinWidth - Level.widthInPx) / 2
  Level.yMap = (gWinHeight - Level.heightInPx) / 2
  initTween()
  
  gListBBlocks = {}
  local x, y
  for line = 1, Level.height do
    for pos = 1, Level.width do
      char = string.sub(Level.map[line], pos, pos)
      if char == 's' then
        x = pos - 1
        y = line - 1
      elseif char == 'b' then 
        table.insert(gListBBlocks, BBlock.create(pos, line))
      end
    end
  end
  return x, y
end

Level.draw = function()
  local line, pos
  local blockType  
  for line = 1, Level.height do
    for pos = 1, Level.width do
      blockType = string.sub(Level.map[line], pos, pos)
      if blockType == 'x' then
        local x, y
        local timer = math.floor(gTimerLava * 4)
        x = timer % 4 * Block.WIDTH
        y = math.floor(timer / 16) * Block.HEIGHT
        quad = love.graphics.newQuad(x, y, Block.WIDTH, Block.HEIGHT, Block[blockType].image:getDimensions())
        love.graphics.draw(Block[blockType].image, quad, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
      else
        love.graphics.draw(Block[blockType].image, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
      end
    end
  end
  
  line = 0
  for pos = 0, Level.width + 1 do
    love.graphics.draw(Block['9'].image, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
  end
  line = Level.height + 1
    for pos = 0, Level.width + 1 do
    love.graphics.draw(Block['9'].image, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
  end
  
  pos = 0
  for line = 1, Level.height do
    love.graphics.draw(Block['9'].image, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
  end
  pos = Level.width + 1
    for line = 1, Level.height do
    love.graphics.draw(Block['9'].image, Level.xMap + (pos - 1) * Block.WIDTH, Level.yMap + (line - 1) * Block.HEIGHT)
  end
end

return Level