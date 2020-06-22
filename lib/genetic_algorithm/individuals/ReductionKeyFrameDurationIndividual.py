import random

from ga_settings.consts import frames_to_skip
from lib.genetic_algorithm.individuals.InputKeyFrameDurationIndividual import InputKeyFrameDurationIndividual


class ReductionKeyFrameDurationIndividual(InputKeyFrameDurationIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame duration
    genomes. Used for reduction of input sequences.
    """

    def __init__(self, genes):
        """
        :param genes: <list(InputKeyFrameDurationGene)> The list of genomes of the current individual
        """
        InputKeyFrameDurationIndividual.__init__(self, genes)

    def mutate(self):
        """
        Deletes a random gene of the gene list
        """
        target_gene_index_list = self.get_genes_after_frames(frames_to_skip)

        if len(target_gene_index_list) > 0:
            random_gene_index = random.choice(target_gene_index_list)
            self.genes.pop(random_gene_index)

    def get_genes_after_frames(self, frames):
        """
        Returns the index of the genes of key inputs that occur after the number of frames given
        :param frames: <int> the number of frames to filter
        :return: <list(int)> the list of indexes of genes after the frames to filter
        """
        gene_index_list = list()

        for gene_index in range(len(self.genes)):
            gene = self.genes[gene_index]
            if gene.get_frame() > frames:
                gene_index_list.append(gene_index)

        return gene_index_list
