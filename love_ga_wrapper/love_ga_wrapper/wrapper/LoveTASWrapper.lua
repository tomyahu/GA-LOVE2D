local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local LoveWrapper = require("love_ga_wrapper.wrapper.LoveWrapper")
local TASInput = require("love_ga_wrapper.tas.TASInput")
local PseudoJsonDictFile = require("love_ga_wrapper.lib.file.PseudoJsonDictFile")
-------------------------------------------------------------

-- class: LoveTASWrapper
-- param: setted_dt:num -> the delta time that happens between each frame
-- param: setted_seed:num -> the seed of the random numbers to use
-- param: tas:TASInput -> the tas object
local LoveTASWrapper = extend(LoveWrapper,
    function(self, setted_dt, setted_seed, tas_path)
        self.tas = TASInput.new()

        local file = PseudoJsonDictFile.new(tas_path)
        file:load()
        self.tas:setInputs(file:getDict())

        self.current_frame = 1
    end,

    function(setted_dt, setted_seed)
        return LoveWrapper.new(setted_dt, setted_seed)
    end)

-- init: None -> None
-- Initializes the wrapper, redefines the love functions
function LoveTASWrapper.init(self)
    LoveWrapper.init(self)

    love.keypressed = function(key)
        if key == "r" then
            self:resetGame()
        end
    end
end

-- resetGameAux: None -> None
-- auxiliary reset funcion for the wrapper
function LoveTASWrapper.resetGameAux(self)
    self.current_frame = 1
    LoveWrapper.resetGameAux(self)
end

-- updateCurrentFrame: None -> None
-- updates the current frame count
function LoveTASWrapper.updateCurrentFrame(self)
    self.current_frame = self.current_frame + 1
end

-- getCurrentFrame: None -> int
-- returns the current frame of the wrapper
function LoveTASWrapper.getCurrentFrame(self)
    return self.current_frame
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveTASWrapper.redefineLoveUpdate(self)
    if not self.update_redefined then
        local old_update = love.update

        love.update = function(current_dt)
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

            local dt = self.setted_dt
            old_update(dt)
        end

        self.update_redefined = true
    end
end

return LoveTASWrapper