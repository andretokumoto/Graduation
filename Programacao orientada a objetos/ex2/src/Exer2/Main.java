package Exer2;
import java.util.*;
import javax.swing.*;

public class Main {
	
   public static void main(String args[]) {
		
	    double[] vet = new double[6];
	    Scanner ler = new Scanner(System.in);
	  
		for(int i=0;i<6;i++) {
			
			vet[i] = ler.nextDouble();
		}
	
		
		System.out.println(VetorDouble.media(vet));
		

   }
	
	
}
