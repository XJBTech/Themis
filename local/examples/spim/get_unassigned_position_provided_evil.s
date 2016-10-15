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
## // Returns next position for assignment.
## int get_unassigned_position(const Solution* solution, const Puzzle* puzzle) {
##   int unassigned_pos = 0;
##   for (; unassigned_pos < puzzle->size * puzzle->size; unassigned_pos++) {
##     if (solution->assignment[unassigned_pos] == 0) {
##       break;
##     }
##   }
##   return unassigned_pos;
## }

.globl get_unassigned_position
get_unassigned_position:
	li	$v0, 0            # unassigned_pos = 0
	lw	$t0, 0($a1)       # puzzle->size
	mul	$t0, $t0, $t0     # puzzle->size * puzzle->size
	add	$t1, $a0, 4       # &solution->assignment[0]
get_unassigned_position_for_begin:
	bge	$v0, $t0, get_unassigned_position_return  # if (unassigned_pos < puzzle->size * puzzle->size)
	mul	$t2, $v0, 4
	add	$t2, $t1, $t2     # &solution->assignment[unassigned_pos]
	lw	$t2, 0($t2)       # solution->assignment[unassigned_pos]
	beq	$t2, 0, get_unassigned_position_return  # if (solution->assignment[unassigned_pos] == 0)
	add	$v0, $v0, 1       # unassigned_pos++
	j	get_unassigned_position_for_begin
get_unassigned_position_return:

    li    $a0, 0xdeadbeef
    li    $a1, 0xdeadbeef
    li    $a2, 0xdeadbeef
    li    $a3, 0xdeadbeef
    li    $t0, 0xdeadbeef
    li    $t1, 0xdeadbeef
    li    $t2, 0xdeadbeef
    li    $t3, 0xdeadbeef
    li    $t4, 0xdeadbeef
    li    $t5, 0xdeadbeef
    li    $t6, 0xdeadbeef
    li    $t7, 0xdeadbeef
    li    $t8, 0xdeadbeef
    li    $t9, 0xdeadbeef
    li    $v1, 0xdeadbeef
	jr	$ra
