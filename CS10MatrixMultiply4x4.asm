# David Gudeman
# CS10
# Lab four

.data
Instructions: .asciiz "Type in integers followed by a space\n"
EnterRowA: .asciiz "\nArray a - Enter row  "
EnterRowB: .asciiz "\nArray b - Enter row  "
EmptyLine: .asciiz "\n"
PrintRow: .asciiz "Row "
Colon: .asciiz ": "
Dash: .asciiz "- "
Space: .asciiz " "

listsz: .word 33 # using as array of integers
answer: .space 200
answersz: .word 17
subMatrixCount: .word 5 #counts the number of submatrices

.text
#####################get some memory to catch strings#####
la $t4, 120($sp) # set address to catch STRING in $t4
la $s4, 120($sp) # save address of STRING for LoopB
########################Print out instructions ############
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, Instructions
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, EmptyLine
syscall
########################Input String Text for array a ############
addi $t6, $zero, 1 # set enterString counter to 0
enterStringA: #Enter string numbers
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, EnterRowA
syscall
li $v0, 1    # service number PRINT INTEGER
move $a0, $t6 #load the value of the counter to print row number
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, Colon
syscall
la $a0, ($t4)
li $a1, 9    # ok to load 9 characters
li $v0, 8    # service number READ STRING
syscall      # read value goes into $t4

addi $t6, $t6, 1 # increment loop counter by one
addi $t4, $t4, 8 # move 8 spaces in the memory to catch next string of 4 char
ble $t6, 4, enterStringA # ends loop at number of rows to be entered
########################Print an Empty Line #######################
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, EmptyLine
syscall
########################Input String Text for array b ##############
li $t6, 1 # reset the counter to collect array B
enterStringB: #Enter string numbers
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, EnterRowB
syscall
li $v0, 1    # service number PRINT INTEGER
move $a0, $t6 #load the value of the counter to print row number
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, Colon
syscall
la $a0, ($t4)
li $a1, 9    # ok to load 9 characters
li $v0, 8    # service number READ STRING
syscall      # read value goes into $t4
addi $t6, $t6, 1 # increment loop counter by one
addi $t4, $t4, 8 # move 8 spaces in the memory to catch next string of 4 char
ble $t6, 4, enterStringB # ends loop at number of rows to be entered
############convert char to integers and put in new array#########
lw $s0, listsz   # $s0 = array dimension
sub $sp, $sp, 32 #make room on stack for 32 words
la $s1 ($sp)     #load base address of the array in $s1
li $t0, 0        # $t0 = # elems init'd

convertSringToInteger:beq $t0, $s0, doneConvert
lb $s3, ($s4) # store byte from $s4 into $s3
sub $s3, $s3, 0x30 # subtract 0x30 from character to convert to integer
sb $s3, ($s1) # store byte from $s3 to $s1
addi $s1, $s1, 4 # step to next array cell
addi $t0, $t0, 1 # count elem just init'd
addi $s4, $s4, 2 #increment the characters
b convertSringToInteger

doneConvert:
################Table of registers for the loop counters###############
#$t0 holds b array value
#$t1 holds i counter - a array row
#$t2 holds j counter - a array column
#$t3 holds k counter - b array row
#$t4 holds l counter - b array column
#$t5 holds calulations for b array
#$t6 holds value for b cell
#$t7 holds calculations for a array
#$t8 holds value for a cell and catches a value to add
#$t9 holds a array value and final calulation

#$s1 holds i calulcations a row
#$s2 holds j calculations a column
#$s3 holds k calculations b row
#$s4 holds l calculations b columns
#$s5 holds address for start of b array CONSTANT
#$s6 holds address for b array element
#$s7 holds address for a array element

#$a2 hold counter for the answer which incrments by 4
#$a3 holds address for the answer
##################initialize values for the loops###################
li $s0, 0 # sets the submatrix counter to zero
la $a3 1028($sp)#a3 will be the base address of answer array 
subMatrixLoop:
#addi $a3, $a3, 16 # moves answer matrix 16 more spaces
li $t1, 0x00 # i counter
li $t2, 0x00 # j counter
li $t3, 0x00 # k counter
li $t4, 0x00 # l counter
li $a2, 0x00 # ANSWER COUNTER
li $t7, 0x00 # m start the loop counter to calculate the answer array
li $t8, 0x00 # j counter for columns of Array One
li $t9, 0x00 # k counter for rows of Array Two
###########set base addresses for arrays to calculate and catch answer###
la $s5, 64($sp) # array b: add 64 to sp get to start of array b CONSTANT

###########start loops##################################################
i_loop:
li $t4, 0x00 # l counter

l_loop:
li $t2, 0x00 # j counter
li $t3, 0x00 # k counter

k_loop:
#set up b array
mul $s4, $t4, 4   # array b: l * 4 caclulates the b column
mul $s3, $t3, 16  # array b: k * 16 calculates the b row
add $t5, $s3, $s4 # array b: adds (4*l) + (16*k)
add $s6, $s5, $t5 # array b:  add offset $t5 to base of b array $s5 yields b cell address
lw $t6, ($s6)     # array b: operand for b loaded in $t6
#set up array
mul $s1, $t1, 16  # array a: i * 16 calculates a row
mul $s2, $t2, 4   # array a: j * 4 calculates the a column
add $t7, $s1, $s2 # array a: (i * 16)+(j*4) yeilds offset
add $s7, $sp, $t7 # array a: this adjusts the address to fetch
#calculate
lw $t0, 0($s6)	  # array b: load operand
lw $t9, ($s7)     # array a: load operand 
mul $t9, $t0, $t9 # a * b sore in $t9
lw $t8 ($a3)      # array ANSWER - pull word out to add from the answer field
add $t8, $t9, $t8 # c + ab -
sw $t8, ($a3)     # array ANSWER store back in answer field
#increment counters
addi $a2, $a2, 1  # ANSWER: increment counter 
addi $t2, $t2, 1  # array a: increment j
addi $t3, $t3, 1  # array b: increment k
blt $t3, 4, k_loop
#increment counters
addi $a3, $a3, 4  #increments the address for the answer every 4
addi $t4, $t4, 1  # array b: $t4 is l, column counter for b
blt $t4, 4, l_loop
#increment counter
addi $t1, $t1, 1  # array a: $t1 is i, row counter for a
blt $t1, 4, i_loop
addi $s0, $s0, 1 # loops the submatrix
blt $s0, 4, subMatrixLoop # finishes the bubmatrix iterations



####################Print out ANSWER array################################

li $t0, 0 #$t0 counter of the a matrix
li $t1, 0 #$t1 holds the calculated offset for the a matrix
li $t2, 0 #$t2 holds current address for a matrix
li $t3, 0 #$t3 holds the a matrix address to be printed
li $t4, 0 #$t4 holds the offset for b matrix
li $t5, 0 #$t5 
li $t6, 0 #$t6
li $t7, 0 #$t7 array counter 
li $t8, 0 #$t8 initialize a counter for the OuterLoop

li $s0, 0 # #s0 holds the base address for a array
li $s1, 64 # $s1 holds offset address for b array
li $s2, 192 # #s2 holds offset base address for c array
li $s3, 256 # #s3 holds the base address for d array
la $s4 1028($sp) #s4 holds the base address for ANSWER array a
la $s5 1092($sp) #s5 holds the base address for ANSWER array b
la $s6 1220($sp) #s6 holds the base address for ANSWER array a
la $s7 1284($sp) #s7 holds the base address for ANSWER array b

PrintAnswerMatrix:
li $t0, 0 # zero out a matrix counter
addi $a0, $0, 0xA #ascii code for Line Feed
addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
syscall
aRowAnswerPrint:
mul $t1, $t5, 16  # $t1 calculates the row offset of a matrix
li $t0, 0         # resets $t0 inner counter
FirstHalfRowPrint: 
mul $t2, $t0, 4   # calculates the word offset of a matrix
add $t6, $t2, $t1 # (word offset + row offset) of a matrix
add $t2, $t6, $s4 # loads address of a matrix integer to be printed
lw $t3, 0($t2)    # loads the a matrix integer value to be printed
li $v0, 1 # service number PRINT INTEGER
move $a0, $t3 #load the value $t3 (INTEGER) into $a0 for syscall
syscall
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, Space # load address of Space into $a0
syscall
addi $t0, $t0, 1 # increment counter for InnerLoopOutPut
ble $t0, 3, FirstHalfRowPrint # break out of inner loop at 4
###############################################Second Half Row Print######################################
li $t0, 0 #reset subMatrix innerLoop counter
SecondHalfRowPrint: 
mul $t2, $t0, 4   # calculates the word offset of a matrix
add $t6, $t2, $t1 # (word offset + row offset) of a matrix

add $t2, $t6, $s5 # loads address of a matrix integer to be printed
lw $t3, 0($t2)    # loads the a matrix integer value to be printed
li $v0, 1 # service number PRINT INTEGER
move $a0, $t3 #load the value $t3 (INTEGER) into $a0 for syscall
syscall
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, Space # load address of Space into $a0
syscall
addi $t0, $t0, 1 # increment counter for InnerLoopOutPut
ble $t0, 3, SecondHalfRowPrint # break out of inner loop at 4
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, EmptyLine # load address of Space into $a0
syscall
addi $t5, $t5, 1
ble $t5, 3, aRowAnswerPrint # break out after printing a

################################################## c and d matrices Printout

li $t0, 0 #$t0 counter of the a matrix
li $t1, 0 #$t1 holds the calculated offset for the a matrix
li $t2, 0 #$t2 holds current address for a matrix
li $t3, 0 #$t3 holds the a matrix address to be printed
li $t4, 0 #$t4 holds the offset for b matrix
li $t5, 0 #$t5 
li $t6, 0 #$t6
li $t7, 0 #$t7 array counter 
li $t8, 0 #$t8 initialize a counter for the OuterLoop

li $s0, 0 # #s0 holds the base address for a array
li $s1, 64 # $s1 holds offset address for b array
li $s2, 192 # #s2 holds offset base address for c array
li $s3, 256 # #s3 holds the base address for d array
la $s4 1028($sp) #s4 holds the base address for ANSWER array a
la $s5 1092($sp) #s5 holds the base address for ANSWER array b
la $s6 1156($sp) #s6 holds the base address for ANSWER array a
la $s7 1220($sp) #s7 holds the base address for ANSWER array b

#PrintAnswerMatrix:
li $t0, 0 # zero out a matrix counter
addi $a0, $0, 0xA #ascii code for Line Feed
addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
syscall
cRowAnswerPrint:
mul $t1, $t5, 16  # $t1 calculates the row offset of a matrix
li $t0, 0         # resets $t0 inner counter
ThirdHalfRowPrint: 
mul $t2, $t0, 4   # calculates the word offset of a matrix
add $t6, $t2, $t1 # (word offset + row offset) of a matrix
add $t2, $t6, $s6 # loads address of a matrix integer to be printed
lw $t3, 0($t2)    # loads the a matrix integer value to be printed
li $v0, 1 # service number PRINT INTEGER
move $a0, $t3 #load the value $t3 (INTEGER) into $a0 for syscall
syscall
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, Space # load address of Space into $a0
syscall
addi $t0, $t0, 1 # increment counter for InnerLoopOutPut
ble $t0, 3, ThirdHalfRowPrint # break out of inner loop at 4
###############################################Second Half Row Print######################################
li $t0, 0 #reset subMatrix innerLoop counter
FourthHalfRowPrint: 
mul $t2, $t0, 4   # calculates the word offset of a matrix
add $t6, $t2, $t1 # (word offset + row offset) of a matrix

add $t2, $t6, $s7 # loads address of a matrix integer to be printed
lw $t3, 0($t2)    # loads the a matrix integer value to be printed
li $v0, 1 # service number PRINT INTEGER
move $a0, $t3 #load the value $t3 (INTEGER) into $a0 for syscall
syscall
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, Space # load address of Space into $a0
syscall
addi $t0, $t0, 1 # increment counter for InnerLoopOutPut
ble $t0, 3, FourthHalfRowPrint # break out of inner loop at 4
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, EmptyLine # load address of Space into $a0
syscall
addi $t5, $t5, 1
ble $t5, 3, cRowAnswerPrint # break out after printing a



li $v0, 10
syscall 
