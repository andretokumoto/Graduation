#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>


#define TAM_MV 10
#define TAM_MR 5
#define TAM_MS 5

int acessosMR[TAM_MR],faltaPagina;

struct pagina{//estrutura da pagina

    uint16_t caregdaMem:1;
    uint16_t referenciada:1;
    uint16_t modificada:1;
    uint16_t pad:1;
    uint16_t deslocamento:12;

};typedef struct pagina pagina;

struct mr{//estrutura da memoria fisica
 
 pagina pg;
 int id;
 struct mr *proximo;

};typedef struct mr mem_real;

pagina mv[TAM_MV];
mem_real *primeiro,*ultimo;
mem_real *swF,*swL;//ponteiros da memoria de swap

void init_MR(){//inicializa a memoria 


    int i;
    mem_real *mr;
    
    primeiro = malloc (sizeof (mem_real));
    primeiro->id = 0;
    primeiro->pg.caregdaMem = 0;
    primeiro->pg.modificada = 0;
    primeiro->pg.pad = 0;
    primeiro->pg.deslocamento = rand()%12;
    acessosMR[0] = 0;
    ultimo = primeiro;
    
    
    for(i=1;i<TAM_MR;i++){

        acessosMR[i] = 0;
	mr =  malloc (sizeof (mem_real));
	mr->id = i;
        mr->pg.caregdaMem = 0;
        mr->pg.modificada = 0;
        mr->pg.pad = 0;
        mr->pg.deslocamento = rand()%12;
       
       ultimo->proximo = mr;
       ultimo = mr;
       mr = NULL;
        
    }
}


void init_mv(){//inicia memoria virtual

	int i;

	for(i=0;i<TAM_MV;i++){
		
		mv[i].caregdaMem = 0;
		mv[i].modificada = 0;
		mv[i].pad = 0;
		mv[i].deslocamento = rand()%12;
	}

}


int percorre_MR(int id){//percorre a memoria real buscando a pagina requerida

  mem_real *aux = primeiro;
  while(aux!=NULL){
  	if(aux->id == id){
  		aux->pg.caregdaMem=1;
  		acessosMR[id]++;
  		return 1;
  	}
  	aux = aux->proximo;
  }
  return 0;	
}

mem_real *carrega(int id){

	 mem_real *novo =  malloc (sizeof (mem_real));
	 novo->id = id;
	 novo->pg.caregdaMem =  mv[id].caregdaMem;
         novo->pg.modificada= mv[id].modificada;
        novo->pg.pad= mv[id].pad;
        novo->pg.deslocamento= mv[id].deslocamento;
        return novo;
}


int sub_pagina(int id){//substitui pagina

	mem_real *aux,*novo;
	if(percorre_MR(id)==0){
		faltaPagina++;
		
		aux = primeiro;
		primeiro = primeiro->proximo;
		novo = carrega(id);
		ultimo->proximo = novo;
		ultimo = novo;
		
		return 1;		
	}
	return 0;
}


void acessa_paginas(){//faz o acesso aleatorio de paginas

	int h,i,pg;
	
	
	h = rand()%TAM_MR;
	
	for(i=0;i<h;i++){
		
		pg = rand()%TAM_MV;
		sub_pagina(pg);
	}
}




void executa(){//implementação do 'relogio'

	int cont = 0;
	
	while(cont<100){
	
		if(cont%10==0) acessa_paginas();//interrupção de relogio
		
		cont++;
	}


}


int main()
{
  faltaPagina = 0;
  srand(time(NULL));
  init_MR(); 
  init_mv();
  executa();
  printf("page miss: %d\n",faltaPagina);
  
 return 0;
}
