.data
   n0:.asciiz "zero"
   n1:.asciiz "um"
   n2:.asciiz "dois"
   n3:.asciiz "tres"
   n4:.asciiz "quatro"
   n5:.asciiz "cinco"
   n6:.asciiz "seis"
   n7:.asciiz "sete"
   n8:.asciiz "oito"
   n9:.asciiz "nove"
   n10:.asciiz "dez"
.text
    li $v0,5
    syscall
    add $t0,$t0,$v0
    beq $t0,0,zero
    beq $t0,1,um
    beq $t0,2,dois
    beq $t0,3,tres
    beq $t0,4,quatro
    beq $t0,5,cinco
    beq $t0,6,seis
    beq $t0,7,sete
    beq $t0,8,oito
    beq $t0,9,nove
    beq $t0,10,dez
    j exit
zero:
  li $v0,4
  la $a0,n0
  syscall
  j exit
um:
  li $v0,4
  la $a0,n1
  syscall
  j exit
dois:
  li $v0,4
  la $a0,n2
  syscall
  j exit
tres:
   li $v0,4
   la $a0,n3
   syscall
   j exit
quatro:
   li $v0,4
  la $a0,n4
  syscall
  j exit
cinco:
   li $v0,4
   la $a0,n5
   syscall
   j exit
seis:
  li $v0,4
  la $a0,n6
  syscall
  j exit
sete:
  li $v0,4
  la $a0,n7
  syscall
  j exit
oito:
   li $v0,4
  la $a0,n8
  syscall
  j exit
nove:
  li $v0,4
  la $a0,n9
  syscall
  j exit
dez:  
  li $v0,4
  la $a0,n10
  syscall          
exit:                                    