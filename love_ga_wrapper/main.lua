local mode = arg[2]
arg[2] = nil

if mode == "run_tas" then
    require("love_ga_wrapper.run.run_tas")
elseif mode == "run_game" then
	for i, val in pairs(arg) do
		if i > 1 then
			arg[i-1] = arg[i]
			arg[i] = nil
		end
	end

    require("game_main")
else
    error("Unrecognized second argument " .. arg[2])
end