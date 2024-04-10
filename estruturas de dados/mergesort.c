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


int intercala(int *vetor,int primeiro,int meio,int ultimo,int* aux,int tam)//intercala os sub vetores em ordem crescente
{
    int dir,esq,i,j;
    dir = meio+1;
    esq = primeiro;
    i=0;

    while(dir!=ultimo+1 && esq != meio+1)//enquanto nao terminar de percorrer os dois sub-vetores
    {

        if(vetor[dir]<vetor[esq])//valor do sub-vetor da direita eh menor
        {
            aux[i]=vetor[dir];
            dir++;
            i++;
        }
        else//valor do sub-vetor da esquerda eh menor
        {
            aux[i]=vetor[esq];
            esq++;
            i++;
        }
    }

    while(dir<=ultimo)//caso o sub-vetor da esquerda tenha sido todo percorrido mas o da direita nao, todos os valores restantes sao copiados no vetor auxiliar
    {
       aux[i]=vetor[dir];
       i++;
       dir++;
    }

    while(esq<=meio)//caso o sub-vetor da direita tenha sido todo percorrido mas o da esquerda nao, todos os valores restantes sao copiados no vetor auxiliar
    {
       aux[i]=vetor[esq];
       i++;
       esq++;
    }

    i=0;
    for(j=primeiro;j<=ultimo;j++)//todos os valores do vetor auxiliar sao copiados no vetor principal
    {
        vetor[j]=aux[i];
        i++;
    }


    for(i=0;i<tam;i++)
    {
      printf("%d ",vetor[i]);
    }
    printf("\n");

}


void mergesort(int *vetor,int primeiro,int ultimo,int* aux,int tam)//funçao que quebra o vetor em dois sub-vetores e manda para a ordenaçao
{
    int meio;

    if(primeiro<ultimo)
    {
        meio = (ultimo+primeiro)/2;//posiçao central do vetor
        mergesort(vetor,primeiro,meio,aux,tam);//sub-vetor da primeira metade
        mergesort(vetor,meio+1,ultimo,aux,tam);//sub-vetor da primeira metade
        intercala(vetor,primeiro,meio,ultimo,aux,tam);//ordenaçao
    }

}

int main()
{
  int tam;
  int *vetor,*aux;

  scanf("%d",&tam);
  vetor = atribui_vetor(tam);
  aux = (int*)malloc(tam*sizeof(int));

  mergesort(vetor,0,tam-1,aux,tam);
  free(aux);


 return 0;
}