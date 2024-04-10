#include <stdio.h>
#include <stdlib.h>

//implementação de inserção em arvore rubro-negra
//andré filipe siqueira tokumoto  RA:120188

typedef struct rb
{
    int chave;
    struct rb *esq,*dir;
    char cor;
}Tarn;//estrutura dos nós da arvore RN


void rotacaoDireita(Tarn **raiz)//faz a rotação para a direita
{

   Tarn* no;
   no = (*raiz)->esq;
   (*raiz)->esq = no->dir;
   no->dir = *raiz;
   *raiz = no;
}

void rotacaoEsquerda(Tarn **raiz)//faz a rotação para a esquerda
{
   Tarn* no;
   no = (*raiz)->dir;
   (*raiz)->dir = no->esq;
   no->esq = *raiz;
   *raiz = no;
}


int alturaNegra(Tarn *no)//retorna a altura negra de um dado nó
{
    int He,Hd,black=0;

    if(no==NULL)
        return 0;
    else
    {
       if(no->cor=='N')//nó eh negro
            black=1;

        He = alturaNegra(no->esq);
        Hd = alturaNegra(no->dir);

        if(He>Hd)
           return(He + black);
        else
           return(Hd + black);
    }

}

int arvoreARN(Tarn *raiz,Tarn *no)//verifica se uma árvore é ou não rubro-negra
{
    if(no!=NULL)
    {

      if(raiz->cor=='R')//raiz rubra
        return 0;

      if(no->cor != 'R' && no->cor != 'N') //nó diferente de rubro ou negro
        return 0;

      if(no->cor=='R')//rubro filho de rubro
      {
        if(no->dir!=NULL && no->dir->cor=='R')
            return 0;
        if(no->esq!=NULL && no->esq->cor=='R')
            return 0;
      }
      if(alturaNegra(no->dir) != alturaNegra(no->esq))//altura negra não eh a mesma para todos os nós
         return 0;

      if(arvoreARN(raiz,no->dir) != arvoreARN(raiz,no->esq))
        return 0;
      else
        return 1;

    }
  return 1;
}

void coloracao(Tarn **no)//executa uma coloração em um dado nó
{
  if((*no)!=NULL)
  {
    if((*no)->cor == 'R')
      (*no)->cor = 'N';
    else
      (*no)->cor = 'R';
  }
}


void balanceamentoNO(Tarn **no,Tarn *raizPrincipal)//verifica para o nó , se existe a sequencia de filho e neto rubros e realiza o balanceamento de acordo com o caso

{


     if(*no==NULL)
        return;

    if((*no)->dir!=NULL && (*no)->dir->cor == 'R' )//pai na direita
     {

         if( (*no)->dir->dir!=NULL && (*no)->dir->dir->cor == 'R')//neto dir eh rubro
         {

            if ((*no)->esq==NULL || (*no)->esq->cor == 'N' )//se tio eh negro
            {
                 coloracao(&(*no));
                 coloracao(&(*no)->dir);
                 rotacaoEsquerda(&(*no));
            }
            else if((*no)->esq->cor == 'R' )//se tio eh rubro , coloração de pai tio e alo
            {
                if(*no != raizPrincipal)
                    coloracao(&(*no));
                coloracao(&(*no)->dir);
                coloracao(&(*no)->esq);
            }

         }
         else if((*no)->dir->esq!=NULL &&(*no)->dir->esq->cor == 'R')//neto esq eh rubro
         {

            if ((*no)->esq==NULL || (*no)->esq->cor == 'N' )//se tio eh negro
            {

                 rotacaoDireita(&(*no)->dir);
                 coloracao(&(*no));
                 coloracao(&(*no)->dir);
                 rotacaoEsquerda(&(*no));
            }

            else if((*no)->esq->cor == 'R' )//se tio eh rubro , coloração de pai tio e alo
            {
                if(*no != raizPrincipal)
                    coloracao(&(*no));
                coloracao(&(*no)->dir);
                coloracao(&(*no)->esq);
            }

         }
     }


     if((*no)->esq!=NULL && (*no)->esq->cor == 'R' )//pai na esquerda
     {
         if((*no)->esq->dir!=NULL && (*no)->esq->dir->cor == 'R')//elemento inserido esta na esq e eh rubro
         {
            if ((*no)->dir==NULL || (*no)->dir->cor == 'N' )//se tio eh negro
            {

                 rotacaoEsquerda(&(*no)->esq);
                 coloracao(&(*no));
                 coloracao(&(*no)->esq);
                 rotacaoDireita(&(*no));
            }
            else if((*no)->dir->cor == 'R' )//se tio eh rubro , coloração de pai tio e alo
            {
                if(*no != raizPrincipal)
                    coloracao(&(*no));

                coloracao(&(*no)->dir);
                coloracao(&(*no)->esq);
            }

         }
         else if((*no)->esq->esq!=NULL && (*no)->esq->esq->cor == 'R')//elemento inserido esta na esq e eh rubro         {
         {

            if ((*no)->dir==NULL || (*no)->dir->cor == 'N' )//se tio eh negro
            {
                 coloracao(&(*no));
                 coloracao(&(*no)->esq);
                 rotacaoDireita(&(*no));
            }

            else if((*no)->dir->cor == 'R' )//se tio eh rubro , coloração de pai tio e alo
            {
                if(*no != raizPrincipal)
                    coloracao(&(*no));
                coloracao(&(*no)->dir);
                coloracao(&(*no)->esq);
            }

         }

     }
}

/*int balancaNo(Tarn *arv)
{
  if(arv==NULL)
    return 0;

  if(arv->esq->cor == 'R') // se A for rubro e esquerdo
  {
        if(arv->dir->cor == 'N' || arv->dir==NULL ) // se D for negro
        {
            if(arv->esq->dir->cor == 1) // caso 2a
            {
              rotacaoEsquerda(&arv->esq);
              coloracao(&arv->esq);
              coloracao(&arv);
              rotacaoDireita(&arv);
            }
            else if(arv->esq->esq->cor == 'R')// caso 3a
            {
              rotacaoDireita(&arv);
              coloracao(&arv->esq);     // troca cor do pai
              coloracao(&arv);          // troca cor do avo
            }
        }
        else if(arv->dir->cor == 'R' && (arv->esq->cor=='R' || arv->esq->dir=='R')) // D é rubro, caso 1
        {
            coloracao(&arv->esq); // muda a cor do pai
            coloracao(&arv);      // muda cor do avo
            coloracao(&arv->dir); // muda a cor do tio
        }
  } // final do A ser filho esquerdo
  else if(arv->dir->cor == 'R') // se A for rubro e direito
  {
      if(arv->esq->cor == 1 && (arv->dir->cor==1 || arv->dir->dir==1)) // D é rubro, caso 1
      {
          coloracao(&arv->dir); // troca a cor do pai
          coloracao(&arv);      // troca a cor do avo
          coloracao(&arv->esq); // troca a cor do tio
      }
      else if(arv->esq->cor == 'N') // D é negro
      {
          if(arv->dir->esq->cor == 'R')          // caso 2b
          {
              rotacaoDireita(&arv->dir);
              coloracao(&arv->esq);
              coloracao(&arv);
              rotacaoEsquerda(&arv);

          }
          else if(arv->dir->dir->cor == 'R')     // caso 3b
          {
              rotacaoEsquerda(&arv);
              coloracao(&arv->dir);   // troca a cor do pai
              coloracao(&arv);         // troca a cor do avo
          }
      }
  }
        return 1;
}*/

Tarn *novoNO(int valor)//cria um novo elemento e inicializa os valores
{
    Tarn *novo;

    do{
       novo = (Tarn*)malloc(sizeof(Tarn));
      }while(novo==NULL);

    novo->chave = valor;
    novo->dir=NULL;
    novo->esq=NULL;
    novo->cor = 'R';

  return novo;
}

void insersaoARN(Tarn **no,Tarn *raizPrincipal,int valor)
{

      if(valor < (*no)->chave)//insersao a esquerda
       {

            if((*no)->esq == NULL)
                (*no)->esq = novoNO(valor);
            else
                insersaoARN(&(*no)->esq,raizPrincipal,valor);
       }
       else if(valor > (*no)->chave)//insersão a direita
       {

             if((*no)->dir== NULL)
                (*no)->dir = novoNO(valor);
             else
                insersaoARN(&(*no)->dir,raizPrincipal,valor);
       }
       else
         return;//elemento ja existe na arvore


      if(arvoreARN(raizPrincipal,raizPrincipal) == 0)//chama a função de balanceamento caso necessario
         balanceamentoNO(&(*no),raizPrincipal);

}

void imprime(Tarn* raiz)//imprime a raiz em pre ordem, utilizando a representação de parenteses alinhados
{
    printf("(");
    if(raiz!=NULL)
    {
      printf("%c%d",raiz->cor,raiz->chave);
      imprime(raiz->esq);
      imprime(raiz->dir);
    }
    printf(")");
}

int main()
{
   Tarn *raiz=NULL;
   int valor,n,i;

   scanf("%d",&n);//numero de elementos a serem inseridos
   for(i=0;i<n;i++)
   {
      scanf("%d",&valor);
      if(raiz==NULL)//inserção da raiz
      {
          raiz=novoNO(valor);
          coloracao(&raiz);
      }
      else
        insersaoARN(&raiz,raiz,valor);//inserção dos demais elementos
   }

   printf("%d\n",alturaNegra(raiz));
   imprime(raiz);


 return 0;
}