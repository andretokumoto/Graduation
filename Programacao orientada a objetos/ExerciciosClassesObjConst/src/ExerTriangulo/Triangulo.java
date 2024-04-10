package ExerTriangulo;

public class Triangulo
{
	//atributos-----------------------------------------------------------------------------------------
	double base,altura;
	//metodos--------------------------------------------------------------------------------------------
	
	public Triangulo()
	{
		this.altura=0.0;
		this.base=0.0;
	}
	
	public void Triangulo(double ar,double ba)
	{
		this.altura=ar;
		this.base=ba;
	}
	
	
	public double getBase() 
	{
		return base;
	}

	public void setBase(double b) 
	{
		this.base = b;
	}

	public double getAltura() 
	{
		return altura;
	}

	public void setAltura(double a) 
	{
		this.altura = a;
	}
	
	public double area()
	{
		return((base*altura)/2);
	}
	
	public void mostra()
	{
		System.out.println("base: "+getBase()+"\naltrura: "+getAltura()+"\narea: "+area());
	}
	
	
	
	

}
