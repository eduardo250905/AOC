.data
str1: .asciiz "Entre com o numero: \n"
str2: .asciiz "\nF("
str3: .asciiz "): "
space: .asciiz " "
.text
.globl main
 
main:
    li $v0, 4
    la $a0, str1
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
    li $t0, 1
    li $t1, 0
    li $t2, 1
    li $v0, 1
    move $a0, $t2
    syscall
  
while:
    bge $t0, $s0, resultado
    li $v0, 4
    la $a0, space
    syscall
    
    add $t3, $t1, $t2
    li $v0, 1
    move $a0, $t3
    syscall
    
    move $t1, $t2
    move $t2, $t3
    addi $t0, 1
    j while
    
resultado:
    li $v0, 4
    la $a0, str2
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, str3
    syscall
    
    li $v0, 1
    move $a0, $t3
    syscall
    
end:
    li $v0, 10
    syscall
