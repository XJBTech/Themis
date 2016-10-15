.text

## struct Puzzle {
##   int size;
##   Cell* grid;
## };
##
## struct Solution {
##   int size;
##   int assignment[81];
## };
##
## // Checks if the solution is complete.
## int is_complete(const Solution* solution, const Puzzle* puzzle) {
##   return solution->size == puzzle->size * puzzle->size;
## }

.globl is_complete
is_complete:
	lw	$t0, 0($a0)       # solution->size
	lw	$t1, 0($a1)       # puzzle->size
	mul	$t1, $t1, $t1     # puzzle->size * puzzle->size
	move	$v0, $0
	seq	$v0, $t0, $t1
	j	$ra
