package exer1;

import java.util.*;

public class Vetor {

	public static int[] getVetor(int tamVetor) {
		Scanner ler = new Scanner(System.in);
		int i =0;

		int[] vetor = new int[tamVetor];
		//for (int i = 0; i < vetor.length; i++) {
		do {
			vetor[i] = ler.nextInt();
			ler.nextLine();
			i++;
		}while(vetor[i-1]!=0);
		ler.close();
		return vetor;
	}
	
	public static void imprime(int vetor[]) {
		
		for (int i = 0; i <3/*< vetor.length*/; i++) {
			System.out.println(vetor[retornaMenorPositivo(vetor)]);
		}
		
		
	}
	
	

	private static int retornaMenorPositivo(int vetor[]) {
		int menorPos = 0,aux;
		for (int i = 1; i < vetor.length; i++) {
			if (vetor[i] < vetor[menorPos]&&vetor[i]>0)
				menorPos = i;
		}
		aux=vetor[menorPos];
		vetor[menorPos]=-1;
		return aux;

	}
}
