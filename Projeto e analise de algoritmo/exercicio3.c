/*
Entrada
A entrada se inicia com uma linha contendo o número inteiro N (2 ≤ N ≤ 100.000) de participantes de um
evento. Cada participante é identificado por um número entre 1 e N. Em cada uma das próximas N linhas, serão
apresentados dois identificadores a e b para representar que a pessoa b foi indicada por outra pessoa a.

Saída
Imprima uma linha com os identificadores das pessoas a serem convidadas para a segunda etapa do
evento em ordem crescente. Imprima um espaço em branco entre 2 participantes.
*/

#include <stdio.h>
#include <stdlib.h>

void selection_sort (int *vetor,int max) {
  int i, j, min, aux;

  for (i = 0; i < (max - 1); i++)
   {
     /* O minimo é o primeiro número não ordenado ainda */
     min = i;
    for (j = i+1; j < max; j++) {
      /* Caso tenha algum numero menor ele faz a troca do minimo*/
      if (vetor[j] < vetor[min]) {
     min = j;
      }
    }
    /* Se o minimo for diferente do primeiro numero não ordenado ele faz a troca para ordena-los*/
    if (i != min) {
      aux = vetor[i];
      vetor[i] = vetor[min];
      vetor[min] = aux;
    }
  }
}


int selecionados(int grafo[100000][3],int n)
{

    int i,j=1,k=0,inicio,atual,numsele=0,numcand=0;

    int *selecao,*aux;
    aux = (int*)malloc(n*sizeof(int));
    selecao = (int*)malloc(n*sizeof(int));

    for(i=0;i<n;i++)
    {

        if(grafo[i][0]==0)//nó não visitado
        {
           // printf("..%d\n",i+1);



            inicio = grafo[i][1];
            aux[0]=inicio;
            atual = grafo[i][2];
            grafo[i][0]=1;
            numcand=1;
            j=1;

            //printf("numcand %d   numsele %d   atual %d  i %d\n",numcand,numsele,atual,i);
            while(j<n)
            {

                aux[j]=atual;
                atual = grafo[atual-1][2];
                numcand++;
                if(atual==inicio)
                {
                    for(k=0;k<numcand;k++)
                    {
                      selecao[k+numsele] = aux[k];
                    }
                    numsele = numsele+numcand;
                    j=n;
                }

                j++;
            }
        }



    }


                    selection_sort(selecao,numsele);
                    for(k=0;k<numsele;k++)
                    {
                        printf("%d ",selecao[k]);
                    }


    return 1;
}



int main()
{
    int n,i,c1,c2;
    int participantes[100000][3];
    scanf("%d",&n);

    for(i=0;i<n;i++)
    {
       scanf("%d %d",&c1,&c2);
       participantes[i][1]= c1;
       participantes[i][2]= c2;
       participantes[i][0]=  0;

    }

     selecionados(participantes,n);

 return 0;
}