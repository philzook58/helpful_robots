



function love.load()
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   --love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   num = 3
   imgx = 0
   imgy = 0
   speed = 200
   grid = {}
   for x=1,10 do
     grid[x] = {}
     for y=1,10 do
       grid[x][y] = "empty"
     end
   end
   grid[3][4]="red"
   grid[6][6]="grey"
   grid[6][7]="grey"
   grid[6][8]="grey"


end


function drawgrid()
  for x=1,10 do
    for y=1,10 do
      if grid[x][y] == "empty" then
        love.graphics.setColor(0,0,0)

    elseif grid[x][y] == "red" then
        love.graphics.setColor(255,0,0)

      elseif grid[x][y] == "grey" then
          love.graphics.setColor(125,125,125)

      end
      love.graphics.circle("fill", 50*x, 50*y, 30, 5)

    end
  end
end


function isblocked(x,y)
  if x > 10 or x < 1 or y > 10 or y < 1 then
    return true
  elseif grid[x][y] == "grey" then
    return true

  else
    return false
  end
end

function isrobot(color)
  return color == "red"
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
   if love.keyboard.isDown("up") then
      imgy = imgy - speed * dt -- this would increment num by 100 per second
      dy = -1
   end
   if love.keyboard.isDown("down") then
      imgy = imgy + speed * dt -- this would increment num by 100 per second
      dy = 1
   end
   if love.keyboard.isDown("left") then
      imgx = imgx - speed * dt -- this would increment num by 100 per second
      dx = -1
   end
   if love.keyboard.isDown("right") then
      imgx = imgx + speed * dt -- this would increment num by 100 per second
      dx = 1
   end

   local newgrid = deepcopy(grid)
   if dx ~= 0 or dy ~= 0 then
     for x=1,10 do
       for y=1,10 do
         if isrobot(grid[x][y]) then
           if not isblocked(x+dx, y+dy) then
             newgrid[x+dx][y+dy] = grid[x][y]
             newgrid[x][y] = "empty"
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
