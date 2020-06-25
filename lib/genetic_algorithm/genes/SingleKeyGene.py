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
