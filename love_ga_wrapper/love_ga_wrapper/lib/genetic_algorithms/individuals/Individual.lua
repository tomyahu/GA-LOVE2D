local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local TablesMemoryLib = require("love_ga_wrapper.lib.memory.TablesMemoryLib")
-------------------------------------------------------------

-- class: Individual
-- param: genomes:list(Genome) -> The list of genomes of the curren individual
-- An individual in the genetic algorithm
local Individual = class(function(self, genomes)
    self.genomes = genomes
    self.metrics = {}
end)

-- getClass: None -> class
-- Returns the class of the Individual
function Individual.getClass(self, individual)
  return Individual
end

-- uniformCrossOver: Individual -> list(Genome)
-- Returns a list of genomes that correspond to a mix of the genomes of both individuals in the corresponding positions
function Individual.uniformCrossOver(self, individual)
  local new_genomes = {}
  
  for i=1,math.min(# (self.genomes),# (individual.genomes)) do
    if math.random() < 0.5 then
      table.insert(new_genomes, TablesMemoryLib.copy(self.genomes[i]))
    else
      table.insert(new_genomes, TablesMemoryLib.copy(individual.genomes[i]))
    end
  end
  
  return self:getClass().new(new_genomes)
end

-- singlePointCrossOver: Individual -> Individual
-- Returns the result of a classic crossover between this individual and the passed individual
-- divides the genomes of both individuals in 2 and creates a new individual with the first part of the first and the
-- second of the second
function Individual.singlePointCrossOver(self, individual)
  local new_genomes = {}
  local genome_number = (# self.genomes)
  local random_cut = math.random(1, genome_number)
  
  for i = 1, random_cut do
    new_genomes[i] = TablesMemoryLib.copy(self.genomes[i])
  end
  for i = (random_cut+1), genome_number do
    new_genomes[i] = TablesMemoryLib.copy(individual.genomes[i])
  end
  
  return self:getClass().new(new_genomes)
end

-- kPointCrossOver: Individual, int(1,) -> Individual
-- A generalization of the single point crossover, it generatess k random cuts in the individual's genomes and
-- intercalates the genomes of both individuals to create a new individual
function Individual.kPointCrossOver(self, individual, k)
  local new_genomes = {}
  local genome_number = (# self.genomes)
  
  local random_cuts = {}
  
  table.insert(random_cuts, 0)
  for i = 1,k do
    table.insert(random_cuts, math.random(1, genome_number))
  end
  table.sort(random_cuts)
  table.insert(random_cuts, genome_number)
  
  local genomes_1 = self.genomes
  local genomes_2 = individual.genomes
  
  
  for j = 1, ((# random_cuts) - 1) do
    local random_cut_1 = random_cuts[j]
    local random_cut_2 = random_cuts[j+1]
    
    for i = random_cut_1+1, random_cut_2 do
      new_genomes[i] = TablesMemoryLib.copy(genomes_1[i])
    end
    
    local aux = genomes_1
    genomes_1 = genomes_2
    genomes_2 = aux
  end
  
  return self:getClass().new(new_genomes)  
end

-- mutate: None -> None
-- Mutates a random gene of the individual
function Individual.mutate(self)
  local random_genome_index  = math.random(1, (# self.genomes))
  self.genomes[random_genome_index]:mutate()
end

-- addMetric: str, num -> None
-- saves a metric for this individual
function Individual.addMetric(self, key, val)
    self.metrics[key] = val
end

-- getMetric: str -> num
-- gets a metric associated with this individual
function Individual.getMetric(self, key)
    return self.metrics[key]
end

-- getter
function Individual.getMetrics(self)
    return self.metrics
end

return Individual