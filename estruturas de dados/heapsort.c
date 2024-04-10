#include <stdio.h>


int* atribui_vetor(int tam)//cria o vetor dinamico e atribui valores a esse
{
  int *vetor;
  int i,temp;

  vetor = (int*)malloc(tam*sizeof(int));
  for(i=1;i<tam;i++)
  {
     scanf("%d",&temp);
     vetor[i] = temp;
  }


 return vetor;
}


void refaz(int *vetor, int raiz, int ultimo)//refaz o heap atraves de uma raiz
{
    int maior,aux,dir,esq,encerrar;


    encerrar = 0;//condiçao para encerrar o laço

    while ((raiz*2 <= ultimo) && encerrar==0)
    {
        esq = raiz*2;
        dir=esq+1;

        if (esq == ultimo)//se filho esquerdo for o ultimo elemento do vetor
            maior = esq ;

        else if (vetor[esq] > vetor[dir])//se valor do filho esquerdo for maior que do filho direito
            maior = esq ;

        else//se valor do filho direito for maior que do filho esquerdo
            maior = dir;

        if (vetor[raiz] < vetor[maior])//se o filho de maior valor for maior que o valor da raiz inverte-se esses valores de posicao
        {
          aux = vetor[raiz];
          vetor[raiz] = vetor[maior];
          vetor[maior] = aux;
          raiz = maior;
        }
        else//encerra pois o vetor caso entre aqui respeita a condiçao de heap
         encerrar = 1;

  }

}

void constroi(int *vetor, int tam)//constroi um heap a partir de um vetor
{
    int i;

    for (i = (tam / 2); i > 0; i--)//chama a funçao refaz para todas as raizes; indo das sub raizes ate a raiz principal
    {
        refaz(vetor, i, tam - 1);
    }
}



void heapsort(int *vetor, int tam)//ordena um vetor que respeita as propriedades do heap
 {
    int i, j ,aux;


    for (i = tam-1; i >= 2; i--)//trocase de lugar a ultima posiçao com a primeira
    {
        aux = vetor[1];
        vetor[1] = vetor[i];
        vetor[i] = aux;
        refaz(vetor, 1, i-1);//refaz o heap desconsiderando as posiçoes ja ordenadas


         for(j=1;j<tam;j++)
         {
           printf("%d ",vetor[j]);
         }
         printf("\n");
    }
}


int main()
{
  int tam,i;
  int *heap;

  scanf("%d",&tam);
  tam++;
  heap = atribui_vetor(tam);

  constroi(heap,tam);

  for(i=1;i<tam;i++)
  {
     printf("%d ",heap[i]);
  }
  printf("\n");

  heapsort(heap,tam);


 return 0;
}