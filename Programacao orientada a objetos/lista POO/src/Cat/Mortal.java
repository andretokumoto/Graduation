package Cat;

public class Mortal {
	
	private boolean vivo;
	
	public Mortal(){
		this.vivo=true;
	}
	
	public boolean isVivo()
	{
		return this.vivo;
	}
	
	public void mata() {
		this.vivo=false;
	}

}
