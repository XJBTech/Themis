.data
# String for printing
solvable_str: .asciiz "The puzzle is solvable? "
sol_str: .asciiz "The solution is: "

fail_str:   .asciiz "fail"

# Puzzles
puzzle: .word 8 grid

# Cages
cages8x8: .word '-' 2 2 pos_0 '+' 13 3 pos_1 '+' 9 3 pos_2 '+' 4 2 pos_3 '-' 2 2 pos_4 '+' 14 2 pos_5 0 1 1 pos_6 '+' 18 3 pos_7 '-' 3 2 pos_8 '+' 13 3 pos_9 '+' 26 4 pos_10 '+' 11 3 pos_11 '-' 5 2 pos_12 '-' 1 2 pos_13 '+' 16 3 pos_14 '+' 6 2 pos_15 '-' 7 2 pos_16 '+' 6 2 pos_17 '-' 3 2 pos_18 '-' 2 2 pos_19 '-' 5 2 pos_20 '-' 1 2 pos_21 '-' 2 2 pos_22 '-' 3 2 pos_23 '+' 15 4 pos_24 0 3 1 pos_25 '-' 1 2 pos_26 '-' 3 2 pos_27



#Grids
grid: .space 648


# pos 8x8
pos_0: .word 0 1
pos_1: .word 2 3 4
pos_2: .word 5 6 13
pos_3: .word 7 15
pos_4: .word 8 16
pos_5: .word 9 17
pos_6: .word 10
pos_7: .word 11 12 20
pos_8: .word 14 22
pos_9: .word 18 19 26
pos_10: .word 21 29 37 45
pos_11: .word 23 31 39
pos_12: .word 24 32
pos_13: .word 25 33
pos_14: .word 27 34 35
pos_15: .word 28 36
pos_16: .word 30 38
pos_17: .word 40 41
pos_18: .word 42 50
pos_19: .word 43 51
pos_20: .word 44 52
pos_21: .word 46 47
pos_22: .word 48 56
pos_23: .word 49 57
pos_24: .word 53 60 61 62
pos_25: .word 54
pos_26: .word 55 63
pos_27: .word 58 59


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
	li	$t1, 8
	sw	$t1, 0($t0) # Reset the size of puzzle by 6

	li	$t0, 0 # i = 0;
i_loop_8x8:	
	li	$t1, 0 # j = 0;
j_loop_8x8:
	sll $t2, $t0, 4 # i * 16
	la	$t3, cages8x8
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
	bge $t1, $t4, j_loop_end_8x8
	j 	j_loop_8x8
j_loop_end_8x8:
	addi $t0, $t0, 1 # i++
	bge	$t0, 28, i_loop_end_8x8
	j 	i_loop_8x8
i_loop_end_8x8:

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

	#===================================
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra

test_fail:
	la	$a0, fail_str
	jal	print_string
	jr  $0
