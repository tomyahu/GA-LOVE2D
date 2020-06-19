from random import random
from lib.genetic_algorithm.genes.SingleKeyGene import SingleKeyGene
from lib.input_scripts.InputScript import InputScript


class KeyFrameGene(SingleKeyGene):
    """
    A gene that stores a certain key that was pressed on a certain frame for one frame
    """

    def __init__(self, key_input, frame):
        """
        :param key_input: <str> the input key to press
        :param frame: <int> the frame where to press the input
        """
        SingleKeyGene.__init__(self, key_input)
        self.frame = frame

    def cross_over(self, gene):
        """
        Returns a new gene that may have the input and frame from any of the genes passed
        :param gene: <KeyFrameGene> a gene that represents an input and a frame
        :return: <KeyFrameGene> a new gene that may have the input and frame from any of the genes passed
        """
        new_input = self.key_input

        if random() < 0.5:
            new_input = gene.get_key_input()

        new_frame = self.frame

        if random() < 0.5:
            new_frame = gene.get_frame()

        return KeyFrameGene(new_input, new_frame)

    def mutate_with_max_frame(self, max_frame):
        """
        Mutates the frame of the individual and changes it to a random frame from 1 to the max frame
        :param max_frame: <int> the max frame for the gene to mutate
        """
        self.frame = random.randint(1,max_frame)

    def get_inputs(self):
        """
        Returns an input script with the data that this gene represents
        :return: <InputScript> the input script that corresponds to this gene
        """
        input_script = InputScript()
        input_script.add_input(self.key_input, self.frame, self.frame+1)
        return input_script

    def get_copy(self):
        """
        Returns a copy of the current gene
        :return: <KeyFrameGene> a copy of the current gene
        """
        return KeyFrameGene(self.key_input, self.frame)

    def get_frame(self):
        """
        getter
        """
        return self.frame
