from ga_settings.word_list import word_list
from random import random, choice


class SingleKeyGene():
    """
    A single input key gene, represents a key press for one frame
    """

    def __init__(self, key_input):
        """
        :param key_input: <str> the input key to press
        """
        self.key_input = key_input

    def cross_over(self, gene):
        """
        Returns a new Single Key Gene with one of the inputs
        :param gene: <SingleKeyGene>
        :return: <SingleKeyGene> a new Single Key Gene with one of the inputs
        """
        new_input = self.key_input

        if random() < 0.5:
            new_input = gene.get_key_input()

        return SingleKeyGene(new_input)

    def mutate(self):
        """
        Mutates the current gene
        """
        self.key_input = choice(word_list)

    def get_copy(self):
        """
        Returns a copy of the current gene
        :return: <SingleKeyGene> a copy of the current gene
        """
        return SingleKeyGene(self.key_input)

    def get_frames(self):
        """
        getter
        """
        return 1

    def get_key_input(self):
        """
        getter
        """
        return self.key_input
