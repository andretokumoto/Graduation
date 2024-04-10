#include <stdio.h>
#include <stdlib.h>

//*******************************************TAD***********************************************************************************************************************************************************************************************
typedef struct elemento
{
  int id;
  int qtdProduto;
  float lucroProduto;
  float lucroTotal;
  struct elemento *prox;
}tipoProduto;

typedef struct
{
  tipoProduto *primeiro;
  tipoProduto *ultimo;
  int tamanhoLista;
}tipoListaDE;

void inicializa_Lista (tipoListaDE *listaAux)
{

 listaAux->primeiro = NULL;
 listaAux->ultimo = NULL;
 listaAux->tamanhoLista=0;
}

tipoProduto *localiza(tipoListaDE *listaAux,int id)
{

    tipoProduto *anterior,*p;
    anterior=listaAux->primeiro;
    puts("ooooo");
     printf("%d",anterior);
    while(anterior!=NULL)
    {

        p=anterior->prox;

        if(p->id==id)
        {
          return(anterior);
        }

      anterior=anterior->prox;

    }
   return(NULL);

}

tipoProduto *busca_posicao(tipoListaDE *listaAux,float lucro)
{
    tipoProduto *anterior,*p;
    anterior=listaAux->primeiro;
    p=anterior->prox;

    while(anterior->prox!=NULL)
    {
        if(p->lucroProduto<lucro)
            return(anterior);

         anterior=p;
         p=p->prox;
    }
    return listaAux->ultimo;
}


int insere_novo(tipoListaDE *listaAux,int id,int qtdProduto,float lucroProduto)//cadastro de novo produto
{
   tipoProduto *novo,*anterior;


   while(novo==NULL)
   {
    novo=(tipoProduto*)malloc(sizeof(tipoProduto));//alocaçao de memoria para produto
   }
   novo->id=id;
   novo->qtdProduto=qtdProduto;
   novo->lucroTotal=0;
   novo->lucroProduto=lucroProduto;//insersão das informações
   novo->prox=NULL;

     if(listaAux->tamanhoLista==0)//lista vazia
     {
       listaAux->primeiro=novo;
       listaAux->ultimo=novo;
       listaAux->tamanhoLista++;
     }
     else if(id!=listaAux->primeiro->id)//novo nao eh igual ao primeiro produto
     {

        if(localiza(listaAux,id)==NULL)//produto nao dadastrado
        {
          anterior=busca_posicao(listaAux,lucroProduto);

          if(lucroProduto>listaAux->primeiro->lucroProduto)//insersao na primeira posiçao
          {
             novo->prox=listaAux->primeiro;
             listaAux->primeiro=novo;
             listaAux->tamanhoLista++;
          }

          else if(anterior==listaAux->ultimo)//insersao na ultima posicao
          {
              listaAux->ultimo->prox=novo;
              listaAux->ultimo=novo;
              listaAux->tamanhoLista++;
          }
          else//insersao em posicao intermediaria
          {
             novo->prox=anterior->prox;
             anterior->prox=novo;
             listaAux->tamanhoLista++;
          }

        }
        else//produto ja cadastrado
        {
           printf("ja existe\n");
           free(novo);//desalocação da memoria
           return 0;
        }
     }
     else//novo igual a primeiro
     {
           printf("ja existe\n");
           free(novo);
           return 0;
     }

     novo=NULL;
     anterior=NULL;

  return 1;
}

int altera_qtdProduto(tipoListaDE *listaAux,int id,int qtd)
{
  tipoProduto *ant,*prod;

  ant=localiza(listaAux,id);

  if(id==listaAux->primeiro->id)
  {
      listaAux->primeiro->qtdProduto+=qtd;
      listaAux->primeiro->lucroTotal-=listaAux->primeiro->lucroProduto;
      return 1;
  }
  else if(ant==NULL)
  {
      printf("nao existe\n");
      return 0;
  }
  else
  {
      prod=ant->prox;
      prod->qtdProduto+=qtd;
      prod->lucroTotal-=prod->lucroProduto;
      return 1;
  }

return 0;
}

int compra_produto(tipoListaDE *listaAux,int id)
{
    tipoProduto *ant,*prod;

    ant=localiza(listaAux,id);

    if(listaAux->primeiro->id==id)
    {
        listaAux->primeiro->qtdProduto--;
        listaAux->primeiro->lucroTotal+=listaAux->primeiro->lucroProduto;
        return 1;
    }
    else if(ant==NULL)
    {
        printf("nao existe\n");
        return 0;
    }
    else
    {
        prod=ant->prox;
        prod->qtdProduto--;
        prod->lucroTotal+=prod->lucroProduto;
        return 1;
    }
 return;
}


int exclui_produto(tipoListaDE *listaAux,int id)
{

  tipoProduto *ant,*prod;
    //ant=localiza(listaAux,id);


   if(listaAux->primeiro->id==id)
    {
        prod=listaAux->primeiro;
        listaAux->primeiro=prod->prox;
        listaAux->tamanhoLista--;
        free(prod);
        return 1;
    }
     else if(ant==NULL)
    {
        printf("nao existe\n");
        return 0;
    }
    else
    {
        prod=ant->prox;
        ant->prox=prod->prox;
        listaAux->tamanhoLista--;
        if(prod==listaAux->ultimo)
            listaAux->ultimo=ant;

        free(prod);
        return 1;
    }
return 0;
}

//******************************************************************************************************************************************************************************************************************************

void imprime_lista(tipoListaDE *listaAux)
{
    tipoProduto *aux;
    aux=listaAux->primeiro;

    if(listaAux->tamanhoLista>0)
    {
       do{
            printf("%d %f\n",aux->id,aux->lucroTotal);
            aux=aux->prox;

         }while(aux!=NULL);
    }
}


int main()
{
  int id,qtdProd,qtdMovimentacoes,tipoOP,i;
  float lucro;
  tipoListaDE listaProd;

  inicializa_Lista(&listaProd);

  scanf("%d",&qtdMovimentacoes);
  for(i=0;i<qtdMovimentacoes;i++)
  {
     scanf("%d",&tipoOP);

     switch(tipoOP)
     {
       case 1:
           scanf("%d %d %f",&id,&qtdProd,&lucro);
           insere_novo(&listaProd,id,qtdProd,lucro);
       break;

       case 2:
          scanf("&d %d",&id,&qtdProd);
          altera_qtdProduto(&listaProd,id,qtdProd);
       break;

       case 3:
           scanf("%d",&id);
           compra_produto(&listaProd,id);
       break;

       case 4:
             scanf("%d",&id);
             exclui_produto(&listaProd,id);
       break;
     }
  }
 imprime_lista(&listaProd);

printf("%d",listaProd.primeiro);

 return 0;
}