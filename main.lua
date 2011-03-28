function init_map()
	local cor = 0
	local current_line = 0
	
	for i=0,1200 do
		if math.floor(i/40) ~= current_line then
			cor = (cor == 0 and 1) or 0
			current_line = current_line + 1
		end
	
		if i % 2 == 0 then
			map[i] = cor
		else
			map[i] = (cor == 0 and 1) or 0
		end		
	end	
end

function gen_car(_x, _y, _width, _height, _speedX, _speedY, _color, _dir)
	car = {x = _x, y = _y, height = _height, width = _width, speedX = _speedX, speedY = _speedY, color=_color, dir = _dir,
		move = function(car)
			if car.dir == "right" then
				car.x = car.x + car.speedX
			elseif car.dir == "left" then 
				car.x = car.x - car.speedX
			elseif car.dir == "up" then
				car.y = car.y - car.speedY
			elseif car.dir == "down" then
				car.y = car.y + car.speedY
			end
		end,
		draw = function(car)
			love.graphics.setColor(car.color)
			love.graphics.rectangle("fill", car.x, car.y, car.width, car.height)
		end,
		setDir = function(car, new_dir)
			car.dir = new_dir
		end	
	}
	
	return car
end

function love.load()
	-- Criação do mapa
	map = {}
	init_map()
	
	car = gen_car(0,0,20,20,20,20,{255,0,0},"right")
end

function love.update(dt)
	car:move()
end

function love.keypressed(key)
	if key == "left" then
		car:setDir("left")
	elseif key == "right" then
		car:setDir("right")
	elseif key == "up" then
		car:setDir("up")
	elseif key == "down" then
		car:setDir("down")
	end
end

function love.draw()
	-- Desenha o mapa
	for i=0,1200 do
		--print(map[i])
		--love.timer.sleep(1000)
		if map[i] == 0 then
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("fill", 20*(i%40), math.floor(i/40)*20, 20, 20)			
		end
		love.graphics.setColor(0,0,0);
	end	
	car:draw()
	
	love.timer.sleep(100)
end