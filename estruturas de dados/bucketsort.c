#include <stdio.h>
#include <stdlib.h>

typedef struct tbucket
{
    int tamanho;
    float *elementos;
}Tbaldes;//estrutura dos baldes

float* atribui_vetor(int tam)//cria o vetor dinamico e atribui valores a esse
{
  float *vetor,temp;
  int i;

   vetor = (float*)malloc(tam*sizeof(float));
   for(i=0;i<tam;i++)
   {
     scanf("%f",&temp);
     vetor[i] = temp;
   }

 return vetor;
}



void imprime_balde(Tbaldes *baldes,int n)//imprime os baldes
{
    int i,j;
     for(i=0;i<n;i++)
     {
         if(baldes[i].tamanho>0)//verifica se o balde nao eh vazio
         {
              printf("%d-> ",i);

              for(j=0;j<baldes[i].tamanho;j++)
              {
                printf("%7.3f",baldes[i].elementos[j]);
              }
              printf("\n");
         }
     }
     printf("\n");

}


void bubblesort (float* vetor, int tam) //ordenaçao pelo metodo da bolha
{
    int i, j;
    float aux;

    for (i=1;i<tam;i++)
    {

        for (j = 0; j < tam - 1; j++)
        {

            if (vetor[j] > vetor[j+1])
            {
                aux = vetor[j];
                vetor[j] = vetor[j+1];
                vetor[j+1] = aux;
            }
        }
    }
}

void bucketsort(float* vetor,int tam,int nbaldes)
{
    int i,p,tp;

    Tbaldes *baldes=(Tbaldes*)malloc(nbaldes*sizeof(Tbaldes));//alocação dos baldes

    for(i=0;i<nbaldes;i++)
        baldes[i].tamanho=0;//inicializa os baldes

    for(i=0;i<tam;i++)//percorre o vetor de entrada montando os baldes
    {
        p = vetor[i]*nbaldes;

        if(p>nbaldes-1)
            p = nbaldes-1;

        if(baldes[p].tamanho==0)//se for o primeiro valor do balde
        {
            baldes[p].elementos=(float*)malloc(tam*sizeof(float));
        }
        tp = baldes[p].tamanho;
        baldes[p].elementos[tp] = vetor[i];
        baldes[p].tamanho++;
    }

     imprime_balde(baldes,nbaldes);//imprime baldes montados
     printf("\n");


     for(i=0;i<nbaldes;i++)//ordena os baldes nao vazios
     {
         if(baldes[i].tamanho>0)
            bubblesort(baldes[i].elementos,baldes[i].tamanho);
     }


     imprime_balde(baldes,nbaldes);//imprime baldes ordenados
     printf("\n");

    p=0;
    for(i=0;i<nbaldes;i++)//salva valores dos baldes ordenados no vetor de entrada
     {
        if(baldes[i].tamanho>0)
        {
            for(tp=0;tp<baldes[i].tamanho;tp++)
            {
                vetor[p] = baldes[i].elementos[tp];
                p++;
            }

        }
     }
     free(baldes);//libera memoria auxiliar

}


int main()
{
   float *vetor;
   int tam,baldes,i;

   scanf("%d",&tam);
   scanf("%d",&baldes);

   vetor=atribui_vetor(tam);


   bucketsort(vetor,tam,baldes);

   for(i=0;i<tam;i++)
    {
        printf("%7.3f",vetor[i]);
    }

 return 0;