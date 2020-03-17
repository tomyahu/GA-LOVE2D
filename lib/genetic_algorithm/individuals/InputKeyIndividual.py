from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript


class InputKeyIndividual(InputIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only single key genomes
    """

    def __init__(self, genomes):
        """
        :param genomes: <list(SingleKeyGenome)> The list of genomes of the current individual
        """
        InputIndividual.__init__(self, genomes)

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()

        for i in range(len(self.genomes)):
            genome_input = self.genomes[i].get_key_input()
            inputs.add_input(genome_input, i+1, i+2)

        return inputs
