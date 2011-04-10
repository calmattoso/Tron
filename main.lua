require 'objects'

map = {
	register = {},
	init = function(obj)
		for i=1,20 do
			obj.register[i] = 0
		end
	end,
	draw = function(obj)
		print("Drawing map...")
		for i=1,40 do
			love.graphics.line(i*20, 0, i*20, 600)
			love.graphics.line(0, i*20, 800, i*20)
		end
	end,
	co = coroutine.create(function(obj)
		player = await({'moved'})
		--obj.register		
	end
	)
}
cars = {}

function drawCar(car)
	print("Drawing car...")
	love.graphics.setColor(car.color)
	love.graphics.rectangle("fill", car.x, car.y, 20, 20) 	
	love.graphics.setColor(255,255,255)
end

function updateCarDirection(car) 	
	print("updateCarDirection executed succesfully...")
	
	while true do
		local new_dir = await({'key'})
		
		if car.valid_keys[new_dir] then
			car.direction = car.valid_keys[new_dir]
		end
	end
end

function updateCarMovement(car)
	print("updateCarMovement executed succesfully...")
	
	while true do
		local dt = await({'dt'})
		
		if(car.direction == "right") then car.x = car.x + car.speed * dt end
		if(car.direction == "left") then car.x = car.x - car.speed * dt end
		if(car.direction == "up") then car.y = car.y - car.speed * dt end
		if(car.direction == "down") then car.y = car.y + car.speed * dt end
	end
end

function createCar(x, y, speed, color, direction, valid_keys)	
	io.write("Creating car with:\n", "  x: ", x, "; y: ", y, "; direction: ", direction, "\n")
	return {x = x, y = y, speed = speed, color = color, direction = direction,
		valid_keys = valid_keys,
	 draw = drawCar,
	 co = {coroutine.create(updateCarMovement), coroutine.create(updateCarDirection)}
	}
end

function love.load()
	map:init()

	local cars_ini = {
		{x = 200, y = 300, color = {255,0,0,127}, direction = "right", valid_keys = {w="up", a="left", s="down", d="right"}},
		{x = 600, y = 300, color = {0,0,255,127}, direction = "left", valid_keys = {up="up", left="left", down="down", right="right"}}
	}

	for i=1,#cars_ini do
		print("i: ", i)
		cars[i] = (createCar(cars_ini[i].x, cars_ini[i].y, 70, cars_ini[i].color, cars_ini[i].direction, cars_ini[i].valid_keys))
	end


	draws.insert(map, 0)
	for i=1,#cars do
		draws.insert(cars[i], 1)
		anims.insert(cars[i])
	end
end
