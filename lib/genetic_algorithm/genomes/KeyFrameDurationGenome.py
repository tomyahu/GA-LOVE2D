import random

from lib.input_scripts.InputScript import InputScript
from lib.genetic_algorithm.genomes.KeyFrameGenome import KeyFrameGenome


class KeyFrameDurationGenome(KeyFrameGenome):
    """
    A genome that stores a certain key that was pressed in a certain frame for a number of frames
    """

    def __init__(self, key_input, frame, frame_duration):
        """
        :param key_input: <str> the input key to press
        :param frame: <int> the frame when the input is pressed
        :param frame_duration: <int> the amount of frames the input stays pressed
        """
        KeyFrameGenome.__init__(self, key_input, frame)
        self.frame_duration = frame_duration

    def mutate_with_max_frame(self, max_frame):
        """
        Mutates the frame and duration of the individual and changes it to a random space between 1 and the max frame
        :param max_frame: <int> the maximum frame that the genome can work on
        """
        random_frame_1 = random.randint(1,max_frame)
        random_frame_2 = random.randint(1,max_frame)

        min_random_frame = min(random_frame_1, random_frame_2)
        max_random_frame = max(random_frame_1, random_frame_2)

        self.frame = min_random_frame
        self.frame_duration = max_random_frame - min_random_frame

    def get_inputs(self):
        """
        Returns an input script with the data that this genome represents
        :return: <InputScript> the input script that corresponds to this genome
        """
        input_script = InputScript()
        input_script.add_input(self.key_input, self.frame, self.frame + self.frame_duration)
        return input_script

    def get_copy(self):
        """
        Returns a copy of the current genome
        :return: <KeyFrameDurationGenome> a copy of the current genome
        """
        return KeyFrameDurationGenome(self.key_input, self.frame, self.frame_duration)

    def get_duration(self):
        """
        getter
        """
        return self.frame_duration
