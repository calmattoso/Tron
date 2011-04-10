require 'objects'

map = {
	register = {},
	init = function(obj)
		for i=1,20 do
			obj.register[i] = 0
		end
	end,
	draw = function(obj)
		for i=1,40 do
			love.graphics.line(i*20, 0, i*20, 600)
			love.graphics.line(0, i*20, 800, i*20)
		end
	end,
	co = coroutine.create(function(obj)
		player = await({"moved"})
		--obj.register		
	end
	)
	

}
cars = {}

function drawCar(car)
	love.graphics.setColor(car.color)
	love.graphics.rectangle("fill", car.x, car.y, 20, 20) 	
	love.graphics.setColor(255,255,255)
end

function updateCar(car)
	local dt=await({"dt"})
	print(car.direction)
	if(car.direction == "right") then car.x = car.x + car.speed * dt end
	if(car.direction == "left") then car.x = car.x - car.speed * dt end
	if(car.direction == "up") then car.y = car.y - car.speed * dt end
	if(car.direction == "down") then car.y = car.y + car.speed * dt end
end

function createCar(x, y, speed, color,direction)	
	return {x = x, y = y, speed = speed, color = color, direction = direction,
	 draw = drawCar,
	 co = coroutine.create(updateCar)
	}
end
map:init()

local cars_info = {
	{x = 200, y = 300, color = {255,0,0,127}, direction = "right"},
	{x = 600, y = 300, color = {0,0,255,127}, direction = "left"}
}

for i=1,2 do
	cars[#cars + 1] = (createCar(cars_info[i].x, cars_info[i].y, 20, cars_info[i].color, cars_info[i].direction))
end


draws.insert(map, 0)
for i=1,2 do
	draws.insert(cars[i], 1)
	anims.insert(cars[i])
end

