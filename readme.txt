This was written as an example for one of my 'What Computer Scientists Know' talks.

This is a real-world use of recursion to play Connect 4.  If you think you remember Connect 4 as a 'kids game, along the lines of tic-tac-toe, you might be surprised how much strategy and depth of play truly exists.

To play it:

- have a working ruby install
- check this repo out of git
- bundle install
- start a game via rake:

rake play

(note depending on your machine config, you might need to 'bundle install rake play)

you will start as the black player, and black always moves first in connect 4.  If you want to start as the red player (and have the computer move first), then type

rake play[red]

note, you may have to type rake play\[red\], depending on your computer's shell.


Things to notice about the code.

Check out the rake task.  The board is an immutable value representing the current game state.  The player is where the magic happens to reurse and figure out what move to make.  the board_scorer is how each board is weighted based on a homegrown evaluation algorithm based on connect 4 "threats, opportunities, and openings".  A google search should tell you a little more about connect 4.

This demonstrates how to make computers 'think' about turn-based board games.  The depth-first recursive search and the evaluator are used to implement a min-max algorithm... at every turn then player is trying to maximize their board score while minimizing that of their opponent.  Notice the Player can be initialized with a 'depth' to consider.  The deeper you go, the harder it will be to beat, but the longer it will take to think.  Another game programming technique called 'alpha beta pruning' is used to make the computer consider fewer branches on the tree while still looking for the best move.

The Displayer class is just a quick hack so that I had something to run from the command line when showing this to a group of 5th graders participating in Computer Science Education Week.  For a true matrix-like experience, play this from the bundler console looking at nothing but board.inspect.

The code isn't the prettiest, and while there are tests, there aren't any around the min/max recursive tree stuff.  When I get my grant funding to teach computer cience conecpts in Ruby full time, I'll add a cleanup of this code to my top ten list.

This application shell is based on RASK, the Rake Application Starter Kit.  If you're wondering where the directory structure comes from, the support for development/test/roduction environments, etc... check that project out.  Its like all the comforts of Rails conventions, but for developing command line rake tasks.







player = Player.new(C4BoardScorer.new, 4)
b = C4Board.starting_board
b = b.move(player.best_move(b)); Displayer.display(b)