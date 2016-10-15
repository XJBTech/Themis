## void
## test_is_complete() {
##     Cage cages[8] = {
##         {'+', 10, 3, new int[3]{0, 1, 5}}, {'-', 1, 2, new int[2]{2, 3}},
##         {'+', 7, 3, new int[3]{4, 8, 12}}, {'-', 1, 2, new int[2]{6, 10}},
##         {0, 2, 1, new int[1]{7}},          {0, 1, 1, new int[1]{9}},
##         {'-', 1, 2, new int[2]{11, 15}},   {'-', 1, 2, new int[2]{13, 14}}};
##
##     Puzzle puzzle = {4, new Cell[81]};
##     for (int i = 0; i < 8; i++) {
##         for (int j = 0; j < cages[i].num_cell; j++) {
##             puzzle.grid[cages[i].positions[j]].domain = 0x1ff;
##             puzzle.grid[cages[i].positions[j]].cage = &(cages[i]);
##         }
##     }
##
##     Solution complete_solution = {
##         16, {1, 4, 3, 2, 2, 1, 4, 3, 3, 2, 1, 4, 4, 3, 2, 1}};
##     Solution incomplete_solution = {4, {1, 4, 3, 2}};
##
##     assert(is_complete(&complete_solution, &puzzle) == 1);
##     assert(is_complete(&incomplete_solution, &puzzle) == 0);
## }
##
## struct Cage {
##     char operation;
##     int target;
##     int num_cell;
##     int *positions;
## };
## 
## struct Cell {
##     int domain;
##     Cage *cage;
## };
## 
## struct Puzzle {
##     int size;
##     Cell *grid;
## };
## 
## struct Solution {
##     int size;
##     int assignment[81];
## };

.data
# String for printing
Solution_complete_str: .asciiz "Accept complete solution, returns "
Solution_incomplete_str: .asciiz "Accept incomplete solution, returns "

# Puzzle
puzzle: .word 4 grid
# Cell
# grid: .word 15 cage0 15 cage0 15 cage1 15 cage1 15 cage2 15 cage0 15 cage3 15 cage4 15 cage2 15 cage5 15 cage3 15 cage6 15 cage2 15 cage7 15 cage7 15 cage6
grid: .space 648

# Cages
cages: .word '+' 10 3 pos0 '-' 1 2 pos1 '+' 7 3 pos2 '-' 1 2 pos3 0 2 1 pos4 0 1 1 pos5 '-' 1 2 pos6 '-' 1 2 pos7

# Positions
pos0: .word 0 1 5
pos1: .word 2 3
pos2: .word 4 8 12
pos3: .word 6 10
pos4: .word 7
pos5: .word 9
pos6: .word 11 15
pos7: .word 13 14

# Solution
solution_cmp: .word 16 1 4 3 2 2 1 4 3 3 2 1 4 4 3 2 1
solution_icmp: .word 81 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text
MAIN_STK_SPC = 4
main:
	# ===
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	# ===initialize the puzzle===
	li	$t0, 0 # i = 0;
i_loop:	
	li	$t1, 0 # j = 0;
j_loop:
	sll $t2, $t0, 4 # i * 16
	la	$t3, cages 
	add $t2, $t3, $t2 # &cages[i]
	lw	$t3, 12($t2) # &cages[i].positions
	sll $t4, $t1, 2 # j * 4
	add $t4, $t3, $t4 
	lw	$t4, 0($t4) # cages[i].positions[j]

	la	$t3, puzzle
	lw 	$t3, 4($t3) #puzzle.grid
	sll	$t5, $t4, 3 # cages[i].positions[j] * 8
	add $t5, $t3, $t5 # puzzle.grid[cages[i].positions[j]]

	li	$t3, 511
	sw	$t3, 0($t5)	# puzzle.grid[cages[i].positions[j]].domain = 0x1ff;
	sw	$t2, 4($t5) # puzzle.grid[cages[i].positions[j]].cage = &(cages[i]);

	lw	$t3, 8($t2) # cages[i].num_cell
	addi $t1, $t1, 1 # j++;
	bge $t1, $t3, j_loop_end
	j 	j_loop
j_loop_end:
	addi $t0, $t0, 1 # i++
	bge	$t0, 8, i_loop_end
	j 	i_loop
i_loop_end:
	
	# is_complete(&complete_solution, &puzzle)
	la	$a0, Solution_complete_str
	jal	print_string
	la	$a0, solution_cmp
	la	$a1, puzzle
	jal	is_complete
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	# is_complete(&incomplete_solution, &puzzle)
	la	$a0, Solution_incomplete_str
	jal	print_string
	la	$a0, solution_icmp
	la	$a1, puzzle
	jal	is_complete
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	#===
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra
