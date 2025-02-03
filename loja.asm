.data
str1: .asciiz "Menu de opcoes:\n"
str2: .asciiz "Digite 1 para adicionar produto\n"
str3: .asciiz "Digite 2 para remover produto\n"
str4: .asciiz "Digite 3 para ordenar crescente\n"
str5: .asciiz "Digite 4 para ordenar decrecente\n"
str6: .asciiz "Digite 0 para sair"
str7: .asciiz "\nID invalido!"
str8: .asciiz "\nID: "
str9: .asciiz " e preco:R$ "
quebra: .asciiz "\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, str1
    syscall
    
    la $a0, str2
    syscall
    
    la $a0, str3
    syscall
    
    la $a0, str4
    syscall
    
    la $a0, str5
    syscall
    
    la $a0, str6
    syscall
    
    li $v0, 9
    li $a0, 80
    syscall
    move $s0, $v0                                       # s0 = endereco base da lista de IDs
    
    li $v0, 9
    li $a0, 80
    syscall
    move $s1, $v0                                       # s1 = endereco base da lista de precos
    li $t1, 0                                           # t1 = numero de elementos das listas

loop_escolhas:
    
    li $v0, 5
    syscall
    move $t0, $v0                                       # t0 = opcao escolhido pelo usuario
    
    beq $t0, 0, exit
    
    li $v0, 4
    la $a0, quebra
    syscall
    
    beq $t0, 1, adiciona_produto
    beq $t0, 2, remover_produto
    beq $t0, 3, bubble_sort
    beq $t0, 4, bubble_sort

adiciona_produto:
    li $v0, 5
    syscall
    move $t2, $v0                                       # ID
    li $t3, 0
    
    verificar_existencia:
        bgt $t3, $t1, adiciona_produto_preco
        mul $t4, $t3, 4
        add $t4, $t4, $s0
        lw $t4, 0($t4)
        beq $t2, $t4, ID_invalido
        addi $t3, $t3, 1
        j verificar_existencia
    
    adiciona_produto_preco:
        li $v0, 5
        syscall
        move $t3, $v0                                   # preco
    
    mul $t4, $t1, 4
    add $t5, $s0, $t4
    sw $t2, 0($t5)
    
    add $t5, $s1, $t4
    sw $t3, 0($t5)
    
    addi $t1, $t1, 1
    j imprimir_lista

remover_produto:
    li $v0, 5
    syscall
    move $t2, $v0                                       # t2 = ID produto a ser removido
    
    li $t3, 0
    procurar_ID:
        bgt $t3, $t1, ID_invalido
        mul $t4, $t3, 4
        add $t4, $t4, $s0
        lw $t5, 0($t4)
        addi $t3, $t3, 1
        bne $t2, $t5, procurar_ID
    addi $t3, $t3, -1
    mul $t6, $t3, 4
    add $t6, $t6, $s1
    addi $t1, $t1, -1
    reajustar_listas:
        bgt $t3, $t1, imprimir_lista
        addi $t5, $t4, 4
        addi $t7, $t6, 4
        lw $t5, 0($t5)
        lw $t7, 0($t7)
        sw $t5, 0($t4)
        sw $t7, 0($t6)
        addi $t3, $t3, 1
        addi $t4, $t4, 4
        addi $t6, $t6, 4
        j reajustar_listas

bubble_sort:
    li $t2, 0                                           # t2 = contador externo i
    li $t3, 0                                           # t3 = flag de troca

    loop_externo:
        sub $t4, $t1, $t2                               # tamanho restante(n-i)
        ble $t4, 1, imprimir_lista                      # se tamanho <= 1, terminar
        li $t5, 0                                       # contador interno j
        
    loop_interno:
        add $t6, $t5, 1
        bge $t6, $t4, fim_loop_interno
        
        mul $t7, $t5, 4
        mul $t8, $t6, 4
        
        add $a0, $s1, $t7                               # endereco lista_preco[j]
        add $a1, $s1, $t8                               # endereco lista_preco[j+1]
        
        lw $t7, 0($a0)                                  # t7 = lista_preco[j]
        lw $t8, 0($a1)                                  # t8 = lista_preco[j+1]
        beq $t0, 4, ordenar_decrescente
        
        ordenar_crescente:
            ble $t7, $t8, nao_troca                     # se lista_preco[j] <= lista_preco[j+1], nao troca
            j troca
        
        ordenar_decrescente:
            bge $t7, $t8, nao_troca                     # se lista_preco[j] >= lista_preco[j+1], nao troca
        
        troca:
            sw $t8, 0($a0)                              # lista_preco[j] = lista_preco[j+1]
            sw $t7, 0($a1)                              # lista_preco[j+1] = lista_preco[j]
            
            mul $t7, $t5, 4
            mul $t8, $t6, 4
            
            add $a0, $s0, $t7                           # endereco lista_ID[j]
            add $a1, $s0, $t8                           # endereco lista_iD[j+1]
            
            lw $t7, 0($a0)                              # t7 = lista_ID[j]
            lw $t8, 0($a1)                              # t8 = lista_ID[j+1]
            
            sw $t8, 0($a0)                              # lista_ID[j] = lista_ID[j+1]
            sw $t7, 0($a1)                              # lista_ID[j+1] = lista_ID[j]
            
            li $t3, 1
        
        nao_troca:
            add $t5, $t5, 1                         
            j loop_interno
        
    fim_loop_interno:
        addi $t2, $t2, 1
        bne $t3, 0, bubble_sort
        j imprimir_lista
        
ID_invalido:
    li $v0, 4
    la $a0, str7
    syscall
    
    j loop_escolhas

imprimir_lista:
    move $t2, $s0
    move $t3, $s1
    li $t4, 0
    loop_imprimir:
        bge $t4, $t1, loop_escolhas
        
        li $v0, 4
        la $a0, str8
        syscall
        
        li $v0, 1
        lw $t5, 0($t2)
        move $a0, $t5
        syscall
        
        li $v0, 4
        la $a0, str9
        syscall
        
        li $v0, 1
        lw $t5, 0($t3)
        move $a0, $t5
        syscall
        
        addi $t4, $t4, 1
        addi $t2, $t2, 4
        addi $t3, $t3, 4
        
        j loop_imprimir
    
exit:
    li $v0, 10
    syscall