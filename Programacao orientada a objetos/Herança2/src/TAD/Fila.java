package TAD;

public class Fila extends Lista {

	public Fila() {
		
	}
	
	public void insere(int dado) {
		insereFim(dado);
	}
	
	public int retira() {
		return retiraPrimeiro();
	}
	
	public int tamanho() {
		return getTamanho();
	}
	
}
