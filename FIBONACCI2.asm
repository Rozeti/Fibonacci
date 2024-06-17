.data
prompt:     .asciiz "Digite o termo da sequência de Fibonacci que deseja saber: "
result_msg: .asciiz "O valor do termo na posição desejada é: "
newline:    .asciiz "\n"
phi_msg:    .asciiz "A razão áurea entre os termos 40 e 41 é: "

.text
main:
    # Imprimir mensagem para o usuário
    li $v0, 4              # Código do serviço para imprimir string
    la $a0, prompt         # Carregar o endereço da string
    syscall                # Chamar o sistema para imprimir

    # Ler a entrada do usuário
    li $v0, 5              # Código do serviço para ler inteiro
    syscall                # Chamar o sistema para ler inteiro
    move $a0, $v0          # Passar o valor lido para $a0, que será usado como argumento para a função

    # Chamar a função de Fibonacci
    jal fibonacci          # Chama a função fibonacci e armazena o resultado em $v0

    # Armazenar o resultado no registrador $s1
    move $s1, $v0          # O resultado da função está em $v0, move para $s1

    # Imprimir a mensagem do resultado
    li $v0, 4              # Código do serviço para imprimir string
    la $a0, result_msg     # Carregar o endereço da string
    syscall                # Chamar o sistema para imprimir

    # Imprimir o valor do termo de Fibonacci
    move $a0, $s1          # Resultado final em $a0
    li $v0, 1              # Código do serviço para imprimir inteiro
    syscall                # Chamar o sistema para imprimir

    # Imprimir uma nova linha
    li $v0, 4              # Código do serviço para imprimir string
    la $a0, newline        # Carregar o endereço da string de nova linha
    syscall                # Chamar o sistema para imprimir

    # Calcular Fibonacci(40) e Fibonacci(41)
    li $a0, 40             # Passar 40 como argumento para a função fibonacci
    jal fibonacci          # Chama a função fibonacci para calcular Fibonacci(40)
    move $s3, $v0          # Armazenar Fibonacci(40) em $s3

    li $a0, 41             # Passar 41 como argumento para a função fibonacci
    jal fibonacci          # Chama a função fibonacci para calcular Fibonacci(41)
    move $s2, $v0          # Armazenar Fibonacci(41) em $s2

    # Calcular a razão áurea
    mtc1 $s2, $f2          # Mover Fibonacci(41) para $f2
    mtc1 $s3, $f4          # Mover Fibonacci(40) para $f4
    cvt.s.w $f2, $f2       # Converter $f2 para ponto flutuante
    cvt.s.w $f4, $f4       # Converter $f4 para ponto flutuante
    div.s $f0, $f2, $f4    # $f0 = $f2 / $f4

    # Imprimir a mensagem da razão áurea
    li $v0, 4              # Código do serviço para imprimir string
    la $a0, phi_msg        # Carregar o endereço da string
    syscall                # Chamar o sistema para imprimir

    # Imprimir o valor da razão áurea
    li $v0, 2              # Código do serviço para imprimir float
    mov.s $f12, $f0        # Mover o valor da razão áurea para $f12
    syscall                # Chamar o sistema para imprimir

    # Finalizar o programa
    j FIM          # Ir para o rótulo de finalização

# Função para calcular o n-ésimo termo da sequência de Fibonacci
fibonacci:
    # Entrada: $a0 = n (termo da sequência desejado)
    # Saída:   $v0 = Fibonacci(n)

    # Verificar se n é 1
    li $t0, 1
    beq $a0, $t0, fib1

    # Inicializar os valores para calcular a sequência de Fibonacci
    li $t1, 1              # Fibonacci(1)
    li $t2, 1              # Fibonacci(2)
    sub $a0, $a0, 2        # Decrementar o contador inicial (já temos os dois primeiros termos)

fib_loop:
    beqz $a0, fib_done     # Se $a0 for 0, terminamos
    add $t3, $t1, $t2      # t3 = t1 + t2
    move $t1, $t2          # Atualizar t1 para t2
    move $t2, $t3          # Atualizar t2 para t3
    sub $a0, $a0, 1        # Decrementar o contador
    j fib_loop             # Repetir o loop

fib1:
    li $v0, 1              # Se n é 1, o resultado é 1
    jr $ra                 # Retornar da função

fib_done:
    move $v0, $t2          # Colocar o resultado final em $v0
    jr $ra                 # Retornar da função

FIM:
    li $v0, 10             # Código do serviço para sair
    syscall                # Chamar o sistema para sair