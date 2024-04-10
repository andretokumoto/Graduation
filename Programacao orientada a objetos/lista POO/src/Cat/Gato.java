package Cat;

public class Gato extends Mortal{
	
	private int mortes;
	 
    public Gato() {
    	super();
    	this.mortes=0;
    }
	
    
    public void mata() {
    	
    	this.mortes++;
    	if(this.mortes==7)
    		super.mata();
    }

    public String toString(){
    	return ("o gato esta vivo:"+Boolean.toString(super.isVivo()));
    }
}
