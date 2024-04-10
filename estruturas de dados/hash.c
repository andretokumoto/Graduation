#include <stdio.h>
#include <stdlib.h>

//André Filipe Siqueira Tokumoto
//implementação do algoritmo de tabela hash

typedef struct celula
{
    int dado;
    struct celula *prox;
}Tdado;

typedef struct
{
   Tdado *primeiro,*ultimo;
}Thash;



int divisao(int chave,int m)//retorna indice
{
  return chave%m;
}


int pesquisa(int chave,int m,Thash* tabela)//procura um determinado valor na tabela
{
   int indice = divisao(chave,m);
   Tdado *aux = tabela[indice].primeiro ;


   while(aux!=NULL)//percorre a lista procurando elemento
   {
       if(aux->dado==chave)
         return 1;//achou valor
       else
         aux = aux->prox;
   }
   return 0;//nao achou valor

}

Tdado *novoElemento(int chave)//aloca novo elemento
{
    Tdado *novo = (Tdado*)malloc(sizeof(Tdado));
    novo->prox=NULL;
    novo->dado=chave;
  return novo;
}

void insersao(int dado,int m, Thash* tabela)//insere novo valor no hash
{

    int indice = divisao(dado,m);
    Tdado* aux ;

    if(tabela[indice].primeiro==NULL)//a lista esta vazia
    {
       tabela[indice].primeiro = novoElemento(dado);
       tabela[indice].ultimo = tabela[indice].primeiro;
    }
    else//lista não vazia
    {
       tabela[indice].ultimo->prox = novoElemento(dado);
       tabela[indice].ultimo = tabela[indice].ultimo->prox;
    }

}

void remocao(int chave,int m, Thash* tabela)//remove valor da tabela
{
   int indice = divisao(chave,m),flag=0;
   Tdado *aux = tabela[indice].primeiro, *del;

   if(aux->dado == chave)//elemento eh o primeiro
   {
      tabela[indice].primeiro = tabela[indice].primeiro->prox;
      del = aux;
   }
   else
   {
       while(flag==0)//procura o dado a ser removido
       {
           if(aux->prox->dado == chave)//achou valor
           {
              del = aux->prox;

              if(del == tabela[indice].ultimo)//se valor eh ultimo
                 tabela[indice].ultimo=aux;

                aux->prox = del->prox;
                flag++;
           }
           else
             aux = aux->prox;
       }
   }
   free(del);//libera memoria
}


void imprime(int m, Thash* tabela)//imprime valores da tabela por indice
{
    int i;
    Tdado *aux;

    for(i=0;i<m;i++)
    {
       printf("[%d]",i);
       aux = tabela[i].primeiro;

       while(aux!=NULL)
       {
           printf(" %d",aux->dado);
           aux = aux->prox;
       }
       printf("\n");
    }
}

void inicializa(Thash* tabela,int m)//inicializa campos da tabela
{
   int i;
   for(i=0;i<m;i++)
   {
       tabela[i].primeiro=NULL;
       tabela[i].ultimo=NULL;
   }
}

int main()
{
  int m,qtd,valor,i;
  Thash* tabela;

  scanf("%d",&m);
  tabela = (Thash*)malloc(m*sizeof(Thash));//cria a tabela hash
  inicializa(tabela,m);

  scanf("%d",&qtd);

  for(i=0;i<qtd;i++)//insere valores
  {
      scanf("%d",&valor);
      insersao(valor,m,tabela);
  }
  scanf("%d",&valor);

  if(pesquisa(valor,m,tabela)== 0)//se valor nao existe na tabela ele eh inserido
    insersao(valor,m,tabela);
  else//se ja existir eh removido
    remocao(valor,m,tabela);

  imprime(m,tabela);

 return 0;
}