.text

## int
## convert_highest_bit_to_int(int domain) {
##     int result = 0;
##     for (; domain; domain >>= 1) {
##         result++;
##     }
##     return result;
## }

.globl convert_highest_bit_to_int
convert_highest_bit_to_int:
    move  $v0, $0             # result = 0

chbti_loop:
    beq   $a0, $0, chbti_end
    add   $v0, $v0, 1         # result ++
    sra   $a0, $a0, 1         # domain >>= 1
    j     chbti_loop

chbti_end:

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
    jr    $ra

.globl is_single_value_domain
is_single_value_domain:
    beq    $a0, $0, isvd_zero     # return 0 if domain == 0
    sub    $t0, $a0, 1	          # (domain - 1)
    and    $t0, $t0, $a0          # (domain & (domain - 1))
    bne    $t0, $0, isvd_zero     # return 0 if (domain & (domain - 1)) != 0
    li     $v0, 1

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
    jr	   $ra

isvd_zero:	   
    li	   $v0, 0

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
    jr	   $ra
    
.globl get_domain_for_addition
get_domain_for_addition:
    sub    $sp, $sp, 20
    sw     $ra, 0($sp)
    sw     $s0, 4($sp)
    sw     $s1, 8($sp)
    sw     $s2, 12($sp)
    sw     $s3, 16($sp)
    move   $s0, $a0                     # s0 = target
    move   $s1, $a1                     # s1 = num_cell
    move   $s2, $a2                     # s2 = domain

    move   $a0, $a2
    jal    convert_highest_bit_to_int
    move   $s3, $v0                     # s3 = upper_bound

    sub    $a0, $0, $s2                 # -domain
    and    $a0, $a0, $s2                # domain & (-domain)
    jal    convert_highest_bit_to_int   # v0 = lower_bound
       
    sub    $t0, $s1, 1                  # num_cell - 1
    mul    $t0, $t0, $v0                # (num_cell - 1) * lower_bound
    sub    $t0, $s0, $t0                # t0 = high_bits
    bge    $t0, $s3, gdfa_skip1

    li     $t1, 1          
    sll    $t0, $t1, $t0                # 1 << high_bits
    sub    $t0, $t0, 1                  # (1 << high_bits) - 1
    and    $s2, $s2, $t0                # domain & ((1 << high_bits) - 1)

gdfa_skip1:    
    sub    $t0, $s1, 1                  # num_cell - 1
    mul    $t0, $t0, $s3                # (num_cell - 1) * upper_bound
    sub    $t0, $s0, $t0                # t0 = low_bits
    ble    $t0, $0, gdfa_skip2

    sub    $t0, $t0, 1                  # low_bits - 1
    sra    $s2, $s2, $t0                # domain >> (low_bits - 1)
    sll    $s2, $s2, $t0                # domain >> (low_bits - 1) << (low_bits - 1)

gdfa_skip2:    
    move   $v0, $s2                     # return domain
    lw     $ra, 0($sp)
    lw     $s0, 4($sp)
    lw     $s1, 8($sp)
    lw     $s2, 12($sp)
    lw     $s3, 16($sp)
    add    $sp, $sp, 20

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
    jr     $ra

.globl get_domain_for_subtraction
get_domain_for_subtraction:
    li     $t0, 1              
    li     $t1, 2
    mul    $t1, $t1, $a0            # target * 2
    sll    $t1, $t0, $t1            # 1 << (target * 2)
    or     $t0, $t0, $t1            # t0 = base_mask
    li     $t1, 0                   # t1 = mask

gdfs_loop:
    beq    $a2, $0, gdfs_loop_end   
    and    $t2, $a2, 1              # other_domain & 1
    beq    $t2, $0, gdfs_if_end
       
    sra    $t2, $t0, $a0            # base_mask >> target
    or     $t1, $t1, $t2            # mask |= (base_mask >> target)

gdfs_if_end:
    sll    $t0, $t0, 1              # base_mask <<= 1
    sra    $a2, $a2, 1              # other_domain >>= 1
    j      gdfs_loop

gdfs_loop_end:
    and    $v0, $a1, $t1            # domain & mask

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
    jr     $ra



.globl get_domain_for_cell
get_domain_for_cell:
    # save registers    
    sub $sp, $sp, 36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)

    li $t0, 0 # valid_domain
    lw $t1, 4($a1) # puzzle->grid (t1 free)
    sll $t2, $a0, 3 # position*8 (actual offset) (t2 free)
    add $t3, $t1, $t2 # &puzzle->grid[position]
    lw  $t4, 4($t3) # &puzzle->grid[position].cage
    lw  $t5, 0($t4) # puzzle->grid[posiition].cage->operation

    lw $t2, 4($t4) # puzzle->grid[position].cage->target

    move $s0, $t2   # remain_target = $s0  *!*!
    lw $s1, 8($t4) # remain_cell = $s1 = puzzle->grid[position].cage->num_cell
    lw $s2, 0($t3) # domain_union = $s2 = puzzle->grid[position].domain
    move $s3, $t4 # puzzle->grid[position].cage
    li $s4, 0   # i = 0
    move $s5, $t1 # $s5 = puzzle->grid
    move $s6, $a0 # $s6 = position
    # move $s7, $s2 # $s7 = puzzle->grid[position].domain

    bne $t5, 0, gdfc_check_else_if

    li $t1, 1
    sub $t2, $t2, $t1 # (puzzle->grid[position].cage->target-1)
    sll $v0, $t1, $t2 # valid_domain = 0x1 << (prev line comment)
    j gdfc_end # somewhere!!!!!!!!

gdfc_check_else_if:
    bne $t5, '+', gdfc_check_else

gdfc_else_if_loop:
    lw $t5, 8($s3) # puzzle->grid[position].cage->num_cell
    bge $s4, $t5, gdfc_for_end # branch if i >= puzzle->grid[position].cage->num_cell
    sll $t1, $s4, 2 # i*4
    lw $t6, 12($s3) # puzzle->grid[position].cage->positions
    add $t1, $t6, $t1 # &puzzle->grid[position].cage->positions[i]
    lw $t1, 0($t1) # pos = puzzle->grid[position].cage->positions[i]
    add $s4, $s4, 1 # i++

    sll $t2, $t1, 3 # pos * 8
    add $s7, $s5, $t2 # &puzzle->grid[pos]
    lw  $s7, 0($s7) # puzzle->grid[pos].domain

    beq $t1, $s6 gdfc_else_if_else # branch if pos == position

    

    move $a0, $s7 # $a0 = puzzle->grid[pos].domain
    jal is_single_value_domain
    bne $v0, 1 gdfc_else_if_else # branch if !is_single_value_domain()
    move $a0, $s7
    jal convert_highest_bit_to_int
    sub $s0, $s0, $v0 # remain_target -= convert_highest_bit_to_int
    addi $s1, $s1, -1 # remain_cell -= 1
    j gdfc_else_if_loop
gdfc_else_if_else:
    or $s2, $s2, $s7 # domain_union |= puzzle->grid[pos].domain
    j gdfc_else_if_loop

gdfc_for_end:
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal get_domain_for_addition # $v0 = valid_domain = get_domain_for_addition()
    j gdfc_end

gdfc_check_else:
    lw $t3, 12($s3) # puzzle->grid[position].cage->positions
    lw $t0, 0($t3) # puzzle->grid[position].cage->positions[0]
    lw $t1, 4($t3) # puzzle->grid[position].cage->positions[1]
    xor $t0, $t0, $t1
    xor $t0, $t0, $s6 # other_pos = $t0 = $t0 ^ position
    lw $a0, 4($s3) # puzzle->grid[position].cage->target

    sll $t2, $s6, 3 # position * 8
    add $a1, $s5, $t2 # &puzzle->grid[position]
    lw  $a1, 0($a1) # puzzle->grid[position].domain
    # move $a1, $s7 

    sll $t1, $t0, 3 # other_pos*8 (actual offset)
    add $t3, $s5, $t1 # &puzzle->grid[other_pos]
    lw $a2, 0($t3)  # puzzle->grid[other_pos].domian

    jal get_domain_for_subtraction # $v0 = valid_domain = get_domain_for_subtraction()
    # j gdfc_end
gdfc_end:
# restore registers
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    add $sp, $sp, 36    

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
    jr $ra


.globl clone
clone:

    lw  $t0, 0($a0)
    sw  $t0, 0($a1)

    mul $t0, $t0, $t0
    mul $t0, $t0, 2 # two words in one grid

    lw  $t1, 4($a0) # &puzzle(ori).grid
    lw  $t2, 4($a1) # &puzzle(clone).grid

    li  $t3, 0 # i = 0;
clone_for_loop:
    bge  $t3, $t0, clone_for_loop_end
    sll $t4, $t3, 2 # i * 4
    add $t5, $t1, $t4 # puzzle(ori).grid ith word
    lw   $t6, 0($t5)

    add $t5, $t2, $t4 # puzzle(clone).grid ith word
    sw   $t6, 0($t5)
    
    addi $t3, $t3, 1 # i++
    
    j    clone_for_loop
clone_for_loop_end:

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
    jr  $ra

