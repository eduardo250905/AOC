.data
str1:   .asciiz "Entre com o combustivel e a quantidade em litros: \n"
str2:   .asciiz "Foram comercializados R$ "
str3:   .asciiz " de gasolina, R$ "
str4:   .asciiz " de alcool e R$ "
str5:   .asciiz " de diesel.\n"
str6:   .asciiz "Entrada invalida!\n"
gas:    .asciiz "gasolina"
alc:    .asciiz "alcool"
die:    .asciiz "diesel"
buffer: .space  10
.text
.globl main
 
main:
    li $v0, 4
    la $a0, str1
    syscall
    
    li $v0, 5
    syscall
 
    move $s0, $v0 #s0 recebe numero de clientes
    li $t0, 0 #contador(t0) recebe 0
    li $s5, 0 #quantidade litros gasolina
    li $s6, 0 #quantidade litros alcool
    li $s7, 0 #quantidade litros diesel
 
while:
    bge $t0, $s0, end
    addi $t0, $t0, 1
    # le a string
    li $v0, 8
    la $a0, buffer
    li $a1, 10
    syscall
    li $t5, 2
    j compara
 
compara: # verifica a primeira letra
    la $s1, buffer
    la $s2, gas
    la $s3, alc
    la $s4, die
    move $t1, $s1
    move $t2, $s2
    move $t3, $s3
    move $t4, $s4
    lb $t1, ($s1)
    lb $t2, ($s2)
    beq $t1, $t2, gasolina
    lb $t3, ($s3)
    beq $t1, $t3, alcool
    lb $t4, ($s4)
    beq $t1, $t4, diesel
    j invalido
 
gasolina: # verifica se a palavra eh "gasolina"
    li, $t6, 8
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    lb $t1, ($s1)
    lb $t2, ($s2)
    bne $t1, $t2, invalido
    bge $t5, $t6, atualiza_gasolina
    addi $t5, $t5, 1
    j gasolina
 
alcool: # verifica se a palavra eh "alcool"
    li $t6, 6
    addi $s1, $s1, 1
    addi $s3, $s3, 1
    lb $t1, ($s1)
    lb $t3, ($s3)
    bne $t1, $t3, invalido
    bge $t5, $t6, atualiza_alcool
    addi $t5, $t5, 1
    j alcool
 
diesel: # verifica se a palavra eh "diesel"
    li $t6, 6
    addi $s1, $s1, 1
    addi $s4, $s4, 1
    lb $t1, ($s1)
    lb $t4, ($s4)
    bne $t1, $t4, invalido
    bge $t5, $t6, atualiza_diesel
    addi $t5, $t5, 1
    j diesel
 
atualiza_gasolina:
    li $v0, 5
    syscall
    add $s5, $s5, $v0
    j while
 
atualiza_alcool:
    li $v0, 5
    syscall
    add $s6, $s6, $v0
    j while
 
atualiza_diesel:
    li $v0, 5
    syscall
    add $s7, $s7, $v0
    j while
 
invalido:
    li $v0, 4
    la $a0, buffer
    li $v0, 4
    la $a0, str6
    syscall
 
end:
    li $t1, 4 # preco litro alcool
    li $t2, 5 # preco litro gasolina
    li $t3, 6 # preco litro diesel
    li $v0, 4
    la $a0, str2
    syscall
 
    mul $t4, $s5, $t2
    li $v0, 1
    move $a0, $t4
    syscall
 
    li $v0, 4
    la $a0, str3
    syscall

    mul $t4, $s6, $t1
    li $v0, 1
    move $a0, $t4
    syscall
 
    li $v0, 4
    la $a0, str4
    syscall
 
    mul $t4, $s7, $t3
    li $v0, 1
    move $a0, $t4
    syscall
 
    li $v0, 4
    la $a0, str5
    syscall
    li $v0, 10
    syscall
