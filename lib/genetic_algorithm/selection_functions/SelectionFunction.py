
class SelectionFunction():
    """
    Dummy selection function that always returns the first individual of the population
    """

    def select(self, population):
        """
        Selects an individual, in this case it always selects the first individual of the population
        :param population: <Population> The population of the genetic algorithm to select an individual from
        :return: <InputIndividual> The selected individual
        """
        return population.get_individuals()[0]
