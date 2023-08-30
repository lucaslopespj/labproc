#include <stdio.h>

/*Fatorial de n*/
double fat(int n) {
    if (n <= 1) {
        return 1.0;
    }
    return n * fat(n - 1);
}

/*Potencia*/
double pow(double base, int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) {
        result *= base;
    }
    return result;
}

/*Função seno baseado em série de Taylor*/
double sin(double x, int terms) {
    double result = 0.0;
    int sign = 1;

    for (int n = 0; n < terms; n++) {
        double term = pow(x, 2 * n + 1) / fat(2 * n + 1);
        result += sign * term;
        sign *= -1;
    }

    return result;
}

/*Função cosseno baseada em série de Taylor*/
double cos(double x, int terms) {
    double result = 1.0; // Primeiro termo da série de Taylor (n = 0)
    int sign = -1;       // Começamos com sinal negativo (cos(pi) = -1)

    for (int n = 1; n < terms; n++) {
        double term = pow(x, 2 * n) / fat(2 * n);
        result += sign * term;
        sign *= -1;
    }

    return result;
}


/*Função tangente baseada em série de Taylor*/
double tan(double x, int terms) {
    double result = x; // Primeiro termo da série de Taylor (n = 1)

    for (int n = 1; n < terms; n++) {
        double term = (pow(-1, n) * pow(x, 2 * n + 1)) / (2 * n + 1);
        result += term;
    }

    return result;
}