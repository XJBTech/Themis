.data
# String for printing
solvable_str: .asciiz "The puzzle is solvable? "
sol_str: .asciiz "The solution is: "


# Puzzles
puzzle: .word 4 grid

#Cages
cages6x6: .word '+' 7 2 pos_0 '-' 2 2 pos_1 '+' 8 2 pos_2 '+' 7 2 pos_3 '-' 1 2 pos_4 '-' 2 2 pos_5 '-' 3 2 pos_6 '-' 2 2 pos_7 '+' 7 2 pos_8 '+' 13 3 pos_9 0 1 1 pos_10 '+' 10 2 pos_11 '+' 7 2 pos_12 '-' 2 2 pos_13 '-' 1 2 pos_14 '-' 1 2 pos_15 '+' 7 2 pos_16 '-' 1 2 pos_17


#Grids
grid: .space 648


# pos 6x6
pos_0: .word 0 6
pos_1: .word 1 2
pos_2: .word 3 9
pos_3: .word 4 10
pos_4: .word 5 11
pos_5: .word 7 13
pos_6: .word 8 14
pos_7: .word 12 18
pos_8: .word 15 21
pos_9: .word 16 22 28
pos_10: .word 17
pos_11: .word 19 20
pos_12: .word 23 29
pos_13: .word 24 30
pos_14: .word 25 31
pos_15: .word 26 27
pos_16: .word 32 33
pos_17: .word 34 35

# Solution
solution: .space 328

.text
MAIN_STK_SPC = 4
main:
	# ===
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)
#==========================test six by six==========================
# ========================initialize the puzzle===
	la	$t0, puzzle
	li	$t1, 6
	sw	$t1, 0($t0) # Reset the size of puzzle by 6

	li	$t0, 0 # i = 0;
i_loop_6x6:	
	li	$t1, 0 # j = 0;
j_loop_6x6:
	sll $t2, $t0, 4 # i * 16
	la	$t3, cages6x6
	add $t2, $t3, $t2 # &cages[i]
	lw	$t3, 12($t2) # &cages[i].positions
	sll $t4, $t1, 2 # j * 4
	add $t4, $t3, $t4 
	lw	$t4, 0($t4) # cages[i].positions[j]

	la	$t3, puzzle
	lw 	$t3, 4($t3) # &puzzle.grid
	sll	$t5, $t4, 3 # cages[i].positions[j] * 8
	add $t5, $t3, $t5 # puzzle.grid[cages[i].positions[j]]

	li	$t4, 511
	sw	$t4, 0($t5)	# puzzle.grid[cages[i].positions[j]].domain = 0x1ff;
	sw	$t2, 4($t5) # puzzle.grid[cages[i].positions[j]].cage = &(cages[i]);

	lw	$t4, 8($t2) # cages[i].num_cell
	addi $t1, $t1, 1 # j++;
	bge $t1, $t4, j_loop_end_6x6
	j 	j_loop_6x6
j_loop_end_6x6:
	addi $t0, $t0, 1 # i++
	bge	$t0, 18, i_loop_end_6x6
	j 	i_loop_6x6
i_loop_end_6x6:

# solution = {0, {0}}
	la	$t0, solution
	sw	$0, 0($t0)	
	sw	$0, 4($t0)

#=============recursive_backtracking(&solution, &puzzle)
	la	$a0, solvable_str
	jal	print_string
	la	$a0, solution
	la	$a1, puzzle
	jal	recursive_backtracking
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	#==================print out solution
	la	$a0, sol_str
	jal	print_string

	la	$t3, solution # &solution 
	li	$t0, 0 # i = 0;
sol_6_i_loop:	
	li	$t1, 0 # j = 0;
sol_6_j_loop:
	mul $t2, $t0, 6 # i * 6
	add $t2, $t2, $t1 # i * 6 + j
	addi $t2, $t2, 1 # +1 to find sol.assignment
	sll $t2, $t2, 2 # times 4 to find address
	add $t2, $t3, $t2
	lw	$a0, 0($t2) # solution.assignment[i*6+j]
	jal	print_int_and_space
	addi $t1, $t1, 1 # j++;
	bge	$t1, 6, sol_6_j_loop_end
	j 	sol_6_j_loop
sol_6_j_loop_end:
	addi $t0, $t0, 1 # i++
	bge	$t0, 6, sol_6_i_loop_end
	j 	sol_6_i_loop
sol_6_i_loop_end:
	jal	print_newline
	#===================================
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra
