-- extend: class, function, function -> class
-- Takes a parent class, the constructor of the class and a function that takes the same arguments as the constructor
-- and returns a new parent object. This exist in case the user wants to pass special arguments to the super class.
--
-- When the function takes 2 arguments it does the same as if superFun was function(...) return parent:new(...) end
local function extend(parent, constructor, superFun)
    if not (type(parent) == "table") then
        error("Parameter parent must be a table, not " .. type(parent))
    elseif not (type(constructor) == "function") then
        error("Parameter constructor must be a function.")
    elseif not ((type(superFun) == "function") or (superFun == nil))then
        error("Parameter superFun must be a function.")
    end

    local TheClass = {}
    TheClass = setmetatable({}, parent)

    function TheClass.new(...)
        local o
        if superFun == nil then
            o = parent.new(...)
        else
            o = superFun(...)
            if not (type(o) == "table") then
                error("Function superFun must return a new parent object.")
            end
        end
        local self = setmetatable(o, TheClass)

        constructor(self, ...)
        return self
    end

    TheClass.__index = TheClass

    return TheClass
end

return extend