#include <stdio.h>
#include <stdlib.h>

typedef struct listaES
{
  int ultimo;
  int tamanhoLista;
  int lista[5];
}tipolista;


void inicializaLista(tipolista *listaAux)
{
 int i;
  //zera a lista
  listaAux->tamanhoLista=0;
  for(i=0;i<5;i++)
   listaAux->lista[i]=0;

 //inicializa ultimo
 listaAux->ultimo=0;

}

void insereElemento(tipolista *listaAux)
{
 int i;

  //for(i=0;i<5;i++)
  // {
     //atualiza tamanho
     listaAux->tamanhoLista++;
     //insere na ultima posição
     scanf("%d",&listaAux->lista[listaAux->tamanhoLista-1]);
     //atualiza ultimo
    listaAux->ultimo=listaAux->tamanhoLista-1;
//   }
}

void removeElemento(tipolista *listaAux,int id)
{
  int i;
  for(i=id;i<listaAux->ultimo;i++)
    {
      listaAux->lista[i]=listaAux->lista[i+1];
    }
    listaAux->ultimo--;
    listaAux->tamanhoLista--;

}

void mostraLista(tipolista *listaAux)
{
  int i;
  for(i=0;i<listaAux->tamanhoLista-1;i++)
    printf("%d ",listaAux->lista[i]);

  printf("\nultimo :%d\n",listaAux->ultimo);

}



int main()
{

 int id;
 char op='i';
 tipolista minhaLista;



 while(op!='s')
 {
   printf("DIGITE:\na : inicializa lista\nb : insere elemento\nc:remove elemento\nd : imprime lista\ns : sair\n\n");
   scanf("%c",&op);

   switch(op)
   {

       case 'a':
         inicializaLista(&minhaLista);
       break;

          case 'b':
            insereElemento(&minhaLista);
          break;

              case 'c':
                printf("posicao : ");
                scanf("%d",&id);
                removeElemento(&minhaLista,id);
              break;

                  case 'd':
                     mostraLista(&minhaLista);
                  break;
    }
    printf("\n\n");
 }

 return 0;
}