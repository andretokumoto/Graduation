#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void expressao(int entradas[])
{
    int j, cont = 0, n1 = 0;
    char parcial[1000];

    for(j=0; j<8; j++)
    {
        if(entradas[j] == 1)
            n1++;
    }

    for(j=0; j<8; j++)
    {
        if(entradas[j]==1)
        {

            if(j==0)
            {
                if(n1 == 1)
                    strcat(parcial,"[(P NAND Q NAND R) NAND (P NAND Q NAND R)]");
                else
                    strcat(parcial,"[(P NAND Q NAND R)]");

                cont++;
            }

            else if (j==1)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[(P NAND Q NAND (R NAND R)) NAND (P NAND Q NAND (R NAND R))]");
                else
                    strcat(parcial,"[(P NAND Q NAND (R NAND R))]");
                cont++;
            }

            else if (j==2)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[(P NAND (Q NAND Q) NAND R) NAND (P NAND (Q NAND Q) NAND R)]");
                else
                    strcat(parcial,"[(P NAND (Q NAND Q) NAND R)]");

                cont++;
            }

            else if (j==3)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[(P NAND (Q NAND Q) NAND (R NAND R)) NAND (P NAND (Q NAND Q) NAND (R NAND R))]");
                else
                    strcat(parcial,"[(P NAND (Q NAND Q) NAND (R NAND R))]");

                cont++;
            }

            else if (j==4)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[((P NAND P) NAND Q NAND R)  NAND ((P NAND P) NAND Q NAND R)]");
                else
                    strcat(parcial,"[((P NAND P) NAND Q NAND R)]");

                cont++;
            }

            else if (j==5)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[((P NAND P) NAND Q (R NAND R))  NAND ((P NAND P) NAND Q (R NAND R))]");
                else
                    strcat(parcial,"[((P NAND P) NAND Q (R NAND R))]");
                cont++;
            }

            else if (j==6)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[((P NAND P) NAND (Q NAND Q) NAND R)  NAND ((P NAND P) NAND (Q NAND Q) NAND R)]");
                else
                    strcat(parcial,"[((P NAND P) NAND (Q NAND Q) NAND R)]");

                cont++;
            }

            else if (j==7)
            {
                if(cont > 0)
                {
                    strcat(parcial, " NAND ");
                }

                if(n1 == 1)
                    strcat(parcial,"[((P NAND P) NAND (Q NAND Q) NAND (R NAND R))  NAND ((P NAND P) NAND (Q NAND Q) NAND (R NAND R))]");
                else
                    strcat(parcial,"[((P NAND P) NAND (Q NAND Q) NAND (R NAND R))]");
                cont++;
            }

        }
    }
    puts(parcial);
}


int main()
{
    int entradas[8];
    int i;

    for(i=0; i<8; i++)
    {
        printf("entre com a linha %d: ",i+1);
        scanf("%d",&entradas[i]);
    }

    expressao(entradas);


    return 0;
}