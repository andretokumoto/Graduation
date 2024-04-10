package Exer2;

public class VetorDouble
{
	
  public static double media(double vetor[]) {
	  double media=0;
	  int i;
	  for(i=0;i<vetor.length;i++)
	       media+=vetor[i];
	  return media/vetor.length;
  }
	

}
