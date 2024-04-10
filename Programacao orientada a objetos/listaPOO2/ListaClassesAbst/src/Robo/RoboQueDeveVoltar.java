package Robo;

public class RoboQueDeveVoltar extends RoboABateria{

	private int passosX,passosY,p0y,p0x;
	
	public RoboQueDeveVoltar(String n, int px, int py, short d, long e){
		super(n,px,py,d,e);	
	}
	
	  public void retornaAOrigem(int pAtualX,int pAtualY) {
		   p0x=pAtualX-passosX;
		   p0y=pAtualY-passosY;
	  }
	
	  public void moveParaOrigem(int pAtualX,int pAtualY) {
		  if(p0x>pAtualX) {
			  super.mudaDirecao((short) 0);
			  super.move((p0x-pAtualX));
		  }
		  else {
			  super.mudaDirecao((short) 180);
			  super.move((pAtualX-p0x));
		  }
		  if(p0y>pAtualY) {
			  super.mudaDirecao((short) 270);
			  super.move((p0y-pAtualY));
		  }
		  else {
			  super.mudaDirecao((short) 90);
			  super.move((pAtualY-p0y));
		  }
	  }
	  
}
