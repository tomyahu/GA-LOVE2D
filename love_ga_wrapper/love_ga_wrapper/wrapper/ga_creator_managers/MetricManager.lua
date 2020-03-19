local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: MetricManager
-- param: love_ga_creator:LoveGACreator -> the wrapper class that trains the genetic algorithm over the game
-- A manager class that manages metrics
local MetricManager = class(function(self, love_ga_creator)
    self.love_ga_creator = love_ga_creator
    self.metrics = {}
end)

-- setter
-- setMetrics: list(FitnessFun) -> None
-- sets the metrics of the metric manager
function MetricManager.setMetrics(self, new_metrics)
    self.metrics = new_metrics

    for _, metric in pairs(self.metrics) do
        metric:setLoveGACreator(self.love_ga_creator)
    end
end

-- getter
function MetricManager.getMetrics(self)
    return self.metrics
end

return MetricManager
