local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SelectionFunction = require("love_ga_wrapper.lib.genetic_algorithms.selection_functions.SelectionFunction")
--------------------------------------------------------------------------------------------------------

-- class: SelectionManager
-- Manager class that manages the different selection functions
local SelectionManager = class(function(self)
    self.selection_fun = SelectionFunction.new()
end)

-- select: Population -> Individual
-- returns an individual of the population given the selection function
function SelectionManager.select(self, population)
    return self.selection_fun:select(population)
end

-- setter
function SelectionManager.setSelectionFun(self, new_selection_fun)
    self.selection_fun = new_selection_fun
end

return SelectionManager
