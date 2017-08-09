io.stdout:setvbuf('no')
if arg[#arg] == "-debug" then require("mobdebug").start() end

Level = require("Level")
Player = require("Player")
BBlock = require("BBlock")

-- Globals --
gGamestate = ""
gPlayer = nil
gTimer = 0
gTimerDeath = 0
gTimerLava = 0
gNbDeath = 0
gTween = {}
gListBBlocks = {}

-- Sounds --
gSoundDeath = love.audio.newSource("sounds/death.ogg", "static")
gSoundJump = love.audio.newSource("sounds/jump.ogg", "static")

local function getTimeElapsed()
  local time = math.floor(gTimer)
  sec = time % 60
  if sec < 10 then
    sec = "0"..tostring(sec)
  else
    sec = tostring(sec)
  end
  min = math.floor(time / 60)
  if min < 10 then
    min = "0"..tostring(min)
  else
    min = tostring(min)
  end
  str = min.."."..sec
  return str
end

-- LOAD --
function love.load()
  gWinWidth = love.graphics.getWidth()
  gWinHeight = love.graphics.getHeight()
  love.window.setTitle("Little Squared Platformer")
  
  love.graphics.setBackgroundColor(0, 162, 232)
  local x, y = Level.nextLevel()
  gPlayer = Player.create(x * Block.WIDTH, y * Block.HEIGHT)
end

-- HANDLE INPUT --
function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    Level.current = 0
    gTimer = 0
    gTimerDeath = 0
    gNbDeath = 0
    local x, y = Level.nextLevel()
    gPlayer = Player.create(x * Block.WIDTH, y * Block.HEIGHT)
  elseif key == "s" then
    gPlayer = Player.create(gPlayer.startx, gPlayer.starty)
  end  
end

-- UPDATE --
function love.update(dt)
  BBlock.update(dt)  
  gPlayer.update(dt)
  if gGamestate ~= "victory" then
    gTimer = gTimer + dt
    gTimerDeath = gTimerDeath + dt
    gTimerLava = (gTimerLava + dt) % 16
  end
  if gTween.time < gTween.duration then
    gTween.time = gTween.time + dt
  end
end

function initTween()
  gTween.time = 0
  gTween.value = 0
  gTween.distance = Level.xMap
  gTween.duration = 1
end

function easeOutSin(t, b, c, d)
  return c * math.sin(t/d * (math.pi/2)) + b
end

-- RENDER --
function love.draw()
  -- Affichage des titres
  love.graphics.setColor(0, 0, 255)
  local font = love.graphics.newFont("Kenney Blocks.ttf")
  love.graphics.setFont(font)
  tween = easeOutSin(gTween.time, gTween.value, gTween.distance, gTween.duration)
  love.graphics.print(Level.title1, tween, Level.yMap - 90, 0, 2, 2)
  love.graphics.print(Level.title2, tween, Level.yMap - 65, 0, 2, 2)
  
  -- Affichage du numéro du level
  local str
  if Level.current < 0 then
    str = "You Win !"
  else 
    str = "Level "..tostring(Level.current)
  end
  love.graphics.print(str, gWinWidth - tween - 50, Level.yMap + Level.heightInPx + 40, 0, 2, 2)
  
  -- Affichage du nombre d'essais
  font = love.graphics.newFont("Kenney Bold.ttf")
  love.graphics.setFont(font)
  if gNbDeath < 10 then
    love.graphics.setColor(0, 255, 0)
    if gNbDeath == 0 then
      love.graphics.print(0, 50, gWinHeight / 2 - 50, 0, 4, 4)
    else
      love.graphics.print(tostring(gNbDeath), 50, gWinHeight / 2 - 50, 0, 4, 4)
    end
  else
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(tostring(gNbDeath), 20, gWinHeight / 2 - 50, 0, 4, 4)
  end  
  imageSkull = love.graphics.newImage("images/skull.png")
  love.graphics.draw(imageSkull, 100, gWinHeight / 2 - 50)
  
  -- Affichage du temps écoulé depuis le début de la partie
  if gTimer <= 60 then
    love.graphics.setColor(0, 255, 0)
  else
    love.graphics.setColor(255, 0, 0)
  end
  love.graphics.print(getTimeElapsed(), 10, gWinHeight / 2 + 45, 0, 2, 2)
  imageTimer = love.graphics.newImage("images/timer.png")
  love.graphics.draw(imageTimer, 100, gWinHeight / 2 + 30)
  love.graphics.setColor(255, 255, 255)
  
  -- Affichge du level
  Level.draw()
  
  -- Affichage des blocs qui changent d'état (bloc 'b')
  BBlock.draw()
  
  -- Affichage du joueur
  gPlayer.drawOffset(Level.xMap, Level.yMap)
end