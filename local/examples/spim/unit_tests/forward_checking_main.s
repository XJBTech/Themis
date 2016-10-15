.data
# String for printing
row2_str: .asciiz "Result of checking inconsistent values from row is: "
rowgrid3_str: .asciiz "Domain of grid 3 is: "

col4_str: .asciiz "Result of checking inconsistent values from column is: "
colgrid5_str:	.asciiz "Domain of grid 5 is: "
colgrid6_str:	.asciiz "Domain of grid 6 is: "
colgrid7_str:	.asciiz "Domain of grid 7 is: "
colgrid8_str:	.asciiz "Domain of grid 8 is: "

cage4_str:	.asciiz "Result of checking inconsistent values from cage is: "
cagegrid6_str:	.asciiz "Domain of grid 6 is: "
cagegrid7_str:	.asciiz "Domain of grid 7 is: "
cagegrid8_str:	.asciiz "Domain of grid 8 is: "


suc4_str:	.asciiz "Result of checking inconsistent values (should be successful) is: "
sucgrid5_str:	.asciiz "Domain of grid 5 is: "
sucgrid6_str:	.asciiz "Domain of grid 6 is: "
sucgrid8_str:	.asciiz "Domain of grid 8 is: "
sucgrid12_str:	.asciiz "Domain of grid 12 is: "


#=====================
puzzle: .word 4 grid

grid: .space 648

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

row_domain: .word 1 2 4 4 14 13 15 11 14 13 15 11 14 13 15 11
col_domain:	.word 1 14 14 14 2 15 15 15 2 13 13 13 14 15 15 15
cage_domain: .word 1 2 4 8 2 13 11 7 12 13 11 7 12 13 11 7
valid_domain: .word 4 8 2 1 1 7 13 14 11 7 13 14 11 7 13 14
#=====================




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

	#la	$t3, puzzle
	#lw 	$s0, 4($t3) #puzzle.grid
	la  $t3, grid #puzzle.grid
	sll	$t5, $t4, 3 # cages[i].positions[j] * 8
	add $t5, $t3, $t5 # puzzle.grid[cages[i].positions[j]]

	sw	$t2, 4($t5) # puzzle.grid[cages[i].positions[j]].cage = &(cages[i]);

	lw	$t4, 8($t2) # cages[i].num_cell
	addi $t1, $t1, 1 # j++;
	bge $t1, $t4, j_loop_end
	j 	j_loop
j_loop_end:
	addi $t0, $t0, 1 # i++
	bge	$t0, 8, i_loop_end
	j 	i_loop
i_loop_end:

# ====Initialize the domain for each cell (row)====
	li	$t0, 0		# i = 0
row_domain_loop:
	bge	$t0, 16, row_domain_loop_end # i < 16
	sll $t1, $t0, 3 # i * 8
	la	$t3, grid
	add $t1, $t3, $t1 # puzzle.grid[i]
	sll $t2, $t0, 2 # i * 4
	la	$t4, row_domain
	add $t4, $t4, $t2
	lw	$t4, 0($t4) # row_domain[i]
	sw	$t4, 0($t1) # puzzle.grid[i].domain = row_domain[i];

	addi $t0, $t0, 1 # i++;
	j  row_domain_loop

row_domain_loop_end:

	# ===forward_checking(2, &puzzle)===
	la	$a0, row2_str
	jal	print_string
	li	$a0, 2
	la	$a1, puzzle
	jal	forward_checking
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, rowgrid3_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 24($t0)
	jal	print_int_and_space
	jal	print_newline


# ====Initialize the domain for each cell (col)====
	li	$t0, 0
col_domain_loop:
	bge	$t0, 16, col_domain_loop_end
	sll $t1, $t0, 3 # i * 8
	la	$t3, grid
	add $t1, $t3, $t1 # puzzle.grid[i]
	sll $t2, $t0, 2 # i * 4
	la	$t4, col_domain
	add $t4, $t4, $t2
	lw	$t4, 0($t4) # col_domain[i]
	sw	$t4, 0($t1) # puzzle.grid[i].domain = col_domain[i];

	addi $t0, $t0, 1 # i++;
	j  col_domain_loop

col_domain_loop_end:


	# ===forward_checking(4, &puzzle)===
	la	$a0, col4_str
	jal	print_string
	li	$a0, 4
	la	$a1, puzzle
	jal	forward_checking
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, colgrid5_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 40($t0)
	jal	print_int_and_space
	jal	print_newline


	la	$a0, colgrid6_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 48($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, colgrid7_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 56($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, colgrid8_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 64($t0)
	jal	print_int_and_space
	jal	print_newline


#===========Initialize the domain for each cell (cage)====
	li	$t0, 0
cage_domain_loop:
	bge	$t0, 16, cage_domain_loop_end
	sll $t1, $t0, 3 # i * 8
	la	$t3, grid
	add $t1, $t3, $t1 # puzzle.grid[i]
	sll $t2, $t0, 2 # i * 4
	la	$t4, cage_domain
	add $t4, $t4, $t2
	lw	$t4, 0($t4) # cage_domain[i]
	sw	$t4, 0($t1) # puzzle.grid[i].domain = cage_domain[i];

	addi $t0, $t0, 1 # i++;
	j  cage_domain_loop

cage_domain_loop_end:


	# ===forward_checking(4, &puzzle)===
	la	$a0, cage4_str
	jal	print_string
	li	$a0, 4
	la	$a1, puzzle
	jal	forward_checking
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, cagegrid6_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 48($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, cagegrid7_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 56($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, cagegrid8_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 64($t0)
	jal	print_int_and_space
	jal	print_newline




#===========Initialize the domain for each cell (valid)====
	li	$t0, 0
valid_domain_loop:
	bge	$t0, 16, valid_domain_loop_end
	sll $t1, $t0, 3 # i * 8
	la	$t3, grid
	add $t1, $t3, $t1 # puzzle.grid[i]
	sll $t2, $t0, 2 # i * 4
	la	$t4, valid_domain
	add $t4, $t4, $t2
	lw	$t4, 0($t4) # valid_domain[i]
	sw	$t4, 0($t1) # puzzle.grid[i].domain = valid_domain[i];

	addi $t0, $t0, 1 # i++;
	j  valid_domain_loop

valid_domain_loop_end:




	# ===forward_checking(4, &puzzle)===
	la	$a0, suc4_str
	jal	print_string
	li	$a0, 4
	la	$a1, puzzle
	jal	forward_checking
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, sucgrid5_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 40($t0)
	jal	print_int_and_space
	jal	print_newline


	la	$a0, sucgrid6_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 48($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, sucgrid8_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 64($t0)
	jal	print_int_and_space
	jal	print_newline

	la	$a0, sucgrid12_str
	jal	print_string
	la	$t0, grid
	lw	$a0, 96($t0)
	jal	print_int_and_space
	jal	print_newline

	#===
	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	j  $ra
