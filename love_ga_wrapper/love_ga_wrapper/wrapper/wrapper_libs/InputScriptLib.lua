local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: InputScriptLib
-- library class to do operation on input scripts
local InputScriptLib = class(function(self)
    
end)

-- concatenateInputScripts: table, table, int -> table
-- returns an input script table that corresponds of executing the first input script until frame separation_frame and
-- then running the second input script
function InputScriptLib.concatenateInputScripts(input_script1, input_script2, separation_frame)
    local inputs = {}
    for key, val in pairs(input_script1) do
        if key <= separation_frame then
            inputs[key] = val
        end
    end

    for key, val in pairs(input_script2) do
        inputs[key + separation_frame] = val
    end

    return inputs
end

return InputScriptLib
