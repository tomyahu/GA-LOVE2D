local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local TASInput = require("love_ga_wrapper.tas.TASInput")
local PseudoJsonDictFile = require("love_ga_wrapper.lib.file.PseudoJsonDictFile")
--------------------------------------------------------------------------------------------------------

-- class: IOLib
local IOLib = class(function(self)
    
end)

-- getTASFromFile: str -> TASInput
-- gets a TAS (input script) to run with the game
function IOLib.getTASFromFile(import_path)
    local tas = TASInput.new()

    local file = PseudoJsonDictFile.new(import_path)
    file:load()
    tas:setInputs(file:getDict())

    return tas
end

-- getInputsFromFile: str -> table
-- gets an input script as a table from a file
function IOLib.getInputsFromFile(import_path)
    local file = PseudoJsonDictFile.new(import_path)
    file:load()
    return file:getDict()
end

-- saveInputsToFile: table, str -> None
-- saves an input script to a file
function IOLib.saveInputsToFile(inputs, export_path)
    local dict_file = PseudoJsonDictFile.new(export_path)

    dict_file:setDict(inputs)
    dict_file:save()
end

return IOLib
