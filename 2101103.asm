.text
  lw $t0,0($a1)
  lw $t1,4($a1)
  lw $t2,8($a1)
  
  lb $s0,0($t0)
  lb $s1,0($t1)
  lb $s2,0($t2)
 
 addi $s0,$s0,-48
 addi $s1,$s1,-48
 addi $s2,$s2,-48
   main:
   add $s3,$zero,$zero  #$s3 = x_0
   add $s4,$zero,$zero #$s4(i)=0
   
   loop: slt $s5,$s4,$s2 #( if i<n) $s4 = i , $s2 =n
         beq $s5,$zero,exit #$t4 comparision result  
         add $a0,$s3,$zero # $a0 = x_0 
         add $a1,$s0,$zero # $a1 = y_0
         add $a2,$s1,$zero # $a2 = h
         jal euler_fn
         add $s6,$v1,$zero #y_1 = returns of euler fun
         add $s0,$s6,$zero
         add $s3,$s3,$s1
         addi $s4,$s4,1
         add $v0,$v1,$zero
         lui $t9,4097
         sw $v0,0($t9)
         j loop
  
   
      euler_fn:
      addi $sp,$sp,-12
      sw $ra,0($sp)
      sw $a1,4($sp)
      sw $a2,8($sp)
      add $a2,$zero,$zero
      jal prime_fun
      add $a0,$zero,$v1 #$v1 = prime_fun return
      lw $a1,8($sp) # h=$a1
      jal mull
      lw $a1,4($sp) #$a1 =y_0
      add $v1,$v1,$a1 # $v1=y_0 + H* prime_fun
      lw $ra,0($sp)
      addi $sp,$sp,12
      jr $ra
      
      prime_fun:
      addi $sp,$sp,-8
      sw $a1,4($sp)
      sw $ra,0($sp)
      addi $a1,$zero,48
      jal mull 
      add $a1,$v1,$zero
      jal mull
      add $t0,$v1,$zero #$t0 = 48*(X_0)^2
      addi $a1,$zero,-26
      jal mull
      add $t1,$zero,$v1 #$t1 = - 26 * X_0
      lw $a0 ,4($sp)
      addi $a1,$zero,-712
      jal mull
      add $a1,$v1,$zero 
      jal mull
      add $a1,$v1,$zero
      jal mull
      add $t2,$zero,$v1 # $t2 = -712* (Y_0)^3
      addi $a1,$zero,61
      jal mull
      add $a1,$v1,$zero
      jal mull
      add $t3,$v1,$zero # $t3 = 61*(Y_0)^2
      addi $a1,$zero,26
      jal mull
      addi $v1,$v1,87 # $v1 = (26*Y_0)+87
      add $v1,$v1,$t3 # $v1 = (61*(Y_0)^2)+(26*Y_0)+87
      add $v1,$v1,$t2 # $v1 = -(712* (Y_0)^3)+(61*(Y_0)^2)+(26*Y_0)+87
      add $v1,$v1,$t1 # $v1 =  -(26 * X_0)-(712* (Y_0)^3)+(61*(Y_0)^2)+(26*Y_0)+87
      add $v1,$v1,$t0 # $v1 = (48*(X_0)^2) - (26 * X_0)-(712* (Y_0)^3)+(61*(Y_0)^2)+(26*Y_0)+87
      lw $ra,0($sp)
      addi $sp,$sp,8
      jr $ra
  
  mull:
  add $v1,$zero,$zero
  beq $a0,$zero,end_mull
  beq $a1,$zero,end_mull
  slt $t5,$a1,$zero
  bne $t5,$zero,nega
  loop_pos:
  beq $a1,$zero,end_mull
  add $v1,$v1,$a0
  add $a1,$a1,-1
  j loop_pos
  
  nega:
   nor $a0,$a0,$zero
   addi $a0,$a0,1
  loop_nega:
  beq $a1,$zero,reset
  add $v1,$v1,$a0
  add $a1,$a1,1
  j loop_nega
  reset:
   nor $a0,$a0,$zero
   addi $a0,$a0,1
  end_mull:
  jr $ra
  exit:
