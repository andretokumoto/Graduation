#include <stdio.h>
#include <stdlib.h>
int main ()
{
   int cont,i=0,base,exp,aux,resp=0;

   printf ("\nPrograma que calcula a potencia apenas com somas\n\n\n");


      do{
      printf ("Entre com a base:\n");
      scanf ("%d",&base);
        }while(base<0);

      do{
        printf ("\nentre com o expoente:\n");
        scanf("%d",&exp);
      }while(exp<0);


      aux=base;
       if (exp==0)
       {
       resp=1;
       }
       else if (exp==1)
       {
         resp=base;
       }
       else
       {
           while(i<(exp-1))
           {
             resp=0;
               for (cont=0; cont<base; cont++)
               {
                resp=resp+aux;
               }
            aux=resp;
            i=i+1;
           }
        }
        printf ("\nO resultado da Potencia e igual a %d\n",resp);
return 0;
}