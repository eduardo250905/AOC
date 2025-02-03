.data
numero1: .float 10.0
str1: .asciiz "Digite a quantidade de valores: \n"
str2: .asciiz "Media da amostra: "
str3: .asciiz "\nMediana da amostra: "
str4: .asciiz "\nAmostra amodal!"
str5: .asciiz "\nModas da amostra: "
str6: .asciiz "\nModa da amostra: "
ponto: .asciiz "."
espaco: .asciiz " "

.text
.globl main

main:
    # Pedir o tamanho da lista (n)
    li $v0, 4                           
    la $a0, str1                   
    syscall

    li $v0, 5                           
    syscall
    move $s0, $v0                           # $s0 = n (tamanho da lista)

    # Alocar memoria para a lista
    li $v0, 9                           
    mul $a0, $s0, 4                         # espaco necessario (n * 4 bytes por inteiro)
    syscall
    move $s1, $v0                           # $s1 = endereco base da lista

    # Ler os numeros do usuario
    li $t1, 0                               # contador i = 0
    
le_numeros:
    bge $t1, $s0, bubble_sort               # se i >= n, termina a leitura

    li $v0, 5                          
    syscall
    mul $t2, $t1, 4                     
    add $t3, $s1, $t2                       # endereco lista[i]
    sw $v0, 0($t3)                          # armazenar numero na lista
    addi $t1, $t1, 1                  
    j le_numeros                        

bubble_sort:
    li $t3, 0                               # resetar flag de troca
    li $t1, 0                               # contador externo (i)
    
loop_externo:
    sub $t4, $s0, $t1                       # tamanho restante (n - i)
    ble $t4, 1, inicio_soma                 # se tamanho restante <= 1, terminar

    li $t2, 0                               # contador interno (j)
    
loop_interno:
    add $t5, $t2, 1                         # j + 1
    bge $t5, $t4, fim_loop_externo          # se j + 1 >= n - i, terminar loop interno

    mul $t6, $t2, 4                         # deslocamento j * 4
    mul $t7, $t5, 4                         # deslocamento (j + 1) * 4

    add $a0, $s1, $t6                       # endereco lista[j]
    add $a1, $s1, $t7                       # endereco lista[j+1]

    lw $t8, 0($a0)                      
    lw $t9, 0($a1)                      
    ble $t8, $t9, no_swap                   # se lista[j] <= lista[j+1], nao trocar

    sw $t9, 0($a0)                          # lista[j] = lista[j+1]
    sw $t8, 0($a1)                          # lista[j+1] = lista[j]
    li $t3, 1                               # marcar que houve troca

no_swap:
    addi $t2, $t2, 1                  
    j loop_interno                        

fim_loop_externo:
    addi $t1, $t1, 1                   
    bne $t3, 0, bubble_sort                 # repetir se houve troca

inicio_soma:
    li $t1, 0                               # contador i = 0
    li $t3, 0                               # t3 = soma 
    
loop_soma:
    bge $t1, $s0, transformar_soma_real     # se i >= n, termina a impressao

    mul $t2, $t1, 4                         # deslocamento i * 4
    add $t4, $s1, $t2                       # endereco lista[i]
    lw $t4, 0($t4)                          # carregar lista[i]
    add $t3, $t3, $t4                       # soma += lista[i]

    addi $t1, $t1, 1                   
    j loop_soma                     

transformar_soma_real:
    # Transforma o resultado da soma em real
    mtc1 $t3, $f4              
    cvt.s.w $f4, $f4          

transformar_tamanho_real:
    # Transforma o tamanho em real
    mtc1 $s0, $f6              
    cvt.s.w $f6, $f6           

calcular_media:
    div.s $f2, $f4, $f6                     # f2 = soma / tamanho
    
imprimir_media:
    # Imprime a media com uma casa decimal
    li $v0, 4
    la $a0, str2
    syscall
    
    lwc1 $f0, numero1
    mul.s $f2, $f2, $f0
    cvt.w.s $f2, $f2
    mfc1 $t0, $f2
    
    li $t3, 10
    div $t0, $t3
    mfhi $t1
    mflo $t0
    
    li $v0, 1                  
    move $a0, $t0           
    syscall
    
    li $v0, 4
    la $a0, ponto
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall
    
verificar_par_impar:
    # Verifica se n eh par ou impar para mediana
    move $t0, $s0
    
    li $t1, 2
    div $t0, $t1
    mfhi $t2
    beq $t2, 0, mediana_par

mediana_impar:
    div $t0, $t0, $t1               
    mul $t0, $t0, 4
    add $t0, $t0, $s1                       
    
    lw $t0, 0($t0)                              # t0 = lista[n/2]
    
    li $v0, 4
    la $a0, str3
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    j aloca_lista_moda

mediana_par:
    div $t0, $t0, $t1
    addi $t2, $t0, -1
    mul $t0, $t0, 4
    mul $t2, $t2, 4
    add $t0, $t0, $s1
    add $t2, $t2, $s1
    
    lw $t0, 0($t0)                              # t0 = lista[n/2]
    lw $t2, 0($t2)                              # t2 = lista[n/2 + 1]
    add $t0, $t0, $t2
    div $t0, $t1
    
    mfhi $t2
    mflo $t0
    
    li $v0, 4
    la $a0, str3
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, ponto
    syscall
    
    beq $t2, 1, resto_um                                # caso a mediana nao seja exata, a casa decimal eh igual a 1
    
    li $v0, 1
    li $a0, 0
    syscall
    
    j aloca_lista_moda

resto_um:
    li $v0, 1
    li $a0, 5
    syscall

aloca_lista_moda:
    li $v0, 9
    mul $a0, $s0, 4
    syscall
    move $s2, $v0                                       # s2 = endereco base lista moda

inicio_calcula_moda:
    li $t0, 0                                           # t0 = tamanho da lista moda
    li $t1, 0                                           # t1 = contador(i)
    li $t2, 2                                           # menor numero de elementos para ser moda

reajusta_contador_elementos:
    li $t3, 1                                           # contador de elementos do numero atual    

calcula_moda:
    bge $t1, $s0, fim_calcula_moda
    mul $t5, $t1, 4
    add $t5, $t5, $s1                                   
    addi $t1, $t1, 1
    bgt $t1, $s0, fim_calcula_moda
    addi $t6, $t5, 4
    lw $t5, 0($t5)                                      # t5 = lista[i]
    lw $t6, 0($t6)                                      # t6 = lista[i+1]
    bne $t5, $t6, numeros_diferentes                    # se t5 != t6
    addi $t3, $t3, 1
    j calcula_moda
    
numeros_diferentes:
    blt $t3, $t2, reajusta_contador_elementos           # t5 nao eh moda
    beq $t3, $t2, adicionar_lista_moda                  # t5 eh a primeira moda encontrada ou compartilha a lista com outro numero
    li $t0, 0                                           # t5 eh a moda unica(limpa a moda antiga)
    move $t2, $t3
    j adicionar_lista_moda

adicionar_lista_moda:
    mul $t7, $t0, 4
    add $t7, $t7, $s2
    sw $t5, 0($t7)
    addi $t0, $t0, 1
    j reajusta_contador_elementos

fim_calcula_moda:
    li $t1, 0
    li $t2, 1
    beq $t0, $t1, sem_moda
    beq $t0, $t2, uma_moda
    li $v0, 4
    la $a0, str5
    syscall
    li $t1, 0
    j varias_modas
    
sem_moda:
    li $v0, 4
    la $a0, str4
    syscall
    j exit

uma_moda:
    li $v0, 4
    la $a0, str6
    syscall
    
    lw $t4, 0($s2)
    li $v0, 1
    move $a0, $t4
    syscall
    j exit
    
varias_modas:
    bge $t1, $t0, exit
    mul $t2, $t1, 4
    add $t2, $t2, $s2
    lw $t2, 0($t2)
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, espaco
    syscall
    
    addi $t1, $t1, 1
    j varias_modas

exit:
    li $v0, 10                 
    syscall