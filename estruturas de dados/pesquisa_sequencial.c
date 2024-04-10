#include <stdio.h>
#include <stdlib.h>
#define NIL -1

//algoritmo de pesquisa sequencial

typedef int TChave;
typedef int Tapontador;

typedef struct{

 TChave chave;

}TItem;



typedef struct{

TItem *item;
int n,max;

}TDicionario;



TDicionario *inicia()//inicia um dicionario vazio
{
   TDicionario *d;

    d = (TDicionario*)malloc(sizeof(TDicionario));
    d->n = 0;
    d->max = 10;
    d->item = (TItem*)malloc(d->max * sizeof(TItem));

 return d;
}

Tapontador pesquisa(TChave chave,TDicionario *d)//procura-se uma chave no array e retorna a posiçao
{
   int i;

   for(i=0; i < d->n ;i++)
   {
       if(d->item[i].chave == chave)//achou a chave no vetor
          return i;
   }
   return -1;//nao achou posiçao

}

int insere(TDicionario *dicionario,TChave item)//insere valores no array
{

    if(pesquisa(item,dicionario)< 0 )//caso valor nao exista no vetor
      {
       if(dicionario->max == dicionario->n)//caso a memoria esteja cheia eh dobrado o valor do vetor
       {
          dicionario->item = (TItem*)realloc(dicionario->item,(dicionario->max*2)*sizeof(TItem));
          dicionario->max*=2;
       }
       dicionario->item[dicionario->n].chave=item;//insersao do valor
       dicionario->n++;
       return 1;
    }
    return NIL;
}


int retira(TDicionario *dicionario,TChave chave)//retira um valor do vetor
{
   Tapontador indice;
   int i;

   indice = pesquisa(chave,dicionario);

  if(indice >= 0)//caso ache a chave
  {

     if(indice < dicionario->n-1)//se nao for o ultimo valor
     {
          for(i=indice;i < dicionario->n-1 ;i++)//todos os dados são deslocados
          {
              dicionario->item[i] = dicionario->item[i+1];
          }
      }
      dicionario->n--;//decrescimento no numero de dados

      if(dicionario->n <= (dicionario->max/3))//caso o numero de dados seja menor que um terço do valor alocado, o tamanho de dados alocado eh diminuido pela metade
      {
         dicionario->item = (TItem*)realloc(dicionario->item,(dicionario->max/2)*sizeof(TItem));
         dicionario->max = dicionario->max/2;
      }

      return 1;
   }
   return 0;

}


void leituraDeDados(TDicionario *dicionario)//leitura de dados
{
    TChave temp;

      do{
          scanf("%d",&temp);
          if(temp>=0)
          {
            if(insere(dicionario,temp)< 0)//valor nao existe
                retira(dicionario,temp);//valor ja existe
           }

      }while(temp>=0);
}

int main()
{
    TDicionario *dicionario;
    TChave temp;
    int i;

    dicionario = inicia();

      do{
          scanf("%d",&temp);
          if(temp>=0)
            insere(dicionario,temp);

      }while(temp>=0);


       leituraDeDados(dicionario);

      for(i=0;i<dicionario->n;i++)
        printf("%d ",dicionario->item[i].chave);

 return 0;
}