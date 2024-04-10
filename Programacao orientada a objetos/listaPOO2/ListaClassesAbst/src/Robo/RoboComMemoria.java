package Robo;

public class RoboComMemoria extends RoboAbstrato{
	
	private int passosX,passosY,p0y,p0x;
	
	public RoboComMemoria(String n, int px, int py, short d, long e) {
		super(n, px, py, d);
		passosX=0;
		passosY=0;
		
	}
	
	public void move(int passos) {
		
		switch (direcaoAtual()) {
		
		  case 0:
			moveX(+passos);
			passosX+=passos;
		  break;
			
		  case 90:
			moveY(+passos);
			passosY+=passos;
		  break;
			
		  case 180:
			moveX(-passos);
			passosX-=passos;
		  break;
			
	   	  case 270:
			moveY(-passos);
			passosY-=passos;
		  break;
		}		
	}

  public void retornaAOrigem(int pAtualX,int pAtualY) {
	   p0x=pAtualX-passosX;
	   p0y=pAtualY-passosY;
  }
}
