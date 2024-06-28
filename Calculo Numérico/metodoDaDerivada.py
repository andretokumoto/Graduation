from numpy import sqrt, log, exp, sin, sinh, arcsin, arcsinh, cos, cosh, arccos, arccosh, tan, tanh, arctan, arctanh
from sympy.solvers import solve
from sympy import diff, symbols
import numpy as np
import pylab as pl

def main():
    #FUNÇÃO DE ENTRADA
    print("Entre com a função:")
    y = "x**4 - 5*(x**2) - 36"
    y = input()
    fy = lambda x: eval(str(y))
    
    #ENCONTRA-SE A PRIMEIRA DERIVADA
    dy = diff(y, 'x')
    dy = str(dy).replace('e','*10**')
    print("Primeira derivada", dy)

    #ENCONTRA-SE A SEGUNDA DERIVADA
    ddy = diff(y, 'x', 'x')
    fddy = lambda x: eval(str(ddy))
    print("Segunda derivada", ddy)

    #CRITÉRIO DA PRIMEIRA DERIVADA PARA PONTOS CRÍTICOS
    pts_c = solve(dy, 'x')
    
    #CRITÉRIO DA SEGUNDA DERIVADA PARA PONTOS DE MÁXIMO/MÍNIMO
    pts_max = []
    pts_min = []
    for ponto in pts_c:
        value = eval(str(ponto))
        if fddy(value) < 0:
            pts_max.append(value)
        elif fddy(value) > 0:
            pts_min.append(value)
    
    pts_max = np.array(pts_max)
    pts_min = np.array(pts_min)

   

    print(pts_max)
    print(pts_min)

    #GRÁFICO
    dots = np.linspace(min(min(pts_max), min(pts_min)) - 1, max(max(pts_max), max(pts_min)) + 1, 1000000)
    pl.title('Pontos Mapeados')
    pl.xlabel('Eixo X')
    pl.ylabel('Eixo Y')
    pl.plot(dots, fy(dots), 'black', label = "Função f(x)")
    pl.plot(pts_max, fy(pts_max), 'mD', label = "Pontos máximos")
    pl.plot(pts_min, fy(pts_min), 'cD', label = "Pontos mínimos")
    pl.legend()
    pl.grid()
    pl.show()

main()