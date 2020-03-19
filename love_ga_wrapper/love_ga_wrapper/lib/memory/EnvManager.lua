local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local TablesMemoryLib = require("love_ga_wrapper.lib.memory.TablesMemoryLib")
--------------------------------------------------------------------------------------------------------

-- class: EnvManager
-- A manager class to switch between many environments
local EnvManager = class(function(self)
    self.environments = {}
end)

-- addEnvironment: str, table -> None
-- Add an environment to the manager's dictionary of environments
function EnvManager.addEnvironment(self, key, env)
    if type(env) ~= "table" then
        error("Variable env must be a table.")
    end
    
    if type(key) ~= "string" then
        error("Variable key must be a string.")
    end
    
    self.environments[key] = env
end

-- setEnvironment: str -> None
-- Sets the current environment to an environment stored in the environment list
function EnvManager.setEnvironment(self, key)
    if self.environments[key] == nil then
        error("Environment not found in EnvManager's environment list.")
    end
    
    TablesMemoryLib.replaceValues(_G, self.environments[key])
end

-- setEnvironmentCopy: str -> None
-- Sets the current environment to a copy of an environment stored in the environment list
function EnvManager.setEnvironmentCopy(self, key)
    if self.environments[key] == nil then
        error("Environment not found in EnvManager's environment list.")
    end
    
    TablesMemoryLib.replaceValues(_G, TablesMemoryLib.copy(self.environments[key]))
end

-- getCurrentEnv: None -> table
-- returns the current environment
function EnvManager.getCurrentEnv(self)
    return _G
end

return EnvManager