local mode = arg[2]
arg[2] = nil

if mode == "run_tas" then
    require("love_ga_wrapper.run.run_tas")
elseif mode == "run_game" then
    require("game_main")
else
    error("Unrecognized second argument " .. arg[2])
end