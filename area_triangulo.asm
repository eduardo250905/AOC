.data
str1: .asciiz "Entre com o coordenada x1 do ponto A: \n"
str2: .asciiz "Entre com o coordenada y1 do ponto A: \n"
str3: .asciiz "Entre com o coordenada x2 do ponto B: \n"
str4: .asciiz "Entre com o coordenada y2 do ponto B: \n"
str5: .asciiz "Entre com o coordenada x3 do ponto C: \n"
str6: .asciiz "Entre com o coordenada y3 do ponto C: \n"
str7: .asciiz "Area do triangulo: "
numero2: .float 2.0
 
.text
.globl main
 
main:
    li $v0, 4
    la $a0, str1
    syscall
 
    li $v0, 6
    syscall
    mov.s $f1, $f0              # f1 = x1
 
    li $v0, 4
    la $a0, str2
    syscall
 
    li $v0, 6
    syscall
    mov.s $f2, $f0              # f2 = y1
 
    li $v0, 4
    la $a0, str3
    syscall
 
    li $v0, 6
    syscall
    mov.s $f3, $f0              # f3 = x2
 
    li $v0, 4
    la $a0, str4
    syscall
    
    li $v0, 6
    syscall
    mov.s $f4, $f0              # f4 = y2
 
    li $v0, 4
    la $a0, str5
    syscall
 
    li $v0, 6
    syscall
    mov.s $f5, $f0              # f5 = x3
 
    li $v0, 4
    la $a0, str6
    syscall
 
    li $v0, 6
    syscall
    mov.s $f6, $f0              # f6 = y3
 
calcular_area:                  # |(x1(y2-y3) + x2(y3-y1) + x3(y1-y2))/2|
    sub.s $f7, $f4, $f6
    mul.s $f1, $f1, $f7         # f1 = x1(y2-y3)  
    sub.s $f7, $f6, $f2
    mul.s $f3, $f3, $f7         # f3 = x2(y3-y1)
    sub.s $f7, $f2, $f4
    mul.s $f5, $f5, $f7         # f5 = x3(y1-y2)
    add.s $f1, $f1, $f3
    add.s $f1, $f1, $f5         # f1 = f1 + f3 + f5
    lwc1 $f2, numero2
    div.s $f1, $f1, $f2         # f1 = f1/2
    abs.s $f1, $f1
 
imprimir_area:
    li $v0, 4
    la $a0, str7
    syscall
    
    li $v0, 2
    mov.s $f12, $f1
    syscall

end:    
 
    li $v0, 10 
    syscall
