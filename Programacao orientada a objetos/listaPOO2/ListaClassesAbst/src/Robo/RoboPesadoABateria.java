package Robo;

public class RoboPesadoABateria extends RoboABateria{
	
	private float pesoRobo;

	public RoboPesadoABateria(String n, int px, int py, short d, long e){
		super(n,px,py,d,e);
		pesoRobo=0;
	}
	
public void move(int passos) {
	    super.energiaASerGasta= (long) (pesoRobo/10);
	    super.move(passos);
	}
}
