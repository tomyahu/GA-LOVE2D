local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local json = require("love_ga_wrapper.lib.file.pseudo_json.pseudo_json")
local LoveTASWrapper = require("love_ga_wrapper.wrapper.LoveTASWrapper")
--------------------------------------------------------------------------------------------------------
local LoveTASWrapperTester = extend(LoveTASWrapper, function(self, setted_dt, setted_seed, tas_path, fitness_function, frames_to_test, frames_yield_interval)
    self.fitness_fun = fitness_function
    self.fitness_fun:setLoveWrapper(self)
    self.fitness_fun:init()

    self.frames_to_test = frames_to_test
    self.frames_yield_interval = frames_yield_interval

    self.load_function = function() end
    self.update_function = function() end
    self.draw_function = function() end

    self.m_thread = nil
end,

function(setted_dt, setted_seed, tas_path)
    return LoveTASWrapper.new(setted_dt, setted_seed, tas_path)
end)

-- init: None -> None
-- Initializes the wrapper, redefines the love functions
function LoveTASWrapperTester.init(self)
    LoveTASWrapper.init(self)

    self.m_thread = coroutine.create(function()
        self.load_function(arg)
        for i = 1, self.frames_to_test do
            if self.frames_yield_interval > 0 then
                if i % self.frames_yield_interval == 0 then
                    self.letFramePass()
                end
            end
            self.fitness_fun:stepFun()
            self:runLoveCycle()
        end
        self.fitness_fun:stepFun()

		output_dict = {}
		output_dict["fitness"] = self.fitness_fun:mainFun()

		output_dict["metrics"] = {}

        io.stdout:write(json.encode(output_dict))
        love.event.quit()
    end)
end

-- runLoveCycle: None -> None
-- runs love's cycle once
function LoveTASWrapperTester.runLoveCycle(self)
    local start = socket.gettime()*1000
    self.update_function(self.last_update_dt)
    self.draw_function(self.last_update_dt)
    self.last_update_dt = socket.gettime()*1000 - start
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveTASWrapperTester.redefineLoveUpdate(self)
    if not self.update_redefined then
        LoveTASWrapper.redefineLoveUpdate(self)
        self.update_function = love.update

        love.update = function(dt) end
    end
end

-- redefineLoveDraw: None -> None
-- redefines the love function love.graphics.draw
function LoveTASWrapperTester.redefineLoveDraw(self)
    if not self.draw_redefined then
        self.draw_function = love.draw
        love.draw = function(dt)
            local status, result = coroutine.resume(self.m_thread)
        end
    end
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveTASWrapperTester.redefineLoveLoad(self)
    if not self.load_redefined then
        self.load_function = love.load

        function love.load() end
    end
end


function LoveTASWrapperTester.letFramePass(_)
    coroutine.yield()
end

function LoveTASWrapperTester.resetGame(self)
    LoveTASWrapper.resetGame(self)
    self.fitness_fun:init()
end

return LoveTASWrapperTester