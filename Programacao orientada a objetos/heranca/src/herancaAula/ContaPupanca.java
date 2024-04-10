package herancaAula;

public class ContaPupanca extends Conta{
	
	private int numero;
	private double jurosPoupanca;

	public ContaPupanca(int numero,double saldo) {
		super(numero);
		//super(saldo);
	}
	
	public void setNumero(int numero) {
		
		if(numero>0)
		 this.numero=numero;
	}
	
	public double getJurosPoupanca() {
		return jurosPoupanca;
	}

	public void setJurosPoupanca(double jurosPoupanca) {
		
		if(jurosPoupanca>=0)
		 this.jurosPoupanca = jurosPoupanca;
	}

	public double getNumero() {
		return numero;
	}
	
	public adicionaJuro(double jurosPoupanca) {
		
	}

}
