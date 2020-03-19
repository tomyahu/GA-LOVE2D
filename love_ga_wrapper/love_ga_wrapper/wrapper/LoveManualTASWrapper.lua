local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local LoveTASWrapper = require("love_ga_wrapper.wrapper.LoveTASWrapper")
--------------------------------------------------------------------------------------------------------

-- TODO: Document this
local LoveManualTASWrapper = extend(LoveTASWrapper, function(self, setted_dt, setted_seed, tas_path)
    self.update_fun = function() end
    self.draw_fun = function() end
end,

function(setted_dt, setted_seed, tas_path)
    return LoveTASWrapper.new(setted_dt, setted_seed, tas_path)
end)


return LoveManualTASWrapper