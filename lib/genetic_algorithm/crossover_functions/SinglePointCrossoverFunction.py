from lib.genetic_algorithm.crossover_functions.CrossoverFunction import CrossoverFunction


class SinglePointCrossoverFunction(CrossoverFunction):
    """
    A Crossover Function class that uses single point crossover
    """

    def cross_over(self, individual1, individual2):
        """
        returns the result of the first individual making single point crossover with the second
        :param individual1: <InputIndividual> the first individual to do crossover
        :param individual2: <InputIndividual> the second individual to do crossover
        :return: <InputIndividual> the resulting individual to do single point crossover
        """
        return individual1.single_point_cross_over(individual2)
