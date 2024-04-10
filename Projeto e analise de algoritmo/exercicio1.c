//A entrada consiste de um número inteiro N (3 < N < 1.000.000) par.

//a saida deve imprimir o número de pares de primos que somados resultam em N. Note que 3+5=8 e 5+3=8 são o mesmo par. Você deve contar o número de pares distintos.

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

bool testaPrimo(int primo)//função que testa se um numero é primo pelo Crivo de Eratóstenes
{
    int i,r;

    r = sqrt(primo);
    i = 3;
        if(primo>7)
        {
            if(primo%2==0)
                return false;
            if(primo%3==0)
                return false;
            if(primo%7==0)
                return false;
            if((r*r)==primo)
                return false;
        }
        while(i <=r)
        {
          if(primo%i==0)//se for divisivel por algum numero nesse intervalo ele não é primo
              return false;
          i+=2;
        }
        return true;
}

int contaSomas(int valor)//função que conta os pares de primos que somados dao o numero de entrada
{
    int cont = 0;
    int primo1,primo2,meio;

    meio = valor/2;

    if(testaPrimo(valor-2))
        cont++;

    primo2=3;
    while(primo2<=meio)//testa um dos pares ate o meio, para não haver pares repetidos em ordens diferentes
    {
           if(testaPrimo(primo2))//testa se o primeiro vaolr é primo
           {
              primo1 = valor-primo2;
              if(testaPrimo(primo1))//testa se seu par tambem é primo
                 cont++;
           }
           primo2+=2;
    }
    return cont;
}

int main()
{
    int entrada;

    scanf("%d",&entrada);

    if(entrada > 3 && entrada <1000000)
    {
      if(entrada%2==0)
          printf("%d",contaSomas(entrada));
    }
    return 0;
}