import json
import sys

from ga_settings.consts import love_path, frames_to_clean, frames_to_test, frames_to_skip, frames_interval, \
    absolute_path, crash_counter
from lib.genetic_algorithm.testers.Tester import Tester
from lib.input_scripts.InputScript import InputScript
from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired


class LoveTester(Tester):
    """
    Tester class for testing individuals and get their fitness. Runs the game and returns the resulting fitness.
    """

    def __init__(self, aux_path="out", clean_script="clean", skip_script="skip", extra_frames=0, error_fitness=-9999999):
        """
        :param aux_path: <str> the path of the temporary file to create and use on the game
        :param clean_script: <str> the path of the script made to clean the game data before another test
        :param skip_script: <str> the script that runs at the beginning of each test to skip unimportant parts of the
                                    game like menus and tutorials
        :param extra_frames: <num> the amount of frames to keep running the tester after the amount of frames to test
                                    is over
        :param error_fitness: <num> the value of fitness of an individual that made the game crash for any reason
                                    (these individuals are saved automatically in the same folder the best individuals
                                     of each generation are saved)
        """
        self.skip_script = skip_script
        self.clean_script = clean_script
        self.aux_path = aux_path
        self.extra_frames = extra_frames
        self.error_fitness = error_fitness

    def test(self, individual):
        """
        Test an individual and returns their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the fitness of the individual
        """

        # Get input script and save it as out
        original_input_script = individual.get_inputs()
        shifted_input_script = original_input_script.shift_frames(frames_to_skip)
        skip_input_script = InputScript(absolute_path + "/individuals/" + self.skip_script)

        input_script = shifted_input_script + skip_input_script
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

            if err != b'':
                crash_report_count = crash_counter.increase_count()
                crash_individual_path = absolute_path + "/individuals/" + sys.argv[4] + "/crash_" + str(crash_report_count)

                input_script.save_to_file(crash_individual_path)

                file = open(crash_individual_path + "_data", "w")
                file.write(err.decode())
                file.close()

                return self.error_fitness

            out = json.loads(out.decode())

            fitness = out["fitness"]
            metrics = out["metrics"]
            for metric_key in metrics.keys():
                individual.add_metric(metric_key, metrics[metric_key])

            return float(fitness)
