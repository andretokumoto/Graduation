#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
  char pe[100];
  int num[100],n,i,j,pares=0;

  do{
     printf("Entre com o numero de botas : ");
     scanf("%d",&n);
    }while(n<1 || n>100);

       for(i=0;i<n;i++)
       {
        // do
        // {
          printf("Entre com o numero do sapato e qual eh o pe(d\e): ");
          scanf("%d %c",&num[i],&pe[i]);
       //  }while(pe[i]!='d');

       }

      for(i=0;i<n;i++)
       {
          for(j=1;j<n;j++)
          {
          // printf("%c%c ",pe[i],pe[j]);

           if(num[i]==num[j] )

            {
              if(pe[i]!=pe[j])
              {
                num[j]=0;
                pares++;
              }

            }

          }
       }

        printf("sao possiveis %d pares",pares);
        
    return 0;
}