#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct elemento
{
  int info;
  struct elemento *prox;
  struct elemento *ant;
}tipoInfo;

typedef struct
{
  tipoInfo *primeiro;
  tipoInfo *ultimo;
  int tamanho;
}tipoListaDDE;


void inicializaLista (tipoListaDDE *listaAux)
{
 listaAux->primeiro = NULL;
 listaAux->ultimo = NULL;
 listaAux->tamanho=0;
}


tipoInfo *aloca(int info)
{
  tipoInfo *novo;
  novo=NULL;
  while(novo==NULL)
   novo=(tipoInfo*)malloc(sizeof(tipoInfo));

  novo->info=info;
  novo->ant=NULL;
  novo->prox=NULL;
  return novo;
}

void comecaJogo(tipoListaDDE *listaAux)
{
  tipoInfo *novo;
  int info;
  srand(time(NULL));
  info=rand()%10;

}


int main()
{
   tipoListaDDE lista;
   inicializaLista(&lista);
   comecaJogo(&lista);
    return 0;
}