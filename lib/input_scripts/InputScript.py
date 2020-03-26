import ast


class InputScript:
    """
    Class for managing input scripts
    """

    def __init__(self, file_path=None):
        if file_path == None:
            self.input_dict = dict()
            return

        f = open(file_path)
        input_script_str = f.read()
        input_script_str = input_script_str.replace("false", "False")
        input_script_str = input_script_str.replace("true", "True")

        self.input_dict = ast.literal_eval(input_script_str)

    def add_input(self, input_key, start_frame, end_frame):
        """
        Adds an input to the input script
        :param input_key: <str> the key that corresponds to the input
        :param start_frame: <int> the start frame of the input
        :param end_frame: <int> the end frame of the input
        """
        self.add_input_aux(input_key, start_frame, True)
        self.add_input_aux(input_key, end_frame, False)

    def add_input_aux(self, input_key, frame, val):
        """
        Auxiliar method for add_input
        :param input_key: <str> the key that corresponds to the input
        :param frame: <int> the start frame of the input
        :param val: <bool> the value to save on the frame for that input (true for press and false for release)
        """
        if not (frame in self.input_dict):
            self.input_dict[frame] = dict()

        self.input_dict[frame][input_key] = val

    def __add__(self, other):
        new_input_script = InputScript()

        for frame, input_dict in self.input_dict.items():
            for input_key, val in input_dict.items():
                new_input_script.add_input_aux(input_key, frame, val)

        for frame, input_dict in other.get_input_dict().items():
            for input_key, val in input_dict.items():
                new_input_script.add_input_aux(input_key, frame, val)

        return new_input_script

    def __str__(self):
        input_dict_string = self.input_dict.__str__()
        input_dict_string = input_dict_string.replace("True", "true")
        input_dict_string = input_dict_string.replace("False", "false")
        input_dict_string = input_dict_string.replace("'", "\"")
        return input_dict_string

    def save_to_file(self, path):
        """
        Saves the input script to a path
        :param path: <str> the path of the file on which to save the input string
        """
        input_dict_string = self.__str__()
        file = open(path, "w")
        file.write(input_dict_string)
        file.close()

    def get_input_dict(self):
        return self.input_dict

    def shift_frames(self, frames_shifted):
        new_input_script = InputScript()
        for frame, input_dict_list in self.input_dict.items():
            for input_key, val in input_dict_list.items():
                new_input_script.add_input_aux(input_key, frame + frames_shifted, val)

        return new_input_script

