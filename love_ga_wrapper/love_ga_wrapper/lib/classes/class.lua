-- Classes a-la python module --

-- class: function -> class
-- Takes the constructor of the class, the constructor must be in the form function(self, ...) where
-- self refers to the same object being created.
local function class(constructor)
    if not (type(constructor) == "function") then
        error("Parameter constructor must be a function.")
    end

    local TheClass = {}

    function TheClass.new(...)
        local o = {}
        local self = setmetatable(o, TheClass)
        constructor(self, ...)
        return self
    end

    TheClass.__index = TheClass

    return TheClass
end

return class