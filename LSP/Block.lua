local Block = {}

Block.WIDTH = 32
Block.HEIGHT = 32

Block['.'] = {  
  image = love.graphics.newImage('images/tiles/blue.png'), -- void
  solid = false
}
Block['s'] = {  
  image = love.graphics.newImage('images/tiles/blue.png'), -- start
  solid = false
}
Block['d'] = {  
  image = love.graphics.newImage('images/tiles/door.png'), -- door (end)
  solid = false,
  final = true
}
Block['x'] = {  
  image = love.graphics.newImage('images/tiles/lava.png'),  
  solid = true,
  deadly = true
}
Block['b'] = {  
  image = love.graphics.newImage('images/tiles/tile3.png'),  
  blink = true
}
Block['1'] = {  
  image = love.graphics.newImage('images/tiles/tile1.png'),
}
Block['2'] = {  
  image = love.graphics.newImage('images/tiles/tile2.png'),
  solid = true
}
--tile3 used for bblock
Block['4'] = {  
  image = love.graphics.newImage('images/tiles/tile4.png'),
  solid = true
}
Block['5'] = {  
  image = love.graphics.newImage('images/tiles/tile5.png'),
  solid = true
}
Block['6'] = {  
  image = love.graphics.newImage('images/tiles/tile6.png'),
  solid = true
}
Block['7'] = {  
  image = love.graphics.newImage('images/tiles/tile7.png'), 
  solid = true
}
Block['8'] = {  
  image = love.graphics.newImage('images/tiles/tile8.png'), 
  solid = true
}
Block['9'] = {  
  image = love.graphics.newImage('images/tiles/tile9.png'), 
  solid = true
}

return Block