local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local Tester = require("love_ga_wrapper.lib.genetic_algorithms.testers.Tester")
-------------------------------------------------------------

-- class: WordTester
-- param: result_word:str -> the word to compare the individuals to
-- A tester to get the fitness of individuals that represent a word
local WordTester = extend(Tester, function(self, result_word)
    self.word = result_word
    self.word_len = string.len(self.word)
end)

-- test: WordIndividual -> num
-- Returns the fitness value of the current word individual
function WordTester.test(self, individual)
    local individual_word = individual:getWord()
    local fitness = 0
    for i=1,self.word_len do
        if (self.word:sub(i,i) == individual_word:sub(i,i)) then
            fitness = fitness + 1
        end
    end

    return fitness
end

return WordTester