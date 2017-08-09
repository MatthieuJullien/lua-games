BBlock = {}

BBlock.create = function(pI, pJ)
  newBBlock = {}
  newBBlock.i = pI
  newBBlock.j = pJ
  newBBlock.id = tostring(pI)..","..tostring(pJ)
  newBBlock.state = "off"
  newBBlock.timer = 0
  newBBlock.image1 = love.graphics.newImage('images/tiles/tile3.png')
  newBBlock.image2 = love.graphics.newImage('images/tiles/lava_static.png')
  return newBBlock
end

BBlock.draw = function()
  local n
  for n = #gListBBlocks, 1, -1 do
    bb = gListBBlocks[n]
    if bb.state == "on" then
      love.graphics.draw(bb.image2, Level.xMap + (bb.i - 1) * Block.WIDTH, Level.yMap + (bb.j - 1) * Block.HEIGHT)
    else
      love.graphics.draw(bb.image1, Level.xMap + (bb.i - 1) * Block.WIDTH, Level.yMap + (bb.j - 1) * Block.HEIGHT)
    end  
  end 
end

BBlock.update = function(dt)
  local n
  for n = #gListBBlocks, 1, -1 do
    bb = gListBBlocks[n]
    if bb.state == "start" then
      bb.timer = bb.timer + dt
      if bb.timer >= 0.4 then
        bb.state = "on"
      end
    elseif bb.state == "on" then
      bb.timer = bb.timer + dt
      if bb.timer >= 0.9 then
        bb.state = "off"
        bb.timer = 0
      end
    end
  end 
end

return BBlock