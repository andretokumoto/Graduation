#include <stdio.h>
#include <stdlib.h>


//*************************TAD********************************************************************************************************************************************************************

typedef struct//estrutura de usuario
{
  int totalReservas;
  int totalRetiradas;
  int tamanho_lista;
  int ultimo;
  int listaRervas[10];
}TipoUsuario;

void inicializa_usuario(TipoUsuario *usuario)//inicializa o cadastro
{
  int i;

  usuario->totalReservas=0;
  usuario->totalRetiradas=0;
  usuario->tamanho_lista=0;
  usuario->ultimo=-1;
  for(i=0;i<10;i++)//zera a lista
     usuario->listaRervas[i]=0;

}

int busca_valor(TipoUsuario *usuario,int livro)//realiza operaçao de busca na lista
{
    int i;
    for(i=0;i<10;i++)//percorre a lista procurando o livro
    {
      if(usuario->listaRervas[i]==livro)//se encontrar retorna a posição na lista
         return i;
    }
    return (-1);//se nao encontrar
}


void reserva_livro(TipoUsuario *usuario,int livro)//realiza operaçao de reserva de livros
{
   usuario->listaRervas[usuario->ultimo+1]=livro;//adiciona nova reseerva no fim da lista
   usuario->ultimo+=1;//atualiza a ultima posiçao
   usuario->totalReservas++;//atualiza total de reservas
   usuario->tamanho_lista++;//atualiza tamanho da lista
   printf("Sua reserva foi realizada\n");
}

void retirada_livro(TipoUsuario *usuario,int posicao)
{
    int i;
    for(i=posicao;i<10;i++)
        usuario->listaRervas[i]=usuario->listaRervas[i+1];

    usuario->listaRervas[usuario->ultimo]=0;
    usuario->ultimo--;
    usuario->totalRetiradas++;
    usuario->tamanho_lista--;

    printf("O livro foi retirado com sucesso\n");
}



//***************************************************************************************************************************************************************************************



int main()
{
  int qtdEntradas,opcao,livro,i,aux;
  TipoUsuario aluno;

  inicializa_usuario(&aluno);

  scanf("%d",&qtdEntradas);//quantidade de entradas da execução

    for(i=0;i<qtdEntradas;i++)//realiza numero de operaçoes solicitadas
    {
       scanf("%d %d",&opcao,&livro);//seleciona a opçao de manipulaçao e o numero do livro

          switch(opcao)//chama a operação solicitada
          {
            case 1://reserva livro
               if(aluno.tamanho_lista==10)
                 printf("Lista de reserva cheia\n");
               else
                 reserva_livro(&aluno,livro);
            break;

            case 2://retirada de livro
                aux=busca_valor(&aluno,livro);//busca posiçao do livro na lista
                if(aux==-1)//nao tem livro na lista
                    printf("Voce nao possui reserva desse livro\n");
                else//tem o livro na lista
                    retirada_livro(&aluno,aux);
            break;

          }
    }
    printf("Voce realizou %d reservas e %d retiradas\n",aluno.totalReservas,aluno.totalRetiradas);


 return 0;
}