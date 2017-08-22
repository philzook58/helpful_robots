function destroyerFactory()
  obj = {
    class = "destroyer",
    color = {255, 0, 0, 255},
    action = function (tile)
      return emptyFactory()
    end,
    isBlocking = true,
    isMovable = true
  }
  return obj
end

function pusherFactory()
  obj = {
    class = "destroyer",
    color = {255, 0, 0, 255},
    action = function (tile)
      return emptyFactory()
    end,
    isBlocking = true,
    isMovable = true
  }
  return obj
end

function emptyFactory()
  obj = {
    class = "empty",
    color = {100, 100, 100, 255},
    isBlocking = false,
    isMovable = false
  }
  return obj
end

function wallFactory()
  obj = {
    class = "wall",
    color = {0, 0, 0, 255},
    hasAction = false,
    isBlocking = true,
    isMovable = false
  }
  return obj
end

function love.load()
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   --love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   num = 3
   speed = 200
   grid = {}
   lock = false
   for x=1,10 do
     grid[x] = {}
     for y=1,10 do
       grid[x][y] = emptyFactory()
     end
   end
   grid[3][4] = destroyerFactory()
   grid[6][6] = wallFactory()
   grid[6][7] = wallFactory()
   grid[6][8] = wallFactory()
end

function drawgrid()
  for x=1,10 do
    for y=1,10 do
      love.graphics.setColor(grid[x][y].color)
      love.graphics.circle("fill", 50*x, 50*y, 30, 5)
    end
  end
end


function isValidMove(x,y)
  if x > 10 or x < 1 or y > 10 or y < 1 then
    return false
  elseif grid[x][y].isBlocking then
    return false
  else
    return true
  end
end

function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function love.update(dt)
   local dx = 0
   local dy = 0
   local action = false
   if not lock and love.keyboard.isDown("up") then
      dy = -1
      lock = true
   end
   if not lock and love.keyboard.isDown("down") then
      dy = 1
      lock = true
   end
   if not lock and love.keyboard.isDown("left") then
      dx = -1
      lock = true
   end
   if not lock and love.keyboard.isDown("right") then
      dx = 1
      lock = true
   end
   if not lock and love.keyboard.isDown("space") then
     action = true
     lock = true
   end

   if not love.keyboard.isDown("up") and not love.keyboard.isDown("down") and not love.keyboard.isDown("left") and not love.keyboard.isDown("right") and not love.keyboard.isDown("dpave") then
      lock = false
   end

   local newgrid = deepcopy(grid)
   if dx ~= 0 or dy ~= 0 or action then
     for x=1,10 do
       for y=1,10 do
         if grid[x][y].isMovable then
           if isValidMove(x+dx, y+dy) then
             newgrid[x+dx][y+dy] = grid[x][y]
             newgrid[x][y] = emptyFactory()
           end
         end
         if action then
           if grid[x][y].action ~= nil then
             newgrid[x][y+1] = grid[x][y].action(grid[x][y+1])
             newgrid[x][y-1] = grid[x][y].action(grid[x][y-1])
             newgrid[x+1][y] = grid[x][y].action(grid[x+1][y])
             newgrid[x-1][y] = grid[x][y].action(grid[x-1][y])
           end
         end
       end
     end
   end
   grid = newgrid
end

function love.draw()
  love.graphics.print("Hello World!", 400, 300)
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.draw(image, imgx, imgy)
  love.graphics.print(num, 300,300)
  love.graphics.setColor(0,0,0)
  drawgrid()
  --love.graphics.circle("fill", 300, 300, 50, 5)
end
