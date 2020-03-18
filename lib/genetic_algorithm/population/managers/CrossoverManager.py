from lib.genetic_algorithm.crossover_functions.CrossoverFunction import CrossoverFunction


class CrossoverManager():
    """
    Manager class for crossover methods
    """

    def __init__(self):
        self.crossover_fun = CrossoverFunction()

    def cross_over(self, individual1, individual2):
        """
        applies the crossover function to the two individuals and returns a new individual
        :param individual1: <InputIndividual> the first individual to do crossover
        :param individual2: <InputIndividual> the second individual to do crossover
        :return: <InputIndividual> the resulting individual to do crossover with the current crossover function
        """
        return self.crossover_fun.cross_over(individual1, individual2)

    def set_crossover_fun(self, new_crossover_fun):
        """
        setter
        """
        self.crossover_fun = new_crossover_fun
