from ga_settings.consts import love_path, frames_to_clean, frames_to_test, frames_to_skip, frames_interval
from lib.genetic_algorithm.testers.Tester import Tester
from lib.input_scripts.InputScript import InputScript
from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired


class LoveTester(Tester):
    """
    Tester class for testing individuals and get their fitness. Runs the game and returns the resulting fitness.
    """

    def __init__(self, aux_path="out", clean_script="clean", skip_script="skip"):
        self.skip_script = skip_script
        self.clean_script = clean_script
        self.aux_path = aux_path

    def test(self, individual):
        """
        Test an individual and returns their fitness
        :param individual: <InputIndividual> the individual to be tested
        :return: <num> the fitness of the individual
        """

        # Get input script and save it as out
        original_input_script = individual.get_inputs()
        shifted_input_script = original_input_script.shift_frames(frames_to_skip)
        skip_input_script = InputScript("individuals/" + self.skip_script)

        input_script = shifted_input_script + skip_input_script
        input_script.save_to_file("individuals/" + self.aux_path)

        with cd("./love_ga_wrapper"):
            p = Popen([love_path, ".", "run_tas", self.clean_script, str(frames_to_clean), str(frames_interval)],
                      stdin=PIPE, stdout=PIPE, stderr=PIPE)
            p.communicate()

            p = Popen([love_path, ".", "run_tas", self.aux_path, str(frames_to_test + frames_to_skip),
                       str(frames_interval)], stdin=PIPE, stdout=PIPE, stderr=PIPE)

            try:
                out, err = p.communicate()
            except TimeoutExpired:
                p.kill()
                out, err = p.communicate()

            if err != b'':
                raise RuntimeError("Game Crashed.\nError: " + err.decode())

            return float(out)
