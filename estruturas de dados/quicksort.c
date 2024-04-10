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

int  particiona(int *vetor,int primeiro,int ultimo,int tam)//seleciona um pivo e posiciona todos os elementos menores que esse a esquerda e os maiores a direita no vetor
{
 int pivo,i,aux;

 pivo=primeiro-1;

   for(i=primeiro;i<ultimo;i++)//percorre o vetor ate a penultima posiçao comparando os elementos ao ultimo valor(pivo)
   {
     if(vetor[i]<=vetor[ultimo])//se elemento atual menor ou igual ao pivo
     {
        aux = vetor[pivo+1];
        vetor[pivo+1]=vetor[i];//coloca-se o valor observado para a ultima posiçao antes da nova posiçao do pivo
        vetor[i]=aux;
        pivo++;//nova posiçao do pivo
     }
   }
    aux = vetor[pivo+1];
    vetor[pivo]=vetor[ultimo+1];
    vetor[ultimo+1]=aux;//coloca-se o pivo na posiçao correta


    for(i=0;i<tam;i++)//imprime o vetor
    {
      printf("%d ",vetor[i]);
    }
    printf("\n");

 return pivo+1;
}

void quicksort(int *vetor,int primeiro,int ultimo,int tam)//particiona o vetor em dois
{
    int pivo;

    if(ultimo>primeiro)
    {
       pivo = particiona(vetor,primeiro,ultimo,tam);
       quicksort(vetor,primeiro,pivo-1,tam);//chama a funçao para posiçoes antes do pivo
       quicksort(vetor,pivo+1,ultimo,tam);//chama a funçao para posiçoes depois do pivo

    }
}


int main()
{
  int tam;
  int *vetor;

  scanf("%d",&tam);
  vetor = atribui_vetor(tam);

  quicksort(vetor,0,tam-1,tam);

  return 0;
}