local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: LoveEnvLib
-- Library class with static methods to handle love objects in the current environment
local LoveEnvLib = class(function(self)
    
end)

-- freeLoveObjects: None -> None
-- frees all love objects from memory
function LoveEnvLib.freeLoveObjects()
    local env = _G
    print("start_free")
    LoveEnvLib.freeLoveObjectsAux(env, {})
    print("end_free")
end

-- freeLoveObjectsAux: table, table -> None
-- auxiliary method that frees all love objects from a table
function LoveEnvLib.freeLoveObjectsAux(table, tables_seen)
    tables_seen[table] = true
    for index, val in pairs(table) do
        if LoveEnvLib.isLoveObject(index) then
            local release_fun = function() index:release() end
            pcall(release_fun)
        end
        if LoveEnvLib.isLoveObject(val) then
            local release_fun = function() val:release() end
            pcall(release_fun)
        end


        if type(index) == "table" and (tables_seen[index] == nil) then
            LoveEnvLib.freeLoveObjectsAux(index, tables_seen)
        end
        if type(val) == "table" and (tables_seen[val] == nil)  then
            LoveEnvLib.freeLoveObjectsAux(val, tables_seen)
        end
    end
end


-- isLoveObject: any -> bool
-- checks if an object corresponds to a love object
function LoveEnvLib.isLoveObject(table)
    local is_type_user_data = (type(table) == "userdata")

    if not is_type_user_data then return false end
    if not pcall(function() type(table.release) end) then return false end
    if not pcall(function() type(table.type) end) then return false end
    if not pcall(function() type(table.typeOf) end) then return false end

    local has_release_fun = type(table.release) == "function"
    local has_type_fun = type(table.type) == "function"
    local has_typeOf_fun = type(table.typeOf) == "function"

    return has_release_fun and has_type_fun and has_typeOf_fun
end

return LoveEnvLib
