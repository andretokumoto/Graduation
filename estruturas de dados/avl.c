#include <stdio.h>
#include <stdlib.h>

//implementação de arvore AVL

typedef struct
{
    int chave;
}TItem;


typedef struct no
{
  TItem elemento;
  struct no *esq,*dir;
  int fb;

}Tno;

int altura(Tno *no)//retorna altura da sub-arvore
{
    int Hesq,Hdir;

    if(no==NULL)
        return 0;
    else
    {
         Hesq = altura(no->esq);
         Hdir = altura(no->dir);

         if(Hesq>Hdir)
            return(Hesq+1);
         else
            return(Hdir+1);
    }
}


int calculaFB(Tno *no)//calcula fator de balanceamento de um nó
{
    if(no!=NULL)
    {
       return (altura(no->esq)-altura(no->dir));
    }
    else
        return 0;

}


void rotacaoLL(Tno **raiz)//faz a rotação para a direita
{
   Tno* no;
   no = (*raiz)->esq;
   (*raiz)->esq = no->dir;
   no->dir = (*raiz);
   (*raiz)->fb = calculaFB((*raiz));//atualiza fator de balanceamento
   (*raiz) = no;
   (*raiz)->fb = calculaFB((*raiz));//atualiza fator de balanceamento
}

void rotacaoRR(Tno **raiz)//faz a rotação para a esquerda
{
   Tno* no;
   no = (*raiz)->dir;
   (*raiz)->dir = no->esq;
   no->esq = (*raiz);
   (*raiz)->fb = calculaFB((*raiz));//atualiza fator de balanceamento
   (*raiz) = no;
   (*raiz)->fb=calculaFB((*raiz));//atualiza fator de balanceamento
}

void rotacaoLR(Tno **raiz) //rotação dupla esquerda-direita
{
      Tno *pb,*pc;
      pb = (*raiz)->esq;
      pc = pb->dir;
      pb->dir = pc->esq;
      pc->esq = pb;
      (*raiz)->esq = pc->dir;
      pc->dir = *raiz;
      (*raiz)->fb = calculaFB((*raiz));//atualiza fator de balanceamento
      pb->fb = calculaFB(pb);//atualiza fator de balanceamento
      pc->fb = calculaFB(pc);//atualiza fator de balanceamento
      *raiz=pc;
}

void rotacaoRL(Tno **raiz)//rotação dupla direita-esquerda
{
      Tno *pb,*pc;
      pb = (*raiz)->dir;
      pc = pb->esq;
      pb->esq = pc->dir;
      pc->dir = pb;
      (*raiz)->dir = pc->esq;
      pc->esq = *raiz;
      (*raiz)->fb = calculaFB((*raiz));//atualiza fator de balanceamento
      pb->fb = calculaFB(pb);//atualiza fator de balanceamento
      pc->fb = calculaFB(pc);//atualiza fator de balanceamento
      *raiz=pc;
}

Tno* novoNO(int valor)//cria novo no e inicializa valores
{
    Tno* no;
    no = (Tno*)malloc(sizeof(Tno));

    no->dir=NULL;
    no->esq=NULL;
    no->elemento.chave=valor;
    no->fb=0;

 return no;
}


void insersao(Tno **no,int valor)
{


       if(valor < (*no)->elemento.chave)//insersao a esquerda
       {

            if((*no)->esq == NULL)
                (*no)->esq = novoNO(valor);
            else
                insersao(&(*no)->esq,valor);
       }
       else if(valor > (*no)->elemento.chave)//insersão a direita
       {

             if((*no)->dir== NULL)
                (*no)->dir = novoNO(valor);
             else
                insersao(&(*no)->dir,valor);
       }
       else
         return;//elemento ja existe na arvore

       (*no)->fb = calculaFB(*no);//atualiza fator de balanceamento

       if((*no)->fb >= 2)
        {

            if((*no)->esq->fb > 0)//desbalanceada para a esquerda com pai e filho com mesmo sinal
                rotacaoLL(&(*no));
          else
                rotacaoLR(&(*no));//desbalanceada para a esquerda com pai e filho com sinais diferentes

        }
        else if((*no)->fb <= -2)
        {

            if((*no)->dir->fb < 0)//desbalanceada para a direita com pai e filho com mesmo sinal
                rotacaoRR(&(*no));
           else
               rotacaoRL(&(*no));//desbalanceada para a direita com pai e filho com sinais diferentes
        }

}



Tno* menorDireita(Tno **no)//acha o menor elemento da sub arvore da direita
{
   if(*no != NULL)
   {
     if( (*no)->esq != NULL )
         return menorDireita(&(*no)->esq);
     else
     {
        Tno *aux = *no;
        if((*no)->dir != NULL)
        {
            *no = (*no)->dir;
            aux->dir=NULL;
        }
        else
          *no = NULL;

        return aux;
     }
   }

}



/*int removeAVL(Tno **raiz,int valor)
{

    if(*raiz == NULL)
        return 0;
    else
    {
        if((*raiz)->elemento.chave < valor )
        {
            removeAVL(&(*raiz)->dir,valor);
        }
        else if((*raiz)->elemento.chave > valor )
        {
            removeAVL(&(*raiz)->esq,valor);
        }
        else if((*raiz)->elemento.chave == valor )
        {
            if((*raiz)->dir==NULL)
            {
                if((*raiz)->esq==NULL)//sem filhos
                {
                   Tno *aux = (*raiz);
                   (*raiz) = NULL;
                   free(aux);
                }
                else//com filho esquerdo
                {
                    Tno *aux = *raiz;
                    *raiz = (*raiz)->esq;
                    free(aux);
                }
            }
            else if((*raiz)->esq==NULL) //apenas filho direito
            {
                    Tno *aux = *raiz;
                    *raiz = (*raiz)->dir;
                    free(aux);
            }
            else//tem dois filhos
            {
               Tno* min = menorDireita(&(*raiz)->dir);
               (*raiz)->elemento.chave = min->elemento.chave;
               free(min);
            }

          return 1;
        }


        if(*raiz!=NULL)
          (*raiz)->fb = calculaFB(*raiz);

        if((*raiz)->fb >= 2)
        {

            if((*raiz)->esq->fb > 0)//desbalanceada para a esquerda com pai e filho com mesmo sinal
                rotacaoLL(&(*raiz));
            else
                rotacaoLR(&(*raiz));//desbalanceada para a esquerda com pai e filho com sinais diferentes

        }
        else if((*raiz)->fb <= -2)
        {

            if((*raiz)->dir->fb < 0)//desbalanceada para a direita com pai e filho com mesmo sinal
                rotacaoRR(&(*raiz));
            else
               rotacaoRL(&(*raiz));//desbalanceada para a direita com pai e filho com sinais diferentes
        }
  return 0;
  }
}*/

int removeAVL(Tno **raiz,int info)
{
    Tno *temp;
    if (*raiz==NULL)
        return 0;
    else if ((*raiz)->elemento.chave > info)
        removeAVL(&(*raiz)->esq, info);

    else if ((*raiz)->elemento.chave < info)
        removeAVL(&(*raiz)->dir, info);

    else
    {
        if (((*raiz)->esq != NULL) && ((*raiz)->dir!=NULL))
        {
            temp = menorDireita(&(*raiz)->dir);
            (*raiz)->elemento.chave = temp->elemento.chave;
            free(temp);
        }
        else if ((*raiz)->esq != NULL && (*raiz)->dir==NULL)
        {
            temp = *raiz;
            *raiz = (*raiz)->esq;
            free(temp);
        }
        else if ( (*raiz)->dir!=NULL && (*raiz)->esq == NULL)
        {
            temp = *raiz;
            *raiz = (*raiz)->dir;
            free(temp);
        }
        else
        {
             temp = *raiz;
             *raiz =NULL;
            free(temp);
        }
        return 1;
    }


        (*raiz)->fb = calculaFB(*raiz);

        if((*raiz)->fb >= 2)
        {

            if((*raiz)->esq->fb > 0)//desbalanceada para a esquerda com pai e filho com mesmo sinal
                rotacaoLL(&(*raiz));
            else
                rotacaoLR(&(*raiz));//desbalanceada para a esquerda com pai e filho com sinais diferentes

        }
        else if((*raiz)->fb <= -2)
        {

            if((*raiz)->dir->fb < 0)//desbalanceada para a direita com pai e filho com mesmo sinal
                rotacaoRR(&(*raiz));
            else
               rotacaoRL(&(*raiz));//desbalanceada para a direita com pai e filho com sinais diferentes
        }
 return 1;
}


void imprime_preOrdem(Tno* raiz)
{
    if(raiz!=NULL)
    {
      printf("%d ",raiz->elemento.chave);
      imprime_preOrdem(raiz->esq);
      imprime_preOrdem(raiz->dir);
    }
}


int main()
{
  Tno* raiz;
  raiz=NULL;
  int valor,aux[100000];
  int i,j;

  //primeira leitura
  do{
      scanf("%d",&valor);
      if(valor>0)
      {
          if(raiz==NULL)
            raiz=novoNO(valor);
          else
          {
              insersao(&raiz,valor);
          }
      }
  }while(valor>0);


  //segunda leitura
  i=0;
   do{
      scanf("%d",&valor);
      if(valor>0)
      {
          aux[i]=valor;
          i++;
      }
  }while(valor>0);


  imprime_preOrdem(raiz);
  printf("\n%d\n",altura(raiz)-1);

  for(j=0;j<=i;j++)
    removeAVL(&raiz,aux[j]);

  imprime_preOrdem(raiz);
   printf("\n%d",altura(raiz)-1);



 return 0;
}