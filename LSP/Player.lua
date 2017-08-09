Util = require("util")
local Player = {}

local function death()
  gSoundDeath:play()
  newPlayer.dead = true
  gNbDeath = gNbDeath + 1
  newPlayer.imageCurrent = newPlayer.image.dead
  gTimerDeath = 0
end

local function levelEnd()
  Level.reset()
  gPlayer = {}
  local x, y = Level.nextLevel()
  gPlayer = Player.create(x * Block.WIDTH, y * Block.HEIGHT)
end

Player.create = function(pX, pY)
  newPlayer = {}
  newPlayer.dead = false
  newPlayer.startx = pX
  newPlayer.starty = pY
  newPlayer.x = pX
  newPlayer.y = pY
  newPlayer.w = 20
  newPlayer.h = 20
  newPlayer.vspeed = 0
  newPlayer.hspeed = 0
  newPlayer.gravity = 600
  newPlayer.jump = 300
  newPlayer.walk = 200
  newPlayer.image = {
    toright = love.graphics.newImage("images/player_toright.png"),
    toleft = love.graphics.newImage("images/player_toleft.png"),
    dead = love.graphics.newImage("images/player_dead.png")
  }
  newPlayer.imageCurrent = newPlayer.image.toright
  
  newPlayer.update = function(dt)  
    
    if newPlayer.dead == true then
      newPlayer.imageCurrent = newPlayer.image.dead
      if gTimerDeath >= 0.5 then
        newPlayer.dead = false
        newPlayer.x = newPlayer.startx
        newPlayer.y = newPlayer.starty
        newPlayer.vspeed = 0
        newPlayer.hspeed = 0
        newPlayer.imageCurrent = newPlayer.image.toright
      end
    else
    
      -- Réduction de la vélocité (=friction)
      newPlayer.hspeed = newPlayer.hspeed * .96
      if math.abs(newPlayer.hspeed) < 0.01 then newPlayer.hspeed = 0 end
      
      -- Application de la gravité à la vitesse verticale
      newPlayer.vspeed = newPlayer.vspeed + newPlayer.gravity * dt
      
      -- Stocke la position actuelle
      local oldX = newPlayer.x
      local oldY = newPlayer.y
       
      newPlayer.x = newPlayer.x + newPlayer.hspeed * dt 
      local collision = Util.checkCollision(newPlayer.x, newPlayer.y, newPlayer.w, newPlayer.h)
      if  collision ~= "false" then   
        newPlayer.x = oldX
        if collision == "deadly" then
          death()
        elseif collision == "final" then
          levelEnd()
        end
      end
      
      newPlayer.y = newPlayer.y + newPlayer.vspeed * dt
      collision = Util.checkCollision(newPlayer.x, newPlayer.y, newPlayer.w, newPlayer.h)
      if  collision ~= "false" then  
        if newPlayer.vspeed >= 0 then
          newPlayer.vspeed = 0
        else
          newPlayer.vspeed = 1
        end
        newPlayer.y = oldY
        if collision == "deadly" then
          death()
        elseif collision == "final" then
          levelEnd()
        end
      end

      -- Détection des touches du clavier
      if love.keyboard.isDown("right") then
          newPlayer.hspeed = newPlayer.walk
          newPlayer.imageCurrent = newPlayer.image.toright
      end
    
      if love.keyboard.isDown("left") then
          newPlayer.hspeed = -newPlayer.walk
          newPlayer.imageCurrent = newPlayer.image.toleft
      end
  
      if love.keyboard.isDown("up") and collision ~= "false" and newPlayer.vspeed <= 0 then
        gSoundJump:play()
        newPlayer.vspeed = -newPlayer.jump
      end
    end
  end
  
  newPlayer.drawOffset = function(pOffsetX, pOffsetY)
      love.graphics.draw(newPlayer.imageCurrent, newPlayer.x + pOffsetX, newPlayer.y + pOffsetY)
  end
  
  return newPlayer
end

return Player