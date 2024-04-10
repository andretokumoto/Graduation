package TAD;

public class Pilha extends Lista {
	
	
	public Pilha() {
		
	}
	
	public void empilha(int dado)
	{
		insereInicio(dado);
	}
	
	public int desempilha(){
		return retiraPrimeiro();
	}
	
	public int mostraTopo()
	{
		int aux;
		aux=getPrimeiro();
		return getElemento(aux);
	}
	
	

}
