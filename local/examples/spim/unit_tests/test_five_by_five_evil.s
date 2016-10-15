.data
# String for printing
solvable_str: .asciiz "The puzzle is solvable? "
sol_str: .asciiz "The solution is: "

fail_str:   .asciiz "fail"

# Puzzles
puzzle: .word 5 grid

# Cages
cages5x5: .word '+' 14 4 pos_0 '-' 2 2 pos_1 '+' 6 2 pos_2 '+' 8 3 pos_3 '+' 12 3 pos_4 '+' 10 3 pos_5 '-' 4 2 pos_6 '+' 9 3 pos_7 0 2 1 pos_8 '-' 2 2 pos_9



#Grids
grid: .space 648


# pos 5x5
pos_0: .word 0 1 5 6
pos_1: .word 2 7
pos_2: .word 3 4
pos_3: .word 8 13 18
pos_4: .word 9 14 19
pos_5: .word 10 11 12
pos_6: .word 15 20
pos_7: .word 16 21 22
pos_8: .word 17
pos_9: .word 23 24


# Solution
solution: .space 328

# end MIPS section

.text
MAIN_STK_SPC = 4
main:
	# ===
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)
#==========================test six by six==========================
# ========================initialize the puzzle===
	la	$t0, puzzle
	li	$t1, 5
	sw	$t1, 0($t0) # Reset the size of puzzle by 6

	li	$t0, 0 # i = 0;
i_loop_5x5:	
	li	$t1, 0 # j = 0;
j_loop_5x5:
	sll $t2, $t0, 4 # i * 16
	la	$t3, cages5x5
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
	bge $t1, $t4, j_loop_end_5x5
	j 	j_loop_5x5
j_loop_end_5x5:
	addi $t0, $t0, 1 # i++
	bge	$t0, 10, i_loop_end_5x5
	j 	i_loop_5x5
i_loop_end_5x5:

# solution = {0, {0}}
	la	$t0, solution
	sw	$0, 0($t0)	
	sw	$0, 4($t0)

#=============recursive_backtracking(&solution, &puzzle)
	la	$a0, solvable_str
	jal	print_string
	la	$a0, solution
	la	$a1, puzzle
	li  $s0, 0xdeadbeef
	li  $s1, 0xdeadbeef
	li  $s2, 0xdeadbeef
	li  $s3, 0xdeadbeef
	li  $s4, 0xdeadbeef
	li  $s5, 0xdeadbeef
	li  $s6, 0xdeadbeef
	li  $s7, 0xdeadbeef

	jal	recursive_backtracking

	bne $s0, 0xdeadbeef, test_fail
	bne $s1, 0xdeadbeef, test_fail
	bne $s2, 0xdeadbeef, test_fail
	bne $s3, 0xdeadbeef, test_fail
	bne $s4, 0xdeadbeef, test_fail
	bne $s5, 0xdeadbeef, test_fail
	bne $s6, 0xdeadbeef, test_fail
	bne $s7, 0xdeadbeef, test_fail
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	#==================print out solution
	la	$a0, sol_str
	jal	print_string

	la	$t3, solution # &solution 
	li	$t0, 0 # i = 0;
sol_5_i_loop:	
	li	$t1, 0 # j = 0;
sol_5_j_loop:
	mul $t2, $t0, 5 # i * 5
	add $t2, $t2, $t1 # i * 5 + j
	addi $t2, $t2, 1 # +1 to find sol.assignment
	sll $t2, $t2, 2 # times 4 to find address
	add $t2, $t3, $t2
	lw	$a0, 0($t2) # solution.assignment[i*5+j]
	jal	print_int_and_space
	addi $t1, $t1, 1 # j++;
	bge	$t1, 5, sol_5_j_loop_end
	j 	sol_5_j_loop
sol_5_j_loop_end:
	addi $t0, $t0, 1 # i++
	bge	$t0, 5, sol_5_i_loop_end
	j 	sol_5_i_loop
sol_5_i_loop_end:
	jal	print_newline
	#===================================
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra
test_fail:
	la	$a0, fail_str
	jal	print_string
	jr  $0
