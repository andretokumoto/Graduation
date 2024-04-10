/*
Entrada
A entrada contém uma única linha que apresenta o valor N (1 ≤ N ≤ 10.000) do valor a ser pago na
transação em PW2C.

Saída
Imprima uma linha com a quantidade mínima de moedas a serem transacionadas para se realizar o
pagamento no valor de N.
*/

#include <stdio.h>
#include <math.h>

int potencia(int valor)//calcula o saldo depois de cada transação
{
    int menos,p;
    p=1;

    while(p<valor)//calcula o valor da potencia de 2 mais proxima(superior á valor)
    {
       if(p==valor)
         return 0;

     p*=2;
    }

    menos=p/2;//calcula o valor da potencia de 2 mais proxima(inferior á valor)

    /*Pega o valor de tranferencia, superior ou inferior que dará um saldo menor*/
    if(valor-menos < p-valor)
      return valor-menos;
    else
      return p-valor;

}


int calculaTransacao(int v)//calcula o numero de moedas
{
    int moedas=0,saldo;

    while(v>0)//vai fazendo a tranferenca de moedas até não haver mais divida
    {
         saldo = potencia(v);
         v = saldo;
         moedas++;
    }
    return moedas;
}


int main()
{
    int valor;

    scanf("%d",&valor);
    printf("%d",calculaTransacao(valor));

 return 0;
}