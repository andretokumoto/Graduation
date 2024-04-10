#include <stdio.h>
#include <stdlib.h>

int* atribui_vetor(int tam)//cria o vetor dinamico e atribui valores a esse
{
  int *vetor;
  int i,temp;

   vetor = (int*)malloc(tam*sizeof(int));
   for(i=0;i<tam;i++)
   {
     scanf("%d",&temp);
     vetor[i] = temp;
   }

 return vetor;
}

int maiorValor(int *vetor,int tam)//retorna maior valor do vetor
{
    int i,maior;

    maior = vetor[0];
    for(i=0;i<tam;i++)
    {
        if(vetor[i]>maior)
            maior = vetor[i];
    }

 return maior;
}

void counting(int *vetor,int tam, int div,int* auxA,int *auxB)
{

    int i,temp;


    for(i=0;i<10;i++)//inicializa vetor de contagem
    {
        auxA[i]=0;
    }

    for(i=0;i<tam;i++)//faz a contagem dos elementos
    {
        temp = (vetor[i]/div)%10;
        auxA[temp]++;
    }

    for(i=1;i<10;i++)//cria vetor acumulado
    {
        auxA[i]+=auxA[i-1];
    }

    for(i=tam-1;i>=0;i--)//coloca valores ordenados no auxB
    {
        temp = auxA[(vetor[i]/div)%10] - 1;
        auxB[temp]=vetor[i];
        auxA[(vetor[i]/div)%10]--;
    }

    for(i=0;i<tam;i++)//coloca valores de auxB no vetor de entrada
    {
        vetor[i]=auxB[i];
    }


    for(i=0;i<tam;i++)//imprime o vetor
    {
      printf("%d ",vetor[i]);
    }
    printf("\n");

}


void radixsort(int* vetor, int tam)
{
    int maior,div;
    int *auxA,*auxB;

    div = 1;
    maior = maiorValor(vetor,tam);

    auxA = (int*)malloc(10*sizeof(int));
    auxB = (int*)malloc((tam)*sizeof(int));//cria vetores auxiliares

    while(maior/div >0)
    {
      counting(vetor,tam,div,auxA,auxB);//chama a funçao de ordenaçao para cada posicao
      div = div*10;
    }

    free(auxA);
    free(auxB);
}

int main()
{

  int tam;
  int *vetor;

  scanf("%d",&tam);
  vetor = atribui_vetor(tam);

  radixsort(vetor,tam);


  return 0;
}