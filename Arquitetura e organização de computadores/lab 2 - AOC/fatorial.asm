.text
main:
  li      $v0, 5          
  syscall                  
  move    $t0, $v0       
  move    $a0, $t0            
  sw      $t0, 0($sp)      
  sw      $ra, 8($sp) 
  jal     fatorial        
  lw      $s0, 4($sp)                           
  move    $a0, $s0        
  li      $v0, 1           
  syscall                   
  li      $v0, 10          
 syscall                 
fatorial:
  lw      $t0, 0($sp)      
  beq     $t0, 0, retornaUm 
  addi    $t0, $t0, -1     
  addi    $sp, $sp, -12     
  sw      $t0, 0($sp)      
  sw      $ra, 8($sp)       
  jal     fatorial          
  lw      $ra, 8($sp)       
  lw      $t1, 4($sp)      
  lw      $t2, 12($sp)    
  mul     $t3, $t1, $t2  
  sw      $t3, 16($sp)      
  addi    $sp, $sp, 12     
  jr      $ra    
retornaUm:
  li      $t0, 1            
  sw      $t0, 4($sp)       
  jr $ra            
