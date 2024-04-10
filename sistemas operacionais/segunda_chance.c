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

void init_MR(){//inicializa a memoria real


    int i;
    mem_real *mr;
    
    primeiro = malloc (sizeof (mem_real));
    primeiro->id = 0;
    primeiro->pg.caregdaMem = 0;//atribui zero ou um no bir R
    primeiro->pg.modificada = 0;
    primeiro->pg.pad = 0;
    primeiro->pg.deslocamento = rand()%12;
    acessosMR[0] = 0;
    ultimo = primeiro;
    
    for(i=1;i<TAM_MR;i++){

        acessosMR[i] = 0;
	mr =  malloc (sizeof (mem_real));
	mr->id = i;
        mr->pg.caregdaMem = i%2;
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
  int i=0;
  while(i<TAM_MR){
  	if(aux->id == id){
  		aux->pg.caregdaMem=1;
  		acessosMR[id]++;
  		return 1;
  	}
  	aux = aux->proximo;
  	i++;
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


mem_real *busca_sw(int id){//busca na memoria de swaping por uma pagina

	int i;
	mem_real *aux,*aux2;
	
	aux = swF;
	if(aux==NULL) return NULL;
	
	
	if(aux==swF && aux->id == id){
		
		if(swF==swL){
		 
			swF=NULL;
			swL=NULL;
			return aux;
		}
		swF = aux->proximo;
		aux->proximo = NULL;
		return aux;
	}
	
	
	for(i=0;i<TAM_MS;i++){
		
		if(aux->proximo->id == id) {
			
			 aux2 = aux->proximo;
			
			if(aux->proximo == swL){
	                      	           
	                      swL = aux;
	                      swL->proximo = NULL;	
	                      return aux2;	
			}
			else{
			 
			 	aux->proximo = aux2->proximo;
			 	aux2->proximo = NULL;
			 	return aux2;
			}	
			
		}
		aux = aux->proximo;	
	}
	return NULL;

}


void insere_ms(mem_real *pg){//salva a pagina na memória de swap

	if(swF==NULL) swF = pg;
	
	if(swL!=NULL){
		swL->proximo = pg;				
	}
	swL = pg;
	
}


int sub_pagina(int id){//substitui pagina

	mem_real *aux,*novo;
	
	if(percorre_MR(id)==0){
		faltaPagina++;
		 while(primeiro!=NULL){
		 
		 	aux = primeiro;
		 	
			if(primeiro->pg.caregdaMem == 0){//bir R=0 pagina sera substituida
				primeiro = primeiro->proximo;	
				
				novo = busca_sw(id);
				if(novo == NULL) novo = carrega(id);
				
				ultimo->proximo = novo;
				ultimo = novo;
				insere_ms(aux);
				aux = NULL;
				return 1;
			}
			
			
		 	aux->pg.caregdaMem = 0;
			primeiro = primeiro->proximo;
			ultimo->proximo = aux;
			ultimo = aux;
			aux = NULL;

		}
	}
	return 0;
}


void acessa_paginas(int acessa[10]){//faz o acesso as paginas

	int i;
	
	for(i=0;i<10;i++){
	
		sub_pagina(acessa[i]);
	}
}




int main()
{
  faltaPagina = 0;
  int acessos[10] = {2,8,4,6,1,0,1,5,3,7};//paginas a serem acessadas
  
  init_MR(); 
  init_mv();
  acessa_paginas(acessos);
  printf("page miss: %d\n",faltaPagina);
  
 return 0;
}




