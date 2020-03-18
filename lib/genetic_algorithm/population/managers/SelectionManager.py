from lib.genetic_algorithm.selection_functions.SelectionFunction import SelectionFunction


class SelectionManager:
    """
    Manager class that manages the different selection functions
    """

    def __init__(self):
        self.selection_fun = SelectionFunction()

    def select(self, population):
        """
        returns an individual of the population given the selection function
        :param population: <Population> The population of the genetic algorithm to select an individual from
        :return: <InputIndividual> The selected individual
        """
        return self.selection_fun.select(population)

    def set_selection_fun(self, new_selection_function):
        """
        setter
        """
        self.selection_fun = new_selection_function
