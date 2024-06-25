'''
Devesse implementar um programa computacional que gere exemplos de relações
de acordo com com certas propriedades. O programa pergunta qual o numero de elementos
que o conjunto deve ter. O usuario responde um numero natural. O usuario entao responde
com sim, nao ou indiferente as seguintes perguntas:
• A relacao deve ser nao vazia?
• A relacao deve ser reflexiva? relacao deve ser simetrica?
• A relacao deve ser antissimetrica?
• A relacao deve ser transitiva?
Em seguida, o programa retorna o numero de relacoes no conjunto 1,...,n que
satisfazem as propriedades desejadas, e lista todas elas.
'''

from random import randint

def Gera_relacoes(n, vazia, reflexiva, simetrica, antissimetrica, transitiva):
    cont = 0
    relacoes = []

    if vazia == 'sim':  # relação não vazia
        if reflexiva == 'sim':  # relação reflexiva
            cont = cont + n
            for i in range(n):
                op = i + 1
                string = (op, op)
                relacoes.append(string)
            if antissimetrica == 'sim':  # reflexiva e antissimetrica
                if simetrica == 'sim':  # reflexiva, antissimetrica e simetrica
                    if transitiva == 'sim':  # todas as respostas sim
                        print('Número de relações:', cont, '; R =', relacoes)
                    else:
                        print('Não é possível')
                else:  # reflexiva, antissimetrica e não simetrica
                    if n <= 1:
                        print('Não é possível')
                    else:
                        i = randint(1, n)
                        j = i
                        while j == i:
                            j = randint(1, n)
                        string = (i, j)
                        relacoes.append(string)
                        cont = cont + 1
                        if transitiva == 'sim':  # reflexiva, antissimetrica, não simetrica e transitiva
                            k = j
                            while k == i or k == j:
                                k = randint(1, n)
                            relacoes.append((j, k))
                            relacoes.append((i, k))
                            cont = cont + 2
                        print('Número de relações:', cont, '; R =', relacoes)
            else:  # reflexiva e não antissimetrica
                if simetrica == 'sim':  # reflexiva, não antissimetrica e simetrica
                    i = randint(1, n)
                    j = i
                    while j == i:
                        j = randint(1, n)
                    relacoes.append((i, j))
                    relacoes.append((j, i))
                    cont = cont + 2
                    if transitiva == 'sim':  # reflexiva, não antissimetrica, simetrica e transitiva
                        print('Número de relações:', cont, '; R =', relacoes)
                    else:  # reflexiva, não antissimetrica, simetrica e não transitiva
                        print('Não é possível')
        else:  # relação não reflexiva
            if antissimetrica == 'sim':  # não reflexiva e antissimetrica
                i = randint(1, n)
                relacoes.append((i, i))
                cont = cont + 1
                if simetrica == 'sim':  # não reflexiva, antissimetrica e simetrica
                    if transitiva == 'sim':  # não reflexiva, antissimetrica, simetrica e transitiva
                        print('Número de relações:', cont, '; R =', relacoes)
                    else:
                        print('Não é possível')
                else:  # não reflexiva, antissimetrica e não simetrica
                    j = i
                    while j == i:
                        j = randint(1, n)
                    relacoes.append((i, j))
                    cont = cont + 1
                    if transitiva == 'sim':  # não reflexiva, antissimetrica, não simetrica e transitiva
                        k = j
                        while k == i or k == j:
                            k = randint(1, n)
                        relacoes.append((j, k))
                        relacoes.append((i, k))
                        cont = cont + 2
                    print('Número de relações:', cont, '; R =', relacoes)
            else:  # não reflexiva e não antissimetrica
                if simetrica == 'sim':  # não reflexiva, não antissimetrica e simetrica
                    i = randint(1, n)
                    j = i
                    while j == i:
                        j = randint(1, n)
                    relacoes.append((i, j))
                    relacoes.append((j, i))
                    cont = cont + 2
                    if transitiva == 'sim':  # não reflexiva, não antissimetrica, simetrica e transitiva
                        relacoes.append((i, i))
                        cont = cont + 1
                    print('Número de relações:', cont, '; R =', relacoes)
                else:  # não reflexiva, não antissimetrica e não simetrica
                    i = randint(1, n)
                    j = i
                    while j == i:
                        j = randint(1, n)
                    k = j
                    while k == i or k == j:
                        k = randint(1, n)
                    relacoes.append((i, j))
                    relacoes.append((j, k))
                    cont = cont + 2
                    if transitiva == 'sim':
                        relacoes.append((i, k))
                        cont = cont + 1
                    print('Número de relações:', cont, '; R =', relacoes)
    else:
        print('Número de relações:', cont, '; R = vazia')

def main():
    n = int(input("Número de elementos do conjunto: "))
    vazia = input('A relação deve ser não vazia? ')
    reflexiva = input('A relação deve ser reflexiva? ')
    simetrica = input('A relação deve ser simetrica? ')
    antissimetrica = input('A relação deve ser antissimetrica? ')
    transitiva = input('A relação deve ser transitiva? ')
    print()
    Gera_relacoes(n, vazia, reflexiva, simetrica, antissimetrica, transitiva)

main()
