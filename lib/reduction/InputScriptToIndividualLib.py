from lib.genetic_algorithm.genomes.KeyFrameDurationGenome import KeyFrameDurationGenome
from lib.genetic_algorithm.individuals.InputKeyFrameDurationIndividual import InputKeyFrameDurationIndividual


class InputScriptToIndividualLib:
    """
    TODO: Document this class
    """

    @staticmethod
    def to_key_frame_duration_individual(input_script):
        return InputKeyFrameDurationIndividual(InputScriptToIndividualLib.to_key_frame_duration_individual_aux(input_script))

    @staticmethod
    def to_key_frame_duration_individual_aux(input_script):
        gene_list = list()

        input_dict = input_script
        input_dict_keys = list(input_dict.keys())

        input_dict_keys.sort()

        aux_dict = dict()

        for frame in input_dict_keys:
            inputs = input_dict[frame]

            for input_key, val in inputs:
                if val:
                    aux_dict[input_key] = frame
                else:
                    if input_key in aux_dict.keys():
                        gene_list.append(
                            KeyFrameDurationGenome(input_key, aux_dict[input_key], frame - aux_dict[input_key]))
                        del aux_dict[input_key]

        return gene_list
