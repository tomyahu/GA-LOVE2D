from lib.genetic_algorithm.genes.KeyFrameDurationGene import KeyFrameDurationGene
from lib.genetic_algorithm.individuals.InputKeyFrameDurationIndividual import InputKeyFrameDurationIndividual
from lib.genetic_algorithm.individuals.ReductionKeyFrameDurationIndividual import ReductionKeyFrameDurationIndividual


class InputScriptToIndividualLib:
    """
    Library class to transform input sequences to genetic algorithm individuals
    """

    @staticmethod
    def to_reduction_key_frame_duration_individual(input_script):
        """
        Transform an input sequence into a KeyFrameDurationIndividual object
        :param input_script: <InputScript> an input sequence object
        :return: <ReductionKeyFrameDurationIndividual> a genetic algorithm individual that represents the input sequence
                                                    given
        """
        return ReductionKeyFrameDurationIndividual(
            InputScriptToIndividualLib.to_key_frame_duration_individual_aux(input_script)
        )

    @staticmethod
    def to_key_frame_duration_individual(input_script):
        """
        Transform an input sequence into a KeyFrameDurationIndividual object
        :param input_script: <InputScript> an input sequence object
        :return: <InputKeyFrameDurationIndividual> a genetic algorithm individual that represents the input sequence
                                                    given
        """
        return InputKeyFrameDurationIndividual(
            InputScriptToIndividualLib.to_key_frame_duration_individual_aux(input_script)
        )

    @staticmethod
    def to_key_frame_duration_individual_aux(input_script):
        """
        Auxiliary method for to_key_frame_duration_individual method
        Transforms an input sequence into a list of key frame duration genes
        :param input_script: <InputScript> an input sequence object
        :return: <list(KeyFrameDurationGene)> a list of genes that represents the input sequence given
        :param input_script:
        :return:
        """
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
                            KeyFrameDurationGene(input_key, aux_dict[input_key], frame - aux_dict[input_key]))
                        del aux_dict[input_key]

        return gene_list
