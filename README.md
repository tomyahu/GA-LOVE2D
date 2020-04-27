# GA LOVE2D

Its a tool made to reproduce "Error Inducing Input Sequences" in videogames made with LÖVE2D.
It uses genetic algorithms to generate input sequences and evaluates them using the game's variables.
The input sequences obtained by the genetic algorithm are saved in a folder alongside with the data of the genetic algorithm variables.

## Install it
This tool has only been tested for windows so only those instructions are included for now.

### Windows

#### Step 1
Clone this repository in your computer, you can do this by opening a terminal inside a folder and run:

```
$ git clone https://github.com/tomyahu/GA-LOVE2D
```

#### Step 2
In the game you want to run rename the `main.lua` file to `game_main.lua`.
Then copy all of the game files to the `love_ga_wrapper` folder in this project.

#### Step 3
You're done, go to [wiki](wiki) for further instructions for running the genetic algorithm.

## Features Planed

* Input sequence reduction for simplifying input sequences and so make them easier to understand
* Inpus sequence visualization 