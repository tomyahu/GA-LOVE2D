from ga_settings.word_list import word_list
from random import random, randint, choice


class SingleKeyGenome():
    """
    A single input key genome, represents a key press for one frame
    """

    def __init__(self, key_input):
        """
        :param key_input: <str> the input key to press
        """
        self.key_input = key_input

    def cross_over(self, genome):
        """
        Returns a new Single Key Genome with one of the inputs
        :param genome: <SingleKeyGenome>
        :return: <SingleKeyGenome> a new Single Key Genome with one of the inputs
        """
        new_input = self.key_input

        if random() < 0.5:
            new_input = genome.get_key_input()

        return SingleKeyGenome(new_input)

    def mutate(self):
        """
        Mutates the current genome
        """
        self.key_input = choice(word_list)

    def get_copy(self):
        """
        Returns a copy of the current genome
        :return: <SingleKeyGenome> a copy of the current genome
        """
        return SingleKeyGenome(self.key_input)

    @staticmethod
    def get_frames():
        """
        getter
        """
        return 1

    def get_key_input(self):
        """
        getter
        """
        return self.key_input
