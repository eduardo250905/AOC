.data
str1: .asciiz "Digite a string: \n"
str2: .asciiz "String concatenada com invertida: "
str3: .asciiz "A String eh um palindromo\n"
str4: .asciiz "A String nao eh um palindromo\n"
str5: .asciiz "Quantidade de substrings palindromos eh: "
quebra: .asciiz "\n"
string: .space 128
string_sem_espaco: .space 128
string_invertida: .space 128
string_concatenada: .space 256
 
.text
.globl main
 
main:
    li $v0, 4
    la $a0, str1
    syscall                         #imprime str1
 
    li $v0, 8
    la $a0, string
    li $a1, 128
    syscall                         # le a string
 
    move $s0, $a0                   # s0 = string original
    la $t0, string                
    la $t1, string_sem_espaco      
    move $s1, $t1                   # s1 = string sem espaco
    li $t2, 0
 
quant_caracteres:
    lb $t3, 0($t0)
    beqz $t3, fim_loop_quant_caracteres
    beq $t3, 32, pula_caractere     # caso caractere for espaco, pula
    sb $t3, 0($t1)                  # adiciona caractere em t1
    addi $t1, $t1, 1
    addi $t2, $t2, 1
 
pula_caractere:
    addi $t0, $t0, 1
    j quant_caracteres
 
fim_loop_quant_caracteres:
    move $s2, $t2                   # s2 = quantidade caracteres string
    move $t1, $s1
    add $t3, $t1, $s2
    addi $t3, $t3, -1
    move $s3, $t3                   # s3 = ultimo caractere string
 
verifica_palindromo_string:
    bge $t1, $t3, palindromo_string
    lb $t4, 0($t1)
    lb $t5, 0($t3)
    bne $t4, $t5, nao_palindromo_string
    addi $t1, $t1, 1
    addi $t3, $t3, -1
    j verifica_palindromo_string
 
nao_palindromo_string:
    li $v0, 4
    la $a0, str4
    syscall
    j fim_verifica_palindromo_string
 
palindromo_string:
    li $v0, 4
    la $a0, str3
    syscall
    j fim_verifica_palindromo_string
 
fim_verifica_palindromo_string:
    li $t0, 3                       # t0 = numero de caracteres de cada substring
    addi $t1, $s2, -1               # t1 = numero maximo de caracteres da substring
    li $t6, 0                       # t6 = numero de substrings palindromas
 
reseta_valores_substring:
    bgt $t0, $t1, quantidade_palindromo_substring
    move $t2, $s1
    add $t3, $t2, $t0
    addi $t3, $t3, -1
    move $t7, $t2
    move $t8, $t3
 
verifica_palindromo_substring:
    bge $t2, $t3, palindromo_substring
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    bne $t4, $t5, seleciona_substring
    addi $t2, $t2, 1
    addi $t3, $t3, -1
    j verifica_palindromo_substring
 
palindromo_substring:
    addi $t6, $t6, 1
 
seleciona_substring:
    addi $t2, $t7, 1
    addi $t3, $t8, 1
    addi $t7, $t7, 1
    addi $t8, $t8, 1
    bgt $t3, $s3, atualiza_tamanho_substring
    j verifica_palindromo_substring
 
atualiza_tamanho_substring:
    addi $t0, $t0, 1
    j reseta_valores_substring
 
quantidade_palindromo_substring:
    li $v0, 4
    la $a0, str5
    syscall
 
    li $v0, 1
    move $a0, $t6
    syscall
 
fim_quantidade_palindromo_substring:
    la $t0, string
    move $t5, $t0
    la $t4, string_invertida
    move $s4, $t4
 
percorrer_string:
    lb $t3, 0($t0)
    beqz $t3, inverter_string
    addi $t0, $t0, 1
    j percorrer_string
 
inverter_string:
    addi $t0, $t0, -1
    bgt $t5, $t0, fim_inverter_string
    lb $t3, 0($t0)
    sb $t3, 0($t4)
    addi $t4, $t4, 1
    j inverter_string
 
fim_inverter_string:
    la $t0, string
    la $t1, string_invertida
    la $t2, string_concatenada
 
copiar_string:                      # copia os elementos de string para string concatenada
    lb $t3, 0($t0)
    beqz $t3, copiar_string_invertida
    sb $t3, 0($t2)
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    j copiar_string
 
copiar_string_invertida:
    lb $t3, 0($t1)
    beqz $t3, imprimir_concatenada
    sb $t3, 0($t2)
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    j copiar_string_invertida
 
imprimir_concatenada:
    li $v0, 4
    la $a0, quebra
    syscall
 
    li $v0, 4
    la $a0, str2
    syscall
 
    li $v0, 4
    la $a0, string_concatenada
    syscall
 
end:
    li $v0, 10
    syscall
