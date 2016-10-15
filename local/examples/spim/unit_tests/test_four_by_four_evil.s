.data
# String for printing
solvable_str: .asciiz "The puzzle is solvable? "
sol_str: .asciiz "The solution is: "

fail_str:   .asciiz "fail"

# Puzzles
puzzle: .word 4 grid

#Cages
cages4x4: .word '+' 10 3 pos0 '-' 1 2 pos1 '+' 7 3 pos2 '-' 1 2 pos3 0 2 1 pos4 0 1 1 pos5 '-' 1 2 pos6 '-' 1 2 pos7


#Grids
grid: .space 648


# Positions 4x4
pos0: .word 0 1 5
pos1: .word 2 3
pos2: .word 4 8 12
pos3: .word 6 10
pos4: .word 7
pos5: .word 9
pos6: .word 11 15
pos7: .word 13 14

# Solution
solution: .space 328

.text
MAIN_STK_SPC = 4
main:
	# ===
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)
#==========================test four by four==========================
# ========================initialize the puzzle===
	li	$t0, 0 # i = 0;
i_loop_4x4:	
	li	$t1, 0 # j = 0;
j_loop_4x4:
	sll $t2, $t0, 4 # i * 16
	la	$t3, cages4x4 
	add $t2, $t3, $t2 # &cages[i]
	lw	$t3, 12($t2) # &cages[i].positions
	sll $t4, $t1, 2 # j * 4
	add $t4, $t3, $t4 
	lw	$t4, 0($t4) # cages[i].positions[j]

	la	$t3, puzzle
	lw 	$t3, 4($t3) #puzzle.grid
	sll	$t5, $t4, 3 # cages[i].positions[j] * 8
	add $t5, $t3, $t5 # puzzle.grid[cages[i].positions[j]]

	li	$t4, 511
	sw	$t4, 0($t5)	# puzzle.grid[cages[i].positions[j]].domain = 0x1ff;
	sw	$t2, 4($t5) # puzzle.grid[cages[i].positions[j]].cage = &(cages[i]);

	lw	$t4, 8($t2) # cages[i].num_cell
	addi $t1, $t1, 1 # j++;
	bge $t1, $t4, j_loop_end_4x4
	j 	j_loop_4x4
j_loop_end_4x4:
	addi $t0, $t0, 1 # i++
	bge	$t0, 8, i_loop_end_4x4
	j 	i_loop_4x4
i_loop_end_4x4:

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


# 	#==================print out solution
	la	$a0, sol_str
	jal	print_string

	la	$t3, solution # &solution 
	li	$t0, 0 # i = 0;
sol_4_i_loop:	
	li	$t1, 0 # j = 0;
sol_4_j_loop:
	sll $t2, $t0, 2 # i * 4
	add $t2, $t2, $t1 # i * 4 + j
	addi $t2, $t2, 1 # +1 to find sol.assignment
	sll $t2, $t2, 2 # times 4 to find address
	add $t2, $t3, $t2
	lw	$a0, 0($t2) # solution.assignment[i*4+j]
	jal	print_int_and_space
	addi $t1, $t1, 1 # j++;
	bge	$t1, 4, sol_4_j_loop_end
	j 	sol_4_j_loop
sol_4_j_loop_end:
	addi $t0, $t0, 1 # i++
	bge	$t0, 4, sol_4_i_loop_end
	j 	sol_4_i_loop
sol_4_i_loop_end:
	jal	print_newline

	#===================================
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra 

test_fail:
	la	$a0, fail_str
	jal	print_string
	jr  $0
