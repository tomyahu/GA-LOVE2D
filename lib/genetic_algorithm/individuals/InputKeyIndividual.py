from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual


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
        inputs = dict()
        inputs[1] = dict()

        for i in range(1, self.genomes):
            genome_inputs = self.genomes[i].get_inputs()

            inputs[i + 1] = dict()

            for key_input, status in genome_inputs:
                inputs[i][key_input] = status
                if status:
                    inputs[i+1][key_input] = False

        return inputs