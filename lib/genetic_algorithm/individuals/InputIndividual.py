import random


class InputIndividual:
    """
    An individual for the genetic algorithm, it represents an input script
    """

    def __init__(self, genes):
        """
        :param genes: <list(SingleKeyGene)> The list of genes of the current individual
        """
        self.genes = genes
        self.metrics = dict()

    def single_point_cross_over(self, individual):
        """
        Returns the result of a classic crossover between this individual and the passed individual divides the genes
        of both individuals in 2 and creates a new individual with the first part of the first and the second of the
        second
        :param individual: <InputIndividual> the individual to do crossover with
        :return: <InputIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        new_genes = list()
        gene_number = len(self.get_genes())

        random_cut = random.randint(0, gene_number - 1)

        for i in range(0, random_cut):
            new_genes.append(self.genes[i].get_copy())

        for i in range(random_cut , gene_number):
            new_genes.append(individual.get_genes()[i].get_copy())

        return self.__class__(new_genes)

    def k_point_cross_over(self, individual, k):
        """
        A generalization of the single point crossover, it generatess k random cuts in the individual's genes and
        intercalates the genos of both individuals to create a new individual
        :param individual: <InputIndividual> the individual to do crossover with
        :param k: <int> the number of cuts of the k-point crossovef
        :return: <InputIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        new_genes = list()
        gene_number = len(self.genes)

        random_cuts = [0]

        for i in range(1, k):
            random_cuts.append(random.randint(1, gene_number))

        random_cuts.sort()
        random_cuts.append(gene_number)

        genes_1 = self.genes
        genes_2 = individual.get_genes()

        for j in range(len(random_cuts) - 1):
            random_cut_1 = random_cuts[j]
            random_cut_2 = random_cuts[j + 1]

            for i in range(random_cut_1, random_cut_2):
                new_genes[i] = genes_1[i].get_copy()

                aux = genes_1
                genes_1 = genes_2
                genes_2 = aux

        return self.__class__(new_genes)

    def uniform_cross_over(self, individual):
        """
        Returns a list of genes that correspond to a mix of the genes of both individuals in the corresponding positions
        :param individual: <InputIndividual> the individual to do crossover with
        :return: <InputIndividual> a new individual that corresponds to the crossover of this individual and the
                                    individual passed
        """
        new_genes = list()

        for i in range(min(len(self.genes), len(individual.get_genes()))):
            if random.random() < 0.5:
                new_genes.append(self.genes[i].get_copy())
            else:
                new_genes.append(individual.get_genes()[i].get_copy())

        return self.__class__(new_genes)

    def mutate(self):
        """
        Mutates a random gene of the individual
        """
        random_gene = random.choice(self.genes)
        random_gene.mutate()

    def get_inputs(self):
        """
        Gets the input script of the individual
        :return: <InputScript> the input script that this individual represents
        """
        raise RuntimeError(
            "This individual's class doesn't have get_inputs method defined. Every individual should have this method "
            "defined so this is clearly an error, a runtime error if I may add.")

    def add_metric(self, key, val):
        """
        Adds a metric to the individual
        :param key: <str> the name of the metric to add to the individual
        :param val: <num> the value of the metric to add to the individual
        """
        self.metrics[key] = val

    def get_metric(self, key):
        """
        Gets the value of a metric of the individual
        :param key: <str> the name of the metric to get
        :return: <num> the value of the metric to get
        """
        return self.metrics[key]

    def get_metrics(self):
        """
        getter
        """
        return self.metrics

    def get_genes(self):
        """
        getter
        """
        return self.genes
