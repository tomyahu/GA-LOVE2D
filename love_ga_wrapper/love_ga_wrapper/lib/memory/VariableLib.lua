local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: VariableLib
-- A library class to work with global and local memory
local VariableLib = class(function(self) end)

-- getGlobalVars: None -> table
-- returns a reference to the global variable table
function VariableLib.getGlobalVars()
    return _G
end

return VariableLib.new()