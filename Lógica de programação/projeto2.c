#include <stdio.h>
#include <stdlib.h>

int main()
{
   int n, i, cont=0, c, aux=0, vet[100];

   do{
     scanf("%d",&n);
        for (i=0;i<=n-1;i++)
        {
         scanf("%d",&vet[i]);
        }
     }while (n>100 || n<1);

        while(cont<(n-1))
        {
          aux=vet[0];
           for(c=0;c<n-1;c++)
            {
             if (vet[c]>vet[c+1])
              {
                aux=vet[c];
                vet[c]=vet[c+1];
                vet[c+1]=aux;
              }
            }
          cont++;
        }
          for (i=0;i<=n-1;i++)
           {
            printf("%d ",vet[i]);
           }
    return 0;
}
