
.data

.text
      li $v0,5
      syscall
      move $t2,$v0
      addi $t3,$zero,0
      j loop

loop:
     beq $t3,$t2,exit
     addi $t3,$t3,1
     div $t1,$t2,$t3
     mfhi $t1
     beq $t1,0,a
     j loop
 a:     
      li,$v0,1   
      add $a0,$zero,$t3
      syscall 
      j loop
exit:     