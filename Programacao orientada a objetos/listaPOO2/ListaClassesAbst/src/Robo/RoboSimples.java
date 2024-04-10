package Robo;

public class RoboSimples extends RoboAbstrato {

	RoboSimples(String n, int px, int py, short d) {
		super(n, px, py, d);
	}

	public void move(int passos) {
		switch (direcaoAtual()) {
		case 0:
			moveX(+passos);
			break;
		case 90:
			moveY(+passos);
			break;
		case 180:
			moveX(-passos);
			break;
		case 270:
			moveY(-passos);
			break;
		}	
	}
	public void mudaDirecao(short dir) {
		
		short nd=0;
		
		if(dir<315) {
			
			if(dir>=45) {
				
				if(dir<135) {
					nd=90;
				}
				else if(dir<225) {
					nd=180;
				}
				else {
					nd=270;
				}
			}
		}
		super.mudaDirecao(nd);
	}
	
	
}
