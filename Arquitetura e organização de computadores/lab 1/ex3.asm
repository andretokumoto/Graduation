.data

.text
   li $v0,5
   syscall
   move $t0,$v0#recebe a
   
   li $v0,5
   syscall
   move $t1,$v0#recebe m
   
   addi $t3,$t0,0#inicia divisor
   la $t4,1#contador de potencia
   j loop
   
loop:
    div $t3,$t1
    mfhi $t5
    beq $t5,1,imprime  
    mul $t3,$t3,$t0
    addi $t4,$t4,1
    j loop

imprime:
   li $v0,1
   move $a0,$t4
   syscall
   
  li $v0,10
  syscall   
   