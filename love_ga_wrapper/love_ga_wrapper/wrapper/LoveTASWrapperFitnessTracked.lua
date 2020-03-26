local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local LoveTASWrapper = require("love_ga_wrapper.wrapper.LoveTASWrapper")
--------------------------------------------------------------------------------------------------------
local LoveTASWrapperFitnessTracked = extend(LoveTASWrapper, function(self, setted_dt, setted_seed, tas_path, fitness_function)
    self.fitness_fun = fitness_function
    self.fitness_fun:setLoveGACreator(self)
    self.fitness_fun:init()
end,

function(setted_dt, setted_seed, tas_path)
    return LoveTASWrapper.new(setted_dt, setted_seed, tas_path)
end)

function LoveTASWrapperFitnessTracked.resetGame(self)
    LoveTASWrapper.resetGame(self)
    self.fitness_fun:init()
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveTASWrapperFitnessTracked.redefineLoveUpdate(self)
    if not self.update_redefined then
        local old_update = love.update

        love.update = function(current_dt)
            self.fitness_fun:stepFun()
            self:setCurrentFrameDt(current_dt)

            collectgarbage("collect")
            local memory_used = collectgarbage("count")
            self:setCurrentRAMKB(memory_used)

            local old_inputs = self.keys_pressed
            local tas_inputs = self.tas:getInputsFromFrame(self:getCurrentFrame())

            for input, state in pairs(tas_inputs) do
                if state then
                    if not old_inputs[input] then
                        self:pressKey(input)
                    end
                else
                    if old_inputs[input] then
                        self:releaseKey(input)
                    end
                end
            end

            self:updateCurrentFrame()
            print("Frame " .. self:getCurrentFrame() .. " fitness: " .. self.fitness_fun:mainFun())

            local dt = self.setted_dt
            old_update(dt)
        end

        self.update_redefined = true
    end
end

return LoveTASWrapperFitnessTracked