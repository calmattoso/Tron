--------------------------------------------------------------------------------
-- DRAWS
--------------------------------------------------------------------------------

local function _cmp (o1, o2)
    return o1.zindex < o2.zindex
end
local function _sort ()
    table.sort(draws.list, _cmp)
end

draws = {
    list = {},

    insert = function (obj, zindex)
        obj.zindex = zindex or 0
        draws.list[#draws.list+1] = obj
        _sort()
    end,

    remove = function (obj2)
        for i, obj1 in ipairs(draws.list) do
            if obj1 == obj2 then
                table.remove(draws.list, i)
            end
        end
    end,

    sort = _sort,

    redraw = function ()
        for _, obj in ipairs(draws.list) do
            obj:draw()
        end
    end,
}

--------------------------------------------------------------------------------
-- ANIMS
--------------------------------------------------------------------------------

anims = {
    list = {},

    insert = function (obj)
        anims.list[obj] = true
        anims.firstStep(obj)
    end,

    remove = function (obj)
        anims.list[obj] = nil
    end,
		
		firstStep = function(obj, ...)
			print("Inside firstStep...")
			assert(obj.co)
      
			if (type(obj.co) == "table") then
				for _,co in ipairs(obj.co) do
					print(_, coroutine.status(co))
					assert(coroutine.status(co) == "suspended" and coroutine.resume(co, obj, ...))
					print(_, "worked")
						
					if coroutine.status(co) == 'dead' then
						anims.remove(obj)
					end
				end				
			else 
				assert(coroutine.status(obj.co) == "suspended" and coroutine.resume(obj.co, obj, ...))
				if coroutine.status(obj.co) == 'dead' then
					anims.remove(obj)
				end
			end
		end,

    step = function (obj, ...)
				print("Inside step...")
				print(...)
        assert(obj.co)
				
				if (type(obj.co) == "table") then
					for _,co in ipairs(obj.co) do
						print(_, coroutine.status(co))
						assert(coroutine.status(co) == "suspended" and coroutine.resume(co, ...))
						print(_, "worked")
						if coroutine.status(co) == 'dead' then
							anims.remove(obj)
						end
					end				
				else 
					assert(coroutine.status(obj.co) == "suspended" and coroutine.resume(obj.co, ...))
					
					if coroutine.status(obj.co) == 'dead' then
							anims.remove(obj)
					end
				end
    end,

    stepAll = function (...)
				print("Inside stepAll...")
				print(...)
        for obj, v in pairs(anims.list) do
            anims.step(obj, ...)
        end
    end,
}

function await (t)
    local evt, value
    while true do
        evt, value = coroutine.yield()
        if (t[1] == evt) and
           ((t[2] == nil) or (t[2] == value))
        then
            return value, evt
        end
    end
end

--------------------------------------------------------------------------------
-- LOVE
--------------------------------------------------------------------------------

function love.draw()
    draws.redraw()
end

function love.update (dt)
    anims.stepAll('dt', dt)
end

function love.keypressed (key)
    anims.stepAll('key', key)
end

