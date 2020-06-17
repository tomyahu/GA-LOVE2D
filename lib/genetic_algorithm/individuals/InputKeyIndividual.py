from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript


class InputKeyIndividual(InputIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only single key genes
    """

    def __init__(self, genes):
        """
        :param genes: <list(SingleKeyGene)> The list of genes of the current individual
        """
        InputIndividual.__init__(self, genes)

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()

        for i in range(len(self.genes)):
            gene_input = self.genes[i].get_key_input()
            inputs.add_input(gene_input, i+1, i+2)

        return inputs
