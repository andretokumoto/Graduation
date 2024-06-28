#include <stdio.h>
#include <stdlib.h>
#define TAMALUNO 2
#define TAMLIVRO 2

typedef struct aluno {int ra;int idade;char nome[] } aluno;

typedef struct livro{int codlivro;char titulo[];} livro;

void cadAluno(aluno *a)
{
int i;

  for(i=0;i<TAMALUNO;i++)
  {
    scanf("%d %s %d",*a.ra,*a.nome,*a.idade);
  }
}

void cadLivro()
{

}

int main(void)
{
  int n;
  aluno a[TAMALUNO];
  livro l[TAMLIVRO];
  cadAluno(*a);

 //return 0;
}