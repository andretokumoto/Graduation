import numpy as np
import pylab as pl
from sympy import symbols

def minquad(m, n, X, Y, G):
    x = symbols('x')
    A = np.zeros((n, n))   #AX = B
    B = np.zeros((n))      #AX = B

    #PERCORRE A LINHA
    for i in range(n):
        fi = lambda x: eval(G[i])
        #PERCORRE A COLUNA
        for j in range(n):
            fj = lambda x: eval(G[j])
            somalin = 0
            somacol = 0
            for k in range(m):
                #SOMATÓRIO DE CADA ELEMENTO DA MATRIZ A
                multcol = fj(X[k])*fi(X[k])
                somacol += multcol
                #SOMATÓRIO DE CADA ELEMENTO DA MATRIZ B
                multlin = Y[k]*fi(X[k])
                somalin += multlin
            B[i] = somalin
            A[i][j] = somacol

    #RESOLUÇÃO SISTEMA LINEAR           
    alpha = np.linalg.solve(A, B)
    return alpha

def main():
    print("Entre com o tamanho da amostra: ")
    qtd = int(input())

    X = []
    Y = []
    print("Entre com x e f(x), separados por espaço: ")
    for i in range(qtd):
        x, y = input().split(" ")
        X.append(float(x))
        Y.append(float(y))
    
    G = ['1']
    print("Deseja aproximar através de uma função de qual grau?")
    grau = int(input())
    for i in range(grau):
        string = 'x' + '**' + str(i+1)
        G.append(string)
    
    coeficientes = minquad(qtd, len(G), X, Y, G)
    y = ' + '.join(list(map((lambda a, b: '(' + str(a) + ')' + '*' + '(' + str(b) + ')'), coeficientes, G)))
    fy = lambda x: eval(str(y))
    print("A equação é:", y)

    dots = np.linspace(min(X), max(X), 1000000)
    pl.title('Comparativo')
    pl.xlabel('Eixo X')
    pl.ylabel('Eixo Y')
    pl.plot(X, Y, 'go', label = "Pontos mapeados")
    pl.plot(dots, fy(dots), 'black', label = "Função encontrada")
    pl.legend()
    pl.grid() 
    pl.show()

main()