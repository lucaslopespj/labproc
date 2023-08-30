.syntax unified
.arm

.global cos_asm

pow_asm:
    push {lr}           ; Salvar lr na pilha

    mov r2, r1          ; r2 = exp
    mov r1, #1          ; r1 = result (começar com 1.0)
    mov r3, #0          ; r3 = counter

loop_pow:
    cmp r3, r2          ; Comparar counter com exp
    beq done_pow        ; Se counter == exp, sair do loop
    mul r1, r1, r0      ; r1 = result * base
    add r3, r3, #1      ; counter++
    b loop_pow

done_pow:
    pop {pc}            ; Retornar


fat_asm:
    push {lr}           ; Salvar lr na pilha

    mov r1, r0          ; r1 = n
    mov r0, #1          ; r0 = result (começar com 1.0)
    mov r2, #1          ; r2 = counter

loop_fat:
    cmp r2, r1          ; Comparar counter com n
    beq done_fat        ; Se counter == n, sair do loop
    mul r0, r0, r2      ; r0 = result * counter
    add r2, r2, #1      ; counter++
    b loop_fat

done_fat:
    pop {pc}            ; Retornar

cos_asm:
    push {r4, lr}       ; Salvar r4 e lr na pilha

    mov r4, r1          ; r4 = terms
    mov r1, #1          ; r1 = result (começar com 1.0)
    mvn r2, r1          ; r2 = -1
    mov r3, #0          ; r3 = n

loop_cos:
    ldr r5, =2
    mul r5, r5, r3      ; r5 = 2 * n

    bl pow_asm          ; Chamar a função pow_asm (para calcular pow(x, r5))
    add r6, r5, r2, lsl #31 ; r6 = sign * x^(2 * n)

    bl fat_asm          ; Chamar a função fat_asm (para calcular fat(2 * n))

    mul r0, r6, r0      ; r0 = (sign * x^(2 * n)) / fat(2 * n)
    add r1, r1, r0      ; result += term

    mvn r0, r2          ; Negar o sinal
    and r2, r0, #1      ; r2 = novo sinal (-1 ou 1)

    add r3, r3, #1      ; n++
    cmp r3, r4          ; Comparar n com terms
    blt loop_cos        ; Voltar ao loop se n < terms

    pop {r4, pc}        ; Restaurar r4 e lr da pilha e retornar




/* Sobre a função pow_asm
    push {lr}: Isso salva o valor atual do registrador de link (lr) na pilha. O registrador lr é frequentemente usado para armazenar o endereço de retorno de uma função.

    mov r2, r1: Isso copia o valor do registrador r1 (que contém o expoente) para o registrador r2. Isso permite que r1 seja usado posteriormente para armazenar o resultado.

    mov r1, #1: Inicializa o registrador r1 com o valor 1.0. Isso é importante porque a potência de qualquer número elevado a 0 é 1.

    mov r3, #0: Inicializa o registrador r3 com o valor 0. Isso é usado como contador para acompanhar quantas multiplicações já foram feitas.

    loop_pow:: Isso define um marcador para o início do loop.

    cmp r3, r2: Compara o valor do contador (r3) com o valor do expoente (r2).

    beq done_pow: Se o valor do contador for igual ao valor do expoente, o loop é encerrado e o fluxo de controle salta para o rótulo done_pow.

    mul r1, r1, r0: Multiplica o valor atual do resultado (r1) pelo valor do base (r0) e armazena o resultado em r1. Isso é equivalente a elevar o base à potência do contador.

    add r3, r3, #1: Incrementa o contador (r3) para acompanhar quantas iterações do loop já foram feitas.

    b loop_pow: Salta de volta para o início do loop (marcado por loop_pow).

    done_pow:: Esse rótulo marca o final do loop.

    pop {pc}: Isso restaura o valor do registrador de link (lr) da pilha e retorna ao endereço de retorno armazenado no lr. Isso efetivamente encerra a função.
*/






/* Sobre a função fat_asm
    push {lr}: Isso salva o valor atual do registrador de link (lr) na pilha. O registrador lr é frequentemente usado para armazenar o endereço de retorno de uma função.

    mov r1, r0: Isso copia o valor do registrador r0 (que contém o número para calcular o fatorial) para o registrador r1. Isso permite que r0 seja usado posteriormente para armazenar o resultado.

    mov r0, #1: Inicializa o registrador r0 com o valor 1.0. Isso é importante porque o fatorial de 0 é 1.

    mov r2, #1: Inicializa o registrador r2 com o valor 1. Isso é usado como contador para acompanhar quantas multiplicações já foram feitas.

    loop_fat:: Isso define um marcador para o início do loop.

    cmp r2, r1: Compara o valor do contador (r2) com o valor de n (r1).

    beq done_fat: Se o valor do contador for igual ao valor de n, o loop é encerrado e o fluxo de controle salta para o rótulo done_fat.

    mul r0, r0, r2: Multiplica o valor atual do resultado (r0) pelo valor do contador (r2) e armazena o resultado em r0. Isso é equivalente a calcular o produto dos números de 1 até n.

    add r2, r2, #1: Incrementa o contador (r2) para acompanhar quantas iterações do loop já foram feitas.

    b loop_fat: Salta de volta para o início do loop (marcado por loop_fat).

    done_fat:: Esse rótulo marca o final do loop.

    pop {pc}: Isso restaura o valor do registrador de link (lr) da pilha e retorna ao endereço de retorno armazenado no lr. Isso efetivamente encerra a função.
*/



/* Sobre a função cos_asm
    push {r4, lr}: Isso salva o valor dos registradores r4 e lr na pilha.

    mov r4, r1: Copia o valor de r1 (número de termos para a série) para o registrador r4.

    mov r1, #1: Inicializa o registrador r1 com 1.0 para armazenar o resultado (inicializa o resultado como 1.0).

    mvn r2, r1: Calcula o complemento de um (bitwise NOT) do valor de r1 (1.0) e armazena o resultado em r2. Isso inicializa o sinal como -1.

    mov r3, #0: Inicializa o registrador r3 com 0 para contar os termos da série.

    loop_cos:: Marcador para o início do loop.

    ldr r5, =2: Carrega o valor 2 para o registrador r5.

    mul r5, r5, r3: Multiplica o valor de r5 (2) pelo valor de r3 (contador) e armazena o resultado em r5. Isso calcula 2 * n.

    bl pow_asm: Chama a função pow_asm para calcular pow(x, 2 * n).

    add r6, r5, r2, lsl #31: Adiciona o valor de r2 (sinal) deslocado 31 bits para a esquerda ao resultado anterior (2 * n) e armazena o resultado em r6. Isso calcula sign * x^(2 * n).

    bl fat_asm: Chama a função fat_asm para calcular fat(2 * n).

    mul r0, r6, r0: Multiplica o valor de r6 (sign * x^(2 * n)) pelo valor de r0 (pow(x, 2 * n)) e armazena o resultado em r0. Isso calcula (sign * x^(2 * n)) / fat(2 * n).

    add r1, r1, r0: Adiciona o valor de r0 (termo atual) ao valor de r1 (resultado acumulado).

    mvn r0, r2: Calcula o complemento de um (bitwise NOT) do valor de r2 (sinal) e armazena o resultado em r0.

    and r2, r0, #1: Realiza uma operação AND bitwise entre o valor de r0 (complemento de r2) e o valor 1, armazenando o resultado de volta em r2. Isso alterna o sinal entre -1 e 1.

    add r3, r3, #1: Incrementa o valor de r3 (contador) para avançar para o próximo termo da série.

    cmp r3, r4: Compara o valor de r3 (contador) com o valor de r4 (número de termos).

    blt loop_cos: Se o valor de r3 (contador) for menor que o valor de r4 (número de termos), o fluxo de controle retorna ao marcador loop_cos, continuando o loop.

    pop {r4, pc}: Restaura o valor dos registradores r4 e lr da pilha e retorna da função.
*/