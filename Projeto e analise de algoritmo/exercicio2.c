/*
Entrada:
A primeira linha de um caso de teste contém os inteiros V (1 ≤ V ≤ 10.000), indicando o número
de eleitores votantes, e C, indicando o número de candidatos (1 ≤ C ≤ 100). Nas próximas V linhas, são
apresentados os votos de cada eleitor votante. Em cada uma dessas linhas, são fornecidos 3 inteiros com as
escolhas, em ordem de preferência, de um eleitor.

Saída:
Caso não haja nenhum voto válido em primeira opção, imprima apenas o número 0. Caso
contrário, o seu programa deve imprimir na primeira linha da saída o número do candidato vencedor do
primeiro turno e a porcentagem de votos com 2 dígitos de precisão, separados por um espaço em branco.
Caso o vencedor do primeiro turno tenha vencido com menos de 50% dos votos válidos, você deve
imprimir na segunda linha o número do vencedor do segundo turno e sua porcentagem de votos com 2
dígitos de precisão, separados por um espaço em branco. Para os cálculos da porcentagem, deve-se
considerar apenas os votos válidos.
*/

#include <stdio.h>
#include <stdlib.h>


int maior(int v[100],int c,int segundoT)//acha o canditado com maior votação no vetor
{
    int max,indice,i;

     if(segundoT != 0)
     {
      max = v[0];
      indice = 0;
     }
     else
     {
      max= v[1];
      indice = 1;
     }


    for(i=1;i<c;i++)//procura o maior valor da tabela
    {
      if(i!=segundoT)
      {
        if(v[i]>max)
        {
            max = v[i];
            indice = i;
        }
      }
    }
    return indice;
}


int segundoturno(int votos[10000][3],int v,int c1,int c2,int vc1,int vc2)
{
   int i;
   float porcentagem,validos;
   validos= 0.0;
   porcentagem = 0.0;

   for(i=0;i<v;i++)//conta os votos em em segunda e terceira opçoes
   {
       if(votos[i][0]!= c1 && votos[i][0]!= c2)
       {
           if(votos[i][1]== c1)
           {
               vc1++;
               validos++;
           }
           else if(votos[i][1]== c2)
           {
               vc2++;
               validos++;
           }
           else if(votos[i][2]== c1)
           {
               vc1++;
               validos++;
           }
           else if(votos[i][2]== c2)
           {
               vc2++;
               validos++;
           }
       }
       else//soma como votos validos os votos em um dos dois candidatos coo primeira opção
         validos++;
   }

   if(vc1>vc2)//condidato 1 teve mais votos
   {
       porcentagem = (vc1/validos)*100;
       printf("\n%d %.2f",c1,porcentagem);
   }
   else if(vc1<vc2)//condidato 2 teve mais votos
   {
       porcentagem = (vc2/validos)*100;
       printf("\n%d %.2f",c2,porcentagem);
   }
   else//empate em numero de votos
   {
       if(c1<c2)//condidato mais velho vence
       {
          porcentagem = (vc1/validos)*100;
          printf("\n%d %.2f",c1,porcentagem);
       }
       else
       {
         porcentagem = (vc2/validos)*100;
         printf("\n%d %.2f",c2,porcentagem);
       }

   }
}

int main()
{
  int v,c,voto[3],c1,c2,i;
  float porcentagem,validos;
  int votosTotais[100];
  int votosEleitores[10000][3];

  scanf("%d",&v);
  scanf("%d",&c);
  validos = 0.0;
  porcentagem=0;

  for(i=0;i<c;i++)//zera todos os valores da tabela de votos no primeiro turno
  {
      votosTotais[i]=0.0;
  }

  for(i=0; i<v ;i++)
  {
      scanf("%d",&voto[0]);
      scanf("%d",&voto[1]);
      scanf("%d",&voto[2]);

      if(voto[0]>=1 && voto[0]<=c)//apenas se o voto eh valido ele conta como voto validos e soma na tabela de votos do primeiro turno
      {
         validos++;
         votosTotais[(voto[0]-1)]++;//votos do primeiro turno
      }
         votosEleitores[i][0]=voto[0];
         votosEleitores[i][1]=voto[1];
         votosEleitores[i][2]=voto[2];
  }

  c1 = maior(votosTotais,c,-1);//procura o primeiro colocado
  c2 = maior(votosTotais,c,c1);//procura o segundo colocado


  if(validos==0)//sem votos valids
    printf("0");
  else
  {
     porcentagem = (votosTotais[c1] / validos)*100;
     printf("%d %.2f",c1+1,porcentagem);

     if(porcentagem<50)//necssidade de segundo turno
     {
      segundoturno(votosEleitores,v,c1+1,c2+1,votosTotais[c1],votosTotais[c2]);
     }
  }
  return 0;
}