.include "musica.asm"
.data
 .align 0
 .text
   li $a1,1000
   li $a2,24
   li $a3,127
   la $s1,musica
loop:
  lb $a0,0($s1)
  li $v0,31
  syscall
  li $v0,32
  li $a0,300
  syscall
  addi $s1,$s1,1
  addi $t0,$zero,-1
  lb $s3,0($s1)
  beq $s3,$t0,exit 
  j loop
exit:  
   syscall     
   
  
