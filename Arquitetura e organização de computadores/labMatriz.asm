.data
   m1: .asciiz "tamanho da matriz quadrada:\n"
   m2: .asciiz "Segunda matriz:\n"
   m3: .asciiz "Primeira matriz:\n"
   m4: .asciiz "Resultado:\n"

.align 4
matriz: .space 512
.align 4
matriz2: .space 512
.align 4
matriz3: .space 512
	

.text
 li $v0, 4
 la $a0, m1
 syscall

 li $v0, 5
syscall

move $t0, $v0	
move $t2, $v0		
mul $t0, $t0, $t0	
li $t1, 1	
li $v0, 4
la $a0, m3
syscall
	
loop:
		
#le valores da matriz 1

li $v0, 5	
syscall
		
sw $v0, matriz($s0)	
addi $s0, $s0, 4	
add $t1, $t1, 1
ble $t1, $t0, loop
		
li $t1, 1
li $s0, 0
li $v0, 4
la $a0, m2
syscall
		
loop2:
		
#le valores da matriz2	
li $v0, 5	
syscall
		
sw $v0, matriz2($s0)	
addi $s0, $s0, 4	
add $t1, $t1, 1
ble $t1,$t0, loop2			
li $t3, 0	
li $t4, 0
li $s0, 0
li $t1, 1
li $t8, 1
li $s5, 0
li $s2, 1
mul $t9, $t2, 4	
j loop_multi
	
multM:

li $s2, 1		
li $s1, 1
	
coluna:
sub $t4, $t4, $t9
subi $t4, $t4, 4			
addi $s1, $s1, 1
blt $s1, $t2, coluna
j loop_multi
		
linha:
sub $t3, $t3, $t9
addi $t4, $t4, 4		
li $s1, 1

coluna2:
sub $t4, $t4, $t9
addi $s1, $s1, 1
blt $s1, $t2, coluna2
	
loop_multi:
lw $t5, matriz($t3)	
lw $t6, matriz2($t4)	
mul $t7, $t5, $t6	
add $s5, $s5, $t7
add $t3, $t3, 4		
add $t4, $t4, $t9	
add $t8, $t8, 1
ble $t8, $t2, loop_multi		
sub $t4, $t4, $t9	
		
sw $s5, matriz3($s0)	
addi $s0, $s0, 4	
addi $t1, $t1, 1
addi $s2, $s2, 1
li $s5, 0
li $t8, 1
ble $s2, $t2, linha	
ble $t1, $t0, multM
	
#inprime result			
li $s0, 0
li $t1, 1
li $v0, 4
la $a0, m4
syscall
	
loop3:
lw $a0, matriz3($s0)		
li $v0, 1
syscall
		
li $v0, 11
li $a0, 10	
syscall
		
addi $s0, $s0, 4	
add $t1, $t1, 1
ble $t1, $t0, loop3
		
		
