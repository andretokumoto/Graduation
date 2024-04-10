package TAD;

public class Elemento {
	private int dado;
	private int proximo,anterior;

	public int getDado() {
		return dado;
	}

	public int getAnterior() {
		return anterior;
	}

	public void setAnterior(int anterior) {
		 // if(anterior>=0)
		     this.anterior = anterior;
	}

	public void setDado(int dado) {
		this.dado = dado;
	}

	public int getProximo() {
		return proximo;
	}

	public void setProximo(int proximo) {
	  // if(proximo>=0)
		this.proximo = proximo;
	}

}
