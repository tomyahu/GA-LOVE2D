from lib.os_lib.cd import cd
from subprocess import Popen, PIPE, TimeoutExpired

love_path = "C:\Program Files\love_versions\love-0.10.0-win64\love.exe"

with cd("./love_ga_wrapper"):
    p = Popen([love_path, ".", "run_tas"], stdin=PIPE, stdout=PIPE, stderr=PIPE)

    try:
        out, err = p.communicate()
    except TimeoutExpired:
        p.kill()
        out, err = p.communicate()

    print("out:\n", out.decode())
    print("err:\n", err.decode())