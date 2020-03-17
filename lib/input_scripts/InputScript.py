# TODO: Document this
class InputScript:

    def __init__(self):
        self.input_dict = {}

    def add_input(self, input_key, start_frame, end_frame):
        self.add_input_aux(input_key, start_frame, True)
        self.add_input_aux(input_key, end_frame, False)

    def add_input_aux(self, input_key, frame, val):
        if not (frame in self.input_dict):
            self.input_dict[frame] = {}

        self.input_dict[frame][input_key] = val

    def __add__(self, other):
        new_input_script = InputScript()

        for frame, input_dict in self.input_dict:
            for input_key, val in input_dict:
                new_input_script.add_input_aux(input_key, frame, val)

        for frame, input_dict in other.get_input_dict():
            for input_key, val in input_dict:
                new_input_script.add_input_aux(input_key, frame, val)

        return new_input_script

    def get_input_dict(self):
        return self.input_dict
