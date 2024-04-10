#include <stdio.h>
#include <stdlib.h>
#define TAM 10

typedef struct info
{
  int valor;
  int prox;
}tipoInfo;


typedef struct listaEE
{
  int tamanho_lista;
  int primeiro;
  int ultimo;
  int pos_livre[TAM];
  tipoInfo elemento[TAM];
}tipoLista;


void iniciaiza_lista(tipoLista *listaAux)
{
  int i;
    listaAux->tamanho_lista =0;
    listaAux->primeiro=-1;
    listaAux->ultimo=-1;

    for(i=0;i<TAM;i++)
    {
      listaAux->elemento[i].valor=0;
      listaAux->elemento[i].prox=-1;
      listaAux->pos_livre[i]=1;
    }
}

int posicao_livre(tipoLista *listaAux)
{
 int i;
 for(i=0;i<TAM;i++)
 {
   if(listaAux->pos_livre[i]==1)
     return i;
 }

}

void insere_final(tipoLista *listaAux,int posicao)
{

  scanf("%d",&listaAux->elemento[posicao].valor);
  if(listaAux->tamanho_lista==0)
  {
     listaAux->primeiro=posicao;
     listaAux->ultimo=posicao;
  }

  else
     listaAux->elemento[listaAux->ultimo].prox=posicao;

  listaAux->pos_livre[posicao]=0;
  listaAux->elemento[posicao].prox=-1;

}