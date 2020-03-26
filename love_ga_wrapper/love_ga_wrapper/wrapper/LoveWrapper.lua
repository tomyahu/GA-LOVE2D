local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
-------------------------------------------------------------

-- class: LoveWrapper
-- param: setted_dt:num -> the delta time that happens between each frame
-- param: setted_seed:num -> the seed of the random numbers to use
-- The class of the love wrapper for a game in love
local LoveWrapper = class(function(self, setted_dt, setted_seed)
    self.setted_dt = setted_dt
    self.random_seed = setted_seed

    self.current_frame_dt = 0
    self.current_ram_kb = 0
    self.keys_pressed = {}

    self.update_redefined = false
    self.load_redefined = false
    self.draw_redefined = false

    self.game_reference_dict = {}
end)

-- init: None -> None
-- Initializes the wrapper, redefines the love functions
function LoveWrapper.init(self)
    self.key_press_function = love.keypressed
    self.key_release_function = love.keyreleased
    self.old_load = love.load
    self.old_update = love.update
    self.old_draw = love.draw
    self.old_is_down = love.keyboard.isDown

    love.keypressed = function(key) end
    love.keyreleased = function(key) end

    self:redefineLoveFunctions()
end

-- redefineLoveFunctions: None -> None
-- Redefines love functions
function LoveWrapper.redefineLoveFunctions(self)
    self:redefineLoveIsDown()
    self:redefineLoveUpdate()
    self:redefineLoveLoad()
    self:redefineLoveDraw()
end

-- resetGame: None -> None
-- resets the game and the random seed
function LoveWrapper.resetGame(self)
    self:resetGameAux()
    self.old_load(arg)
end

-- resetGameAux: None -> None
-- resets the random seed
function LoveWrapper.resetGameAux(self)
    math.randomseed(self.random_seed)
end

-- resetInputs: None -> None
-- resets the inputs currently pressed
function LoveWrapper.resetInputs(self)
    self.keys_pressed = {}
end

-- pressKey: str -> None
-- activates all the love funtions necesary that get inputs when a keyboard key is pressed
function LoveWrapper.pressKey(self, key)
    self.keys_pressed[key] = true
    self:redefineLoveIsDown()
    if not (self.key_press_function == nil) then
        self.key_press_function(key)
    end
end

-- releaseKey: str -> None
-- activates all the love functiones that get inputs when a keybiard key is released
function LoveWrapper.releaseKey(self, key)
    self.keys_pressed[key] = nil
    self:redefineLoveIsDown()
    if not (self.key_release_function == nil) then
        self.key_release_function(key)
    end
end

-- redefineLoveIsDown(self): None -> None
-- redefines the love funtion love.keyboard.isDown(key) to use the custom inputs
function LoveWrapper.redefineLoveIsDown(self)
    love.keyboard.isDown = function(key)
        if self.keys_pressed[key] == nil then
            return false
        else
            return true
        end
    end
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveWrapper.redefineLoveUpdate(self)
    if not self.update_redefined then
        local old_update = love.update

        love.update = function(current_dt)
            self:setCurrentFrameDt(current_dt)

            collectgarbage("collect")
            local memory_used = collectgarbage("count")
            self:setCurrentRAMKB(memory_used)

            local dt = self.setted_dt
            old_update(dt)
        end

        self.update_redefined = true
    end
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveWrapper.redefineLoveLoad(self)
    if not self.load_redefined then
        local old_load = love.load

        love.load = function()
            self:resetGameAux()
            old_load(arg)
        end
    end
end

-- redefineLoveDraw: None -> None
-- redefines the love function love.graphics.draw
function LoveWrapper.redefineLoveDraw(self)
    if not self.draw_redefined then
        local old_draw = love.draw
        local old_math_random = math.random

        local new_random = function(i, j)
            if j == nil then
                if type(i) ~= "number" and type(i) ~= "nil" then
                    error("bad argument #1 to 'random' (number expected, got " .. type(i) .. ")")
                end
                return 1
            elseif type(i) ~= "number" then
                error("bad argument #1 to 'random' (number expected, got " .. type(i) .. ")")
            else
                if type(i) ~= "number" then
                    error("bad argument #1 to 'random' (number expected, got " .. type(i) .. ")")
                end

                if type(j) ~= "number" then
                    error("bad argument #1 to 'random' (number expected, got " .. type(i) .. ")")
                end

                return i
            end
        end

        love.draw = function()
            math.random = new_random
            old_draw()
            math.random = old_math_random
        end
    end
end

-- getFromGameReferenceDict: any -> any
-- gets the reference assigned to key in the wrapper's game reference dictionary
function LoveWrapper.getFromGameReferenceDict(self, key)
    return self.game_reference_dict[key]
end

-- setInGameReferenceDict any, any -> None
-- sets a reference in the wrapper's game reference dict and assign's it to a key
function LoveWrapper.setInGameReferenceDict(self, key, reference)
    self.game_reference_dict[key] = reference
end

-- setters
function LoveWrapper.setCurrentFrameDt(self, new_dt)
    self.current_frame_dt = new_dt
end

function LoveWrapper.setCurrentRAMKB(self, new_ram_kb)
    self.current_ram_kb = new_ram_kb
end

-- getters
function LoveWrapper.getSettedDt(self)
    return self.setted_dt
end

function LoveWrapper.getCurrentFrameDt(self)
    return self.current_frame_dt
end

function LoveWrapper.getCurrentRAMKB(self)
    return self.current_ram_kb
end

function LoveWrapper.getCurrentInputs(self)
    return self.keys_pressed
end


return LoveWrapper