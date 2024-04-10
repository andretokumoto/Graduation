#include <stdio.h>
#include <semaphore.h>
#include <pthread.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#define N 10
#define NP 5
#define NC 5

struct list {
    char chave[20];
    int valor;
};
typedef struct list list; // estrutura dos pares 

struct thread_t {
    pthread_t t;
    int id;	
};
typedef struct thread_t thread_t; // workers 

int w, r, atual, ocorrencia, tam, end, rd;
char word[20]; // palavra solicitada pelo usuario
char dados[3000][20]; // banco de dados do arquivo lido
sem_t mutex_prod; // mutex para RC entre produtores
sem_t mutex_cons; // mutex para RC entre consumidores
sem_t full; // indica qtd posicoes cheias no buffer
sem_t empty; // indica qtd de posicoes vazias no buffer

list buffer[N];
list reduzido; // lista de pares reduzidos, com a chave solicitada

void init(void) { // inicia as variaveis do programa
    w = 0;
    r = 0;
    atual = 0; // le o trecho atual do arquivo
    tam = 0; // numero de palavras do arquivo
    rd = 0; // numero de arquivos lidos no buffer
    end = 0; // controla se todo o arquivo foi lido 
    ocorrencia = 0; // numero de ocorrencias para a palavra de entrada

    strcpy(reduzido.chave, word);
    reduzido.valor = 0;
    sem_init(&mutex_prod, 0, 1);
    sem_init(&mutex_cons, 0, 1);
    sem_init(&full, 0, 0);
    sem_init(&empty, 0, N);
}

void read_file(char *chave) { // produz uma chave a partir dos dados do arquivo
    strcpy(chave, dados[atual]);

    if(atual < tam) { // atualiza atual caso não tenha chegado no final dos dados 
        atual++;
    }
    if(atual == tam-1) { // todos os dados foram lidos e a var de controle e mudada para 1
        end = 1;
    }
}

void reduce(list *text) { // compara um par do buffer com 'word' e agrupa se a chave for igual
    char k[20];

    strcpy(k, text->chave);
    rd++;

    if(strcmp(k, word) == 0) {
        reduzido.valor += text->valor;
    }
    r = (r + 1) % N;
}

void *consumer(void *args) { // faz o agrupamento dos pares com a chave igual a entrada do usuario
    while(1) {
        sem_wait(&full);
        sem_wait(&mutex_cons);
        reduce(&buffer[r]);
        sem_post(&mutex_cons);
        sem_post(&empty);
        sleep(1);

        if(tam == rd) {
            pthread_exit(NULL);
        }  
    }
}

void map(char *chave, list *text) { // cria um par com uma chave e um valor 1
    strcpy(text->chave, chave);
    text->valor = 1;
    fflush(stdout);
    w = (w + 1) % N;
}

void *producer(void *args) { // realiza o mapeamento, cria os pares e os registra no buffer
    char chave[20];

    while(1) {
        read_file(&chave[0]);
        sem_wait(&empty);
        sem_wait(&mutex_prod);
        map(&chave[0], &buffer[w]);
        sem_post(&mutex_prod);
        sem_post(&full);

        if(end != 0) {
            pthread_exit(NULL);
        }
    }
}

void create_threads(thread_t *th, int n, void *(*func)(void*)) { // cria as threads
    for (int i=0; i<n; i++) {
        th[i].id = i;
        pthread_create(&th[i].t, NULL, func, &th[i].id);
    }
}

void join_threads(thread_t *th, int n) {
    for (int i=0; i<n; i++) {
        pthread_join(th[i].t, NULL);
    }
}

int main(int argc, char **argv) {
    thread_t tp[NP], tc[NC];
    FILE *entrada;
    char nome_arquivo[100], t[20];

    strcpy(nome_arquivo, argv[1]); // copia nome do arquivo para a variavel 'nome_arquivo'
    strcpy(word, argv[2]); // copia a palavra a ser executada na variavel 'word'
    init();

    printf("\nProcessando...");    
    entrada = fopen(nome_arquivo, "r"); // abre arquivo para leitura

    while (fscanf(entrada, "%s", t) != EOF) { // salva os dados lidos do arquivo em um vetor de string	
        strcpy(dados[tam], t);
        tam++;
    }
    fclose(entrada);

    create_threads(tp, NP, producer);
    create_threads(tc, NC, consumer);
    join_threads(tp, NP);
    join_threads(tc, NC);

    printf("\n\nA palavra '%s' ocorreu %d vezes no arquivo\n", word, reduzido.valor);

    return 0;
}