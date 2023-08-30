.syntax unified
.arm

.global tan_asm

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

tan_asm:
    push {r4, lr}       ; Salvar r4 e lr na pilha

    mov r4, r1          ; r4 = terms
    mov r1, r0          ; r1 = result (começar com x)
    mov r3, #1          ; r3 = n

loop_tan:
    ldr r5, =2
    mul r5, r5, r3      ; r5 = 2 * n
    add r5, r5, #1      ; r5 = 2 * n + 1

    bl pow_asm          ; Chamar a função pow_asm (para calcular pow(x, r5))

    ldr r6, =2
    mul r6, r6, r3      ; r6 = 2 * n
    mvn r7, r3          ; r7 = -n

    bl pow_asm          ; Chamar a função pow_asm (para calcular pow(-1, r3) * pow(x, r5))

    ldr r6, =2
    mul r6, r6, r3      ; r6 = 2 * n
    add r6, r6, #1      ; r6 = 2 * n + 1

    bl fat_asm          ; Chamar a função fat_asm (para calcular fat(2 * n + 1))

    mul r0, r7, r0      ; r0 = pow(-1, r3) * pow(x, 2 * n + 1)
    add r1, r1, r0      ; result += term

    add r3, r3, #1      ; n++
    cmp r3, r4          ; Comparar n com terms
    blt loop_tan        ; Voltar ao loop se n < terms

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