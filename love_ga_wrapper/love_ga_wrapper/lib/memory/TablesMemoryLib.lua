local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: TablesMemoryLib
-- A library class for table operations regarding memory
local TablesMemoryLib = class(function(self) end)

-- copy: any, table/nil -> table
-- returns a deep copy of the table 'obj' handling the tricky escenarios of
--      tables as keys
--      preserving metatables
--      recursive tables
function TablesMemoryLib.copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[TablesMemoryLib.copy(k, s)] = TablesMemoryLib.copy(v, s) end
    return res
end

function TablesMemoryLib.replaceValues(table1, table2)
    local pairs = pairs
    -- delete table 1's values
    for key, _ in pairs(table1) do
        table1[key] = nil
    end
    
    -- copy table 2's values into table 1
    for key, val in pairs(table2) do
        table1[key] = val
    end
end

return TablesMemoryLib.new()