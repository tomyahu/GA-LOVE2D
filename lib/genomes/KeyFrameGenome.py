from random import random
from lib.genomes.SingleKeyGenome import SingleKeyGenome
from lib.input_scripts.InputScript import InputScript


class KeyFrameGenome(SingleKeyGenome):
    """
    A genome that stores a certain key that was pressed on a certain frame for one frame
    """

    def __init__(self, key_input, frame):
        """
        :param key_input: <str> the input key to press
        :param frame: <int> the frame where to press the input
        """
        SingleKeyGenome.__init__(self, key_input)
        self.frame = frame

    def cross_over(self, genome):
        """
        Returns a new genome that may have the input and frame from any of the genomes passed
        :param genome: <KeyFrameGenome> a genome that represents an input and a frame
        :return: <KeyFrameGenome> a new genome that may have the input and frame from any of the genomes passed
        """
        new_input = self.key_input

        if random() < 0.5:
            new_input = genome.get_key_input()

        new_frame = self.frame

        if random() < 0.5:
            new_frame = genome.get_frame()

        return KeyFrameGenome(new_input, new_frame)

    def get_inputs(self):
        """
        Returns an input script with the data that this genome represents
        :return: <InputScript>
        """
        input_script = InputScript()
        input_script.add_input(self.key_input, self.frame, self.frame+1)
        return input_script

    def get_frame(self):
        """
        getter
        :return:
        """
        return self.frame
