package Cat;

public class Ramo extends Mortal{
	private Ramo direito,esquerdo;
	
	public Ramo(){
	    
	}
	
	public Ramo getDireito() {
		return direito;
	}

	public void setDireito(Ramo direito) {
		this.direito = direito;
	}

	public Ramo getEsquerdo() {
		return esquerdo;
	}

	public void setEsquerdo(Ramo esquerdo) {
		this.esquerdo = esquerdo;
	}

    public void mata() {
    	if(this.esquerdo!=null)
    		esquerdo.mata();
    	if(this.direito!=null)
    		direito.mata();
    	super.mata();
	
    }

    public String toString(){
    	  String ramo,dir,esq;
    	  if(super.isVivo())
    		  ramo="vivo";
    	  else
    		  ramo="morto";
    	  
    	/*  if(esquerdo!=null)
    	  {
    		  if(esquerdo.isVivo())
    			   esq="vivo";
    		  else
    			  esq="morto";
    	  }
    	  else {
    		  esq="nao existe";
    	  }
    		 
    	  if(direito!=null)
    	  {
    		  if(direito.isVivo())
    			   dir="vivo";
    		  else
    			  dir="morto";
    	  }
    	  else {
    		  dir="nao existe";
    	  }  */
    	   
          return("o ramo esta:"+ramo);
    } 

}
