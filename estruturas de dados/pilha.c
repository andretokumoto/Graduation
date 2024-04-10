#include <stdio.h>
#include <stdlib.h>
#define tamanhoMax 5


struct pilha {
int elementos[tamanhoMax];
int topo;
};
typedef struct pilha tipoPilha;

void inicializaPilha(tipoPilha *pilhaAux)
{
  int i;

  for (i=0; i<=tamanhoMax-1; i++)
   pilhaAux->elementos[i] = 0;

 pilhaAux->topo = -1;

}

int empilhar(tipoPilha *pilhaAux,int info)
{
  if(pilhaAux->topo>=tamanhoMax-1)
   return -1;
  else
  {
    pilhaAux->topo++;
    pilhaAux->elementos[pilhaAux->topo]=info;
    return 0;
  }

}

int remocao(tipoPilha *pilhaAux)
{
  int aux;
  aux=pilhaAux->elementos[pilhaAux->topo];
  pilhaAux->elementos[pilhaAux->topo]=0;
  pilhaAux->topo--;
  return aux;
}

void consulta(tipoPilha *pilhaAux)
{
  if(pilhaAux->topo!=-1)
   printf("%d\n",pilhaAux->elementos[pilhaAux->topo]);
}

int pilhaCheia(tipoPilha *pilhaAux)
{
  if(pilhaAux->topo==tamanhoMax-1)
   return 1;
  else
    return 0;
}

int pilhaVazia(tipoPilha *pilhaAux)
{
  if(pilhaAux->topo==-1)
   return 1;
  else
    return 0;
}

/*void imprime(tipoPilha *pilhaAux)
{
 int i;

 for(i=pilhaAux->topo;i>=0;i--)
   printf("%d ",pilhaAux->elementos[i]);
}*/

void imprime(tipoPilha *pilhaAux)
{
  while(pilhaAux->topo!=-1)
  {
    printf("%d ",remocao(pilhaAux));
  }
  printf("\n");
}



int main()
{
  int info,tipo,c=0;
  tipoPilha pilha;
  inicializaPilha(&pilha);
  printf("1 - insere\n2 - remove\n");


while(c==0)
{
scanf("%d",&tipo);
  switch(tipo)
  {
    case 1:
      scanf("%d",&info);
      empilhar(&pilha,info);
    break;

    case 2:
      remocao(&pilha);
    break;

    default:
     c=1;
     break;
  }

}
  imprime(&pilha);

 return 0;
}