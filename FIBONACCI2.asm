.data
prompt:     .asciiz "Digite o termo da sequ�ncia de Fibonacci que deseja saber: "
result_msg: .asciiz "O valor do termo na posi��o desejada �: "
newline:    .asciiz "\n"
phi_msg:    .asciiz "A raz�o �urea entre os termos 40 e 41 �: "

.text
main:
    # Imprimir mensagem para o usu�rio
    li $v0, 4              # C�digo do servi�o para imprimir string
    la $a0, prompt         # Carregar o endere�o da string
    syscall                # Chamar o sistema para imprimir

    # Ler a entrada do usu�rio
    li $v0, 5              # C�digo do servi�o para ler inteiro
    syscall                # Chamar o sistema para ler inteiro
    move $a0, $v0          # Passar o valor lido para $a0, que ser� usado como argumento para a fun��o

    # Chamar a fun��o de Fibonacci
    jal fibonacci          # Chama a fun��o fibonacci e armazena o resultado em $v0

    # Armazenar o resultado no registrador $s1
    move $s1, $v0          # O resultado da fun��o est� em $v0, move para $s1

    # Imprimir a mensagem do resultado
    li $v0, 4              # C�digo do servi�o para imprimir string
    la $a0, result_msg     # Carregar o endere�o da string
    syscall                # Chamar o sistema para imprimir

    # Imprimir o valor do termo de Fibonacci
    move $a0, $s1          # Resultado final em $a0
    li $v0, 1              # C�digo do servi�o para imprimir inteiro
    syscall                # Chamar o sistema para imprimir

    # Imprimir uma nova linha
    li $v0, 4              # C�digo do servi�o para imprimir string
    la $a0, newline        # Carregar o endere�o da string de nova linha
    syscall                # Chamar o sistema para imprimir

    # Calcular Fibonacci(40) e Fibonacci(41)
    li $a0, 40             # Passar 40 como argumento para a fun��o fibonacci
    jal fibonacci          # Chama a fun��o fibonacci para calcular Fibonacci(40)
    move $s3, $v0          # Armazenar Fibonacci(40) em $s3

    li $a0, 41             # Passar 41 como argumento para a fun��o fibonacci
    jal fibonacci          # Chama a fun��o fibonacci para calcular Fibonacci(41)
    move $s2, $v0          # Armazenar Fibonacci(41) em $s2

    # Calcular a raz�o �urea
    mtc1 $s2, $f2          # Mover Fibonacci(41) para $f2
    mtc1 $s3, $f4          # Mover Fibonacci(40) para $f4
    cvt.s.w $f2, $f2       # Converter $f2 para ponto flutuante
    cvt.s.w $f4, $f4       # Converter $f4 para ponto flutuante
    div.s $f0, $f2, $f4    # $f0 = $f2 / $f4

    # Imprimir a mensagem da raz�o �urea
    li $v0, 4              # C�digo do servi�o para imprimir string
    la $a0, phi_msg        # Carregar o endere�o da string
    syscall                # Chamar o sistema para imprimir

    # Imprimir o valor da raz�o �urea
    li $v0, 2              # C�digo do servi�o para imprimir float
    mov.s $f12, $f0        # Mover o valor da raz�o �urea para $f12
    syscall                # Chamar o sistema para imprimir

    # Finalizar o programa
    j FIM          # Ir para o r�tulo de finaliza��o

# Fun��o para calcular o n-�simo termo da sequ�ncia de Fibonacci
fibonacci:
    # Entrada: $a0 = n (termo da sequ�ncia desejado)
    # Sa�da:   $v0 = Fibonacci(n)

    # Verificar se n � 1
    li $t0, 1
    beq $a0, $t0, fib1

    # Inicializar os valores para calcular a sequ�ncia de Fibonacci
    li $t1, 1              # Fibonacci(1)
    li $t2, 1              # Fibonacci(2)
    sub $a0, $a0, 2        # Decrementar o contador inicial (j� temos os dois primeiros termos)

fib_loop:
    beqz $a0, fib_done     # Se $a0 for 0, terminamos
    add $t3, $t1, $t2      # t3 = t1 + t2
    move $t1, $t2          # Atualizar t1 para t2
    move $t2, $t3          # Atualizar t2 para t3
    sub $a0, $a0, 1        # Decrementar o contador
    j fib_loop             # Repetir o loop

fib1:
    li $v0, 1              # Se n � 1, o resultado � 1
    jr $ra                 # Retornar da fun��o

fib_done:
    move $v0, $t2          # Colocar o resultado final em $v0
    jr $ra                 # Retornar da fun��o

FIM:
    li $v0, 10             # C�digo do servi�o para sair
    syscall                # Chamar o sistema para sair