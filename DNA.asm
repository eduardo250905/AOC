.data
str1: .asciiz "Digite a fita simples: \n"
str2: .asciiz "Cadeia de caracteres invalida! \n"
str3: .asciiz "Nao eh possivel comecar a traduzir ! \n"
str4: .asciiz "Traducao incompleta!"
buffer: .space 100
.text
.globl main

main:
    li $v0, 4
    la $a0, str1
    syscall
    
    li $v0, 8
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0                               # s0 = fita digitada pelo usuario
    li $t0, 0

verifica_caracter_invalido:
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    beqz $t2, verifica_inicio
    addi $t0, $t0, 1
    beq $t2, 65, verifica_caracter_invalido
    beq $t2, 67, verifica_caracter_invalido
    beq $t2, 71, verifica_caracter_invalido
    beq $t2, 84, verifica_caracter_invalido
    j erro_caracter_invalido

verifica_inicio:                                # Verifica se string comeca com TAC
    li $t0, 0
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    bne $t2, 84, erro_inicio                    # Verifica se o primeiro caractere eh T
    addi $t0, $t0, 1
    add $t1, $t0, $s0
    lb $t2, 0($t1)
    bne $t2, 65, erro_inicio                    # Verifica se o segundo caractere eh A
    addi $t0, $t0, 1
    add $t1, $t0, $s0
    lb $t2, 0($t1)
    bne $t2, 67, erro_inicio                    # Verifica se o terceiro caractere eh C

procura_final:                                  # Verifica se string apresenta ATT, ATC ou ACT.
    addi $t0, $t0, 1
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    beqz $t2, erro_final
    beq $t2, 67, procura_final
    beq $t2, 71, procura_final
    beq $t2, 84, procura_final
    addi $t0, $t0, 1
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    beqz $t2, erro_final
    beq $t2, 65, procura_final
    beq $t2, 71, procura_final
    beq $t2, 84, segundo_caracter_T
    beq $t2, 67, segundo_caracter_C
    
    segundo_caracter_T:
        addi $t0, $t0, 1
        add $t1, $s0, $t0
        lb $t2, 0($t1)
        beqz $t2, erro_final
        beq $t2, 65, procura_final
        beq $t2, 71, procura_final
        beq $t2, 67, fim_verificacao
        beq $t2, 84, fim_verificacao
        
    segundo_caracter_C:
        addi $t0, $t0, 1
        add $t1, $s0, $t0
        lb $t2, 0($t1)
        beqz $t2, erro_final
        beq $t2, 65, procura_final
        beq $t2, 67, procura_final
        beq $t2, 71, procura_final
        beq $t2, 84, fim_verificacao

fim_verificacao:
    move $s1, $t0                               # s1 = tamanho da fita valida
    li $t0, 0
    li $t3, 0
  
imprime_traducao:
    bgt $t0, $s1, exit
    beq $t3, 3, imprimir_espaco
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    addi $t0, $t0, 1
    addi $t3, $t3, 1
    beq $t2, 65, imprimir_U
    beq $t2, 67, imprimir_G
    beq $t2, 71, imprimir_C
    beq $t2, 84, imprimir_A
    
    imprimir_espaco:
        li $t3, 0
        li $v0, 11
        li $a0, 32
        syscall
        j imprime_traducao
        
    imprimir_U:
        li $v0, 11
        li $a0, 85
        syscall
        j imprime_traducao
    
    imprimir_G:
        li $v0, 11
        li $a0, 71
        syscall
        j imprime_traducao
    
    imprimir_C:
        li $v0, 11
        li $a0, 67
        syscall
        j imprime_traducao
    
    imprimir_A:
        li $v0, 11
        li $a0, 65
        syscall
        j imprime_traducao

erro_inicio:
    li $v0, 4
    la $a0, str3
    syscall
    j exit

erro_caracter_invalido:
    li $v0, 4
    la $a0, str2
    syscall
    j exit

erro_final:
    li $v0, 4
    la $a0, str4
    syscall
    j exit

exit:
    li $v0, 10
    syscall