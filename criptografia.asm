.data
str1: .asciiz "Digite o texto:\n"
str2: .asciiz "Digite a chave:\n"
msg_criptografada: .space 100
palavra_chave: .space 100
msg_criptografada_final: .space 100
.text
.globl main
 
main:
    li $v0, 4                           
    la $a0, str1                   
    syscall
 
    li $v0, 8
    la $a0, msg_criptografada
    li $a1, 100
    syscall
    
    move $s0, $a0                                   # Salva msg_criptografada em $s0
    la $s2, msg_criptografada_final                 # Salva endereco de msg_criptografada_final em $s2
    
    li $v0, 4
    la $a0, str2
    syscall
    
    li $v0, 8
    la $a0, palavra_chave
    li $a1, 100
    syscall
    
    move $s1, $a0                                   # Salva palavra_chave em $s1
    
    li $t0, -1
    li $t3, 0
    li $t5, 0
 
remove_caracteres_especiais:                        # insere em msg_criptografada_final apenas letras
    addi $t0, $t0, 1
    add $t1, $s0, $t0
    lb $t2, 0($t1)
    beqz $t2, transforma_chave_maiuscula
    blt $t2, 65, remove_caracteres_especiais
    bgt $t2, 122, remove_caracteres_especiais
    blt $t2, 91, adiciona_msg_criptografia_final
    bgt $t2, 96, adiciona_msg_criptografia_final
 
adiciona_msg_criptografia_final:
    add $t4, $t3, $s2
    sb $t2, 0($t4)
    addi $t3, $t3, 1
    j remove_caracteres_especiais
 
transforma_chave_maiuscula:                         # Transforma todos caracteres da palavra_chave em maiusculo
    add $t6, $s1, $t5
    lb $t7, 0($t6)
    beqz $t7, comeca_criptografia
    addi $t5, $t5, 1
    ble $t7, 90, transforma_chave_maiuscula
    sub $t7, $t7, 32
    sb $t7, 0($t6)
    j transforma_chave_maiuscula
 
comeca_criptografia:
    li $t0, 0                                       # indice msg_criptografada_final
    li $t1, 0                                       # indice palavra_chave
    li $s3, 26
 
loop_criptografia:
    add $t4, $t0, $s2
    add $t5, $t1, $s1
    lb $t6, 0($t4)
    beqz $t6, exit
    lb $t7, 0($t5)
    beqz $t7, recomecar_palavra_chave
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    sub $t7, $t7, 65
    ble $t6, 90, letra_maiuscula                    # Verifica se caractere em msg_criptografada_final eh maiusculo
    
    letra_minuscula:                                # Caso caractere for minusculo
        sub $t6, $t6, 97
        sub $t6, $t6, $t7
        addi $t6, $t6, 26
        div $t6, $s3
        mfhi $t6
        addi $t6, $t6, 97
        li $v0, 11
        move $a0, $t6
        syscall
        j loop_criptografia
    
    letra_maiuscula:                                # Caso caractere for maiusculo
        sub $t6, $t6, 65
        sub $t6, $t6, $t7
        addi $t6, $t6, 26
        div $t6, $s3
        mfhi $t6
        addi $t6, $t6, 65
        li $v0, 11
        move $a0, $t6
        syscall
        j loop_criptografia
 
recomecar_palavra_chave:
    li $t1, 0
    j loop_criptografia
 
exit:
    li $v0, 10
    syscall
