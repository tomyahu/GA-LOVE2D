
class TesterManager:

    def __init__(self, tester):
        self.tester = tester

    def test_population(self, population):
        individuals = population.get_individuals()
        for i in range(len(individuals)):
            population.individuals_fitness[i] = self.tester.test(individuals[i])