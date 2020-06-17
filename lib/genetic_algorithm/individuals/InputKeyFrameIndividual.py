import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual
from lib.input_scripts.InputScript import InputScript


class InputKeyFrameIndividual(InputIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame genes.
    """

    def __init__(self, genes):
        """
        :param genes: <list(KeyFrameGene)> The list of genes of the current individual
        """
        InputIndividual.__init__(self, genes)

        def sort_second(val):
            return val[1]

        self.genes.sort(key = sort_second)

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = InputScript()
        for gene in self.genes:
            gene_input_script = gene.get_inputs()
            inputs = inputs + gene_input_script

        return inputs

    def get_max_frame(self):
        """
        gets the largest frame the individual has an input for
        :return: <int> the largest frame the individual has an input for
        """
        max_frame = 1
        for gene in self.genes:
            max_frame = max(max_frame, gene.get_frame())

        return max_frame

    def single_point_cross_over(self, individual):
        """
        Returns the result of a classic crossover between this individual and the passed individual divides the genes
        of both individuals in 2 (the ones that came before and after a random frame) and creates a new individual with
        the first set of the first and the second of the second
        :param individual: <InputKeyFrameIndividual> the individual to do crossover with
        :return: <InputKeyFrameIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        max_frame_both_individuals = max(self.get_max_frame(), individual.get_max_frame())

        new_genes = list()
        random_cut = random.randint(1, max_frame_both_individuals)

        for i in range(len(self.genes)):
            if self.genes[i].get_frame() < random_cut:
                new_genes.append(self.genes[i].get_copy())


        for i in range(len(individual.get_genes())):
            if individual.genes[i].get_frame() >= random_cut:
                new_genes.append(individual.get_genes[i].get_copy())

        return self.__class__(new_genes)

    def k_point_cross_over(self, individual, k):
        """
        A generalization of the single point crossover, it generatess k random cuts in the individual's genes and
        intercalates the genes of both individuals to create a new individual
        :param individual: <InputIndividual> the individual to do crossover with
        :param k: <int> the number of cuts of the k-point crossovef
        :return: <InputIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        max_frame_both_individuals = max(self.get_max_frame(), individual.get_max_frame())

        new_genes = list()
        random_cuts = [0]

        for i in range(k):
            random_cuts.append(random.randint(1, max_frame_both_individuals))

        random_cuts.sort()
        random_cuts.append(max_frame_both_individuals)

        genes_1 = self.get_genes()
        genes_2 = individual.get_genes()

        for i in range(len(genes_1)):
            gene_frame = genes_1[i].get_frame()
            condition = False

            for j in range(1, len(random_cuts), 2):
                if (random_cuts[j-1] <= gene_frame) and (random_cuts[j] > gene_frame):
                    condition = True

            if condition:
                new_genes.append(genes_1[i].get_copy())

        for i in range(len(genes_2)):
            gene_frame = genes_2[i].get_frame()
            condition = False

            for j in range(2, len(random_cuts), 2):
                if (random_cuts[j-1] <= gene_frame) and (random_cuts[j] > gene_frame):
                    condition = True

            if condition:
                new_genes.append(genes_2[i].get_copy())

        return self.__class__(new_genes)

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_gene = random.choice(self.genes)
        max_frame = self.get_max_frame()
        random_gene.mutate_with_max_frame(max_frame)


