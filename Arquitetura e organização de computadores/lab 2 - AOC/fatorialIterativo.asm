.text
  li      $v0, 5          
  syscall                  
  move    $t0, $v0
  addi $t1,$t0,0
loop:
  beq $t0,1,exit
  sub $t0,$t0,1
  mul $t1,$t1,$t0
  j loop   
 exit:
  li $v0,1
  move $a0,$t1
  syscall 