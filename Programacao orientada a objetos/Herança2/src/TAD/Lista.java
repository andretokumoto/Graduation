package TAD;

public class Lista 
{
    private int tamanho;
	private int primeiro,ultimo;
	Elemento[] listaElementos=new Elemento[10];
	int i;

	public Lista()//metodo contrutor
	{
		this.tamanho=0;
		this.primeiro=-1;
		this.ultimo=-1;
		inicializa();
		/*for(i=0;i<10;i++) {
			//listaElementos[i] = new Elemento();
			listaElementos[i].setDado(-1);
			listaElementos[i].setAnterior(-1);
			listaElementos[i].setProximo(-1);
		}*/
	}
	
	public void inicializa() {
		for(i=0;i<10;i++) {
		//listaElementos[i] = new Elemento();
		listaElementos[i].setDado(-1);
		listaElementos[i].setAnterior(-1);
		listaElementos[i].setProximo(-1);
	    }
	}
	
	public int getPrimeiro() {
		return primeiro;
	}

	public int getElemento(int pos) {
		int aux;
		aux = listaElementos[pos].getDado();
		return aux;
	}



	public void setPrimeiro(int primeiro) {
		this.primeiro = primeiro;
	}

	public int getUltimo() {
		return ultimo;
	}

	public void setUltimo(int ultimo) {
		this.ultimo = ultimo;
	}
	
	 public int getTamanho() {
			return tamanho;
		}
	
	private void atualizaTamanho(int mudanca) {//atualiza tamanho da lista
		tamanho=tamanho+mudanca;
	}
	
	private int localiza(int elementoProcurado) {//busca posicao no vetor onde há o dado passado
		i=primeiro;
		do{
			
			if(listaElementos[i].getDado()==elementoProcurado)
				return i;
			
		}while(i!=ultimo);
		return -1;
	}
	
	public int localizaPosLivre() {//procura posicao no vetor para insersao de dados
		return localiza(-1);
	}
	
	public int localizaElemento(int elemento) {//procura a posicao de um determinado dado
		return localiza(elemento);
	}
	
	public boolean listaCheia() {
		
		if(tamanho==10)
			return true;
		else
		   return false;	
	}
	
    public boolean listaVazia() {
		
		if(tamanho==0)
			return true;
		else
		   return false;	
	}
    
    public void insereInicio(int dado) {
    	int pos;
    	pos=localizaPosLivre();
    	listaElementos[pos].setDado(dado);
    	listaElementos[pos].setAnterior(-1);

    	if(!listaVazia())
    	  listaElementos[pos].setProximo(primeiro);
    	
    	primeiro=pos;
    	atualizaTamanho(1);
    }
    
    public void insereFim(int dado) {
    	int pos;
    	pos=localizaPosLivre();
    	listaElementos[pos].setDado(dado);
    	listaElementos[pos].setAnterior(ultimo);
    	listaElementos[pos].setProximo(-1);
    	ultimo=pos;
    	atualizaTamanho(1);
    }
    
    public void insereMeio(int dado,int anterior) {
    	int pos,prox;
    	pos=localizaPosLivre();
    	listaElementos[pos].setDado(dado);
    	prox=listaElementos[anterior].getProximo();
    	listaElementos[pos].setProximo(prox);
    	listaElementos[prox].setAnterior(pos);
    	listaElementos[pos].setAnterior(anterior);
    	listaElementos[anterior].setProximo(pos);
    	atualizaTamanho(1);
    }
    
   private void elimina(int pos){
	   listaElementos[pos].setDado(-1);
	   listaElementos[pos].setAnterior(-1);
	   listaElementos[pos].setProximo(-1);
   }

   public int retiraMeio(int posElemento)//retira elemento do meio da lista
   {
	    int aux,ant,prox;
	    aux=listaElementos[posElemento].getDado();
	    prox=listaElementos[posElemento].getProximo();
	    ant=listaElementos[posElemento].getAnterior();
	    
	    listaElementos[ant].setProximo(prox);
	    listaElementos[prox].setAnterior(ant);
	    elimina(posElemento);
	    atualizaTamanho(-1);
	  return aux;
   }
   
   public int retiraPrimeiro() {//retira elemento do inicio da lista
	   int aux,pos;
	   aux=listaElementos[primeiro].getDado();
	   pos=primeiro;
	   primeiro=listaElementos[primeiro].getProximo();
	   elimina(pos);
	   atualizaTamanho(-1);
	 return aux;
   }
   
   public int retiraUltimo() {//retira elemento do final  da lista
	   int aux,pos;
	   aux=listaElementos[ultimo].getDado();
	   pos=ultimo;
	   ultimo=listaElementos[ultimo].getAnterior();
	   listaElementos[ultimo].setProximo(-1);
	   elimina(pos);
	   atualizaTamanho(-1);
	 return aux;
   }
   
}
