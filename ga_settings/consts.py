import os

from lib.structures.Counter import Counter

absolute_path = os.getcwd()

love_path = absolute_path + "/ga_settings/love_versions/love-0.10.2-win64/love.exe"

generations = 20
individual_num = 100
mutation_prob = 0.2
elitism_ratio = 0.05

frames_to_clean = 0
frames_to_skip = 350
frames_to_test = 400

frames_interval = 1

crash_counter = Counter()
