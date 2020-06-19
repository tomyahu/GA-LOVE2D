import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript


class EphemeralKeyIndividual(InputIndividual):
    """
    An individual composed of single key genes and ephemeral key genes
    Can't represent two or more inputs at a time
    """

    def __init__(self, genes):
        InputIndividual.__init__(self, genes)

        self.max_frame = 0
        for gene in genes:
            self.max_frame += gene.get_frames()

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()

        current_frame = 1
        for gene in self.genes:
            gene_input = gene.get_key_input()
            gene_duration = gene.get_frames()
            inputs.add_input(gene_input, current_frame, current_frame + gene_duration)
            current_frame += gene_duration

        return inputs

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_gene = random.choice(self.genes)
        random_gene.mutate_with_max_frame(random_gene.get_frames + 10)

    def get_max_frame(self):
        """
        getter
        """
        return self.max_frame
