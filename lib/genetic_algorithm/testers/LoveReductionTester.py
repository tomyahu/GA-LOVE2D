from subprocess import Popen, PIPE, TimeoutExpired

from ga_settings.consts import absolute_path, frames_to_clean, love_path, frames_interval, frames_to_test, \
    frames_to_skip
from lib.genetic_algorithm.testers.LoveTester import LoveTester
from lib.os_lib.cd import cd


class LoveReductionTester(LoveTester):
    """
    Tester class for reducing individuals that crash the game. It evaluates individuals that do not crash the game with
    0 fitness; and individuals that do crash the game with the multiplicative inverse as the number of genes of
    individuals.
    """

    def __init__(self, target_input_sequence, aux_path="out", clean_script="clean", extra_frames=0):
        """
        :param target_input_sequence: <InputScript> the input sequence to perform reduction on
        :param aux_path: <str> the path of the temporary file to create and use on the game
        :param clean_script: <str> the path of the script made to clean the game data before another test
        :param skip_script: <str> the script that runs at the beginning of each test to skip unimportant parts of the
                                    game like menus and tutorials
        :param extra_frames: <num> the amount of frames to keep running the tester after the amount of frames to test
                                    is over
        """
        LoveTester.__init__(
            self,
            aux_path=aux_path,
            clean_script=clean_script,
            extra_frames=extra_frames,
            error_fitness=0.0
        )

    def test(self, individual):
        """
        Test an individual and returns their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the fitness of the individual
        """
        input_script = individual.get_inputs()
        input_script.save_to_file(absolute_path + "/individuals/" + self.aux_path)

        with cd(absolute_path + "/love_ga_wrapper"):
            if frames_to_clean > 0:
                p = Popen([love_path, ".", "run_tas", self.clean_script, str(frames_to_clean), "0", str(frames_interval)],
                          stdin=PIPE, stdout=PIPE, stderr=PIPE)
                p.communicate()

            p = Popen([love_path, ".", "run_tas", self.aux_path, str(frames_to_test + self.extra_frames), str(frames_to_skip),
                       str(frames_interval)], stdin=PIPE, stdout=PIPE, stderr=PIPE)

            try:
                out, err = p.communicate(timeout=100)
            except TimeoutExpired:
                p.kill()
                out, err = p.communicate()
                err += b'//timeout'

            fitness = self.error_fitness

            if err != b'':
                fitness = 1.0 / len(individual.get_genes())

            return fitness
