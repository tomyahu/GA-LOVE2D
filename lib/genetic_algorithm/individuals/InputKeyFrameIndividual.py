import random
from lib.genetic_algorithm.individuals.InputIndividual import InputIndividual

class InputKeyFrameIndividual(InputIndividual):
    """
    An individual for the genetic algorithm, it represents an input script. Its composed by only key frame genomes.
    """

    def __init__(self, genomes):
        """
        :param genomes: <list(KeyFrameGenome)> The list of genomes of the current individual
        """
        InputIndividual.__init__(self, genomes)

        def sort_second(val):
            return val[1]

        self.genomes.sort(key = sort_second)

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        inputs = dict()
        for i in range(1, len(self.genomes) + 1):
            for frame, key in self.genomes[i].get_inputs():
                if not inputs[frame]:
                    inputs[frame] = dict

                if not inputs[frame + self.genomes[i].get_duration()]:
                    inputs[frame + self.genomes[i].get_duration()] = {}

                inputs[frame][key] = True
                inputs[frame + self.genomes[i].get_duration()][key] = False
        return inputs

    def get_max_frame(self):
        """
        gets the largest frame the individual has an input for
        :return: <int> the largest frame the individual has an input for
        """
        max_frame = 1
        for genome in self.genomes:
            max_frame = max(max_frame, genome.get_frame())

        return max_frame

    def single_point_cross_over(self, individual):
        """
        Returns the result of a classic crossover between this individual and the passed individual divides the genomes
        of both individuals in 2 (the ones that came before and after a random frame) and creates a new individual with
        the first set of the first and the second of the second
        :param individual: <InputKeyFrameIndividual> the individual to do crossover with
        :return: <InputKeyFrameIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        max_frame_both_individuals = max(self.get_max_frame(), individual.get_max_frame())

        new_genomes = list()
        random_cut = random.randint(1, max_frame_both_individuals)

        for i in range(len(self.genomes)):
            if self.genomes[i].get_frame() < random_cut:
                new_genomes.append(self.genomes[i].get_copy())


        for i in range(len(individual.get_genomes())):
            if individual.genomes[i].get_frame() >= random_cut:
                new_genomes.append(individual.get_genomes[i].get_copy())

        return self.__class__(new_genomes)

    def k_point_cross_over(self, individual, k):
        """
        A generalization of the single point crossover, it generatess k random cuts in the individual's genomes and
        intercalates the genomes of both individuals to create a new individual
        :param individual: <InputIndividual> the individual to do crossover with
        :param k: <int> the number of cuts of the k-point crossovef
        :return: <InputIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        max_frame_both_individuals = max(self.get_max_frame(), individual.get_max_frame())

        new_genomes = list()
        random_cuts = [0]

        for i in range(k):
            random_cuts.append(random.randint(1, max_frame_both_individuals))

        random_cuts.sort()
        random_cuts.append(max_frame_both_individuals)

        genomes_1 = self.get_genomes()
        genomes_2 = individual.get_genomes()

        for i in range(len(genomes_1)):
            genome_frame = genomes_1[i].get_frame()
            condition = False

            for j in range(1, len(random_cuts), 2):
                if (random_cuts[j-1] <= genome_frame) and (random_cuts[j] > genome_frame):
                    condition = True

            if condition:
                new_genomes.append(genomes_1[i].get_copy())

        for i in range(len(genomes_2)):
            genome_frame = genomes_2[i].get_frame()
            condition = False

            for j in range(2, len(random_cuts), 2):
                if (random_cuts[j-1] <= genome_frame) and (random_cuts[j] > genome_frame):
                    condition = True

            if condition:
                new_genomes.append(genomes_2[i].get_copy())

        return self.__class__(new_genomes)

    def mutate(self):
        """
        Mutates a random gene of the current individual
        """
        random_genome = random.choice(self.genomes)
        max_frame = self.get_max_frame()
        random_genome.mutate_with_max_frame(max_frame)


