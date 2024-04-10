#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>

void removeWhiteSpace(char* buffer){
	if(buffer[strlen(buffer) - 1] == ' ' || buffer[strlen(buffer) - 1] == '\n'){
           buffer[strlen(buffer)-1 ]= '\0';
        }
	if(buffer[0] == ' ' || buffer[0] == '\n') 
             memmove(buffer, buffer + 1, strlen(buffer));
}

void tokenizeBuffer(char** param, int *nr, char *buffer, const char *c){
	char *token;
	int pc = -1;
	token = strtok(buffer, c);
	
    while(token) {
		param[++pc] = malloc(sizeof(token)+1);
		strcpy(param[pc], token);
		removeWhiteSpace(param[pc]);
		token = strtok(NULL, c);
    }
	
    param[++pc] = NULL;
    *nr = pc;
}

void executeBasic(char** argv) {
	if(fork() > 0) {
		wait(NULL);
	} 
	else {
		execvp(argv[0], argv);
		perror("invalid input\n");
                exit(1);
	}
}

void executePiped(char** buffer, int nr) {
	int fd[10][2], i, pc;
	char *argv[100];

	for(i = 0; i < nr; i++) {
		tokenizeBuffer(argv, &pc, buffer[i], " ");
		if(i != nr-1) {
			if(pipe(fd[i]) < 0) {
				perror("pipe creating was not successfull\n");
				return;
			}
		}
		if(fork() == 0) {
			if(i != nr-1) {
				dup2(fd[i][1], 1);
				close(fd[i][0]);
				close(fd[i][1]);
			}

			if(i != 0) {
				dup2(fd[i-1][0], 0);
				close(fd[i-1][1]);
				close(fd[i-1][0]);
			}
			
                       execvp(argv[0], argv);
			perror("invalid input ");
			exit(1);
		}
		if(i != 0) {
			close(fd[i-1][0]);
			close(fd[i-1][1]);
		}
		wait(NULL);
	}
}

void executeAsync(char** buffer, int nr){
	int i, pc;
	char *argv[100];

	for(i = 0; i < nr; i++) {
		tokenizeBuffer(argv, &pc, buffer[i], " ");
		if(fork() == 0) {
			execvp(argv[0], argv);
			perror("invalid input ");
			exit(1);
		}
	}
	for(i = 0; i < nr; i++) {
		wait(NULL);
	}

}

int hasConditions(char* buf) {
    return strstr(buf, "||") != NULL || strstr(buf, "&&") != NULL;
}

void executeConditions(char* buf) {
    char *token;   
    token = strtok(buf, " ");
    
    while(token) {
        char *argv[100];
        int pc = -1, flag = -1;

        while(!hasConditions(token)) {
            argv[++pc] = malloc(sizeof(token) + 1);
            strcpy(argv[pc], token);
            removeWhiteSpace(argv[pc]);
            token = strtok(NULL, " ");
        }
        argv[pc+1] = NULL;

        if(fork() > 0) {
		    wait(NULL);
        }
        else {
            execvp(argv[0], argv);
            perror("invalid input\n");
        }    
        
        token = strtok(NULL, " ");
    }
}

int main(char** argv,int argc) {
	char buf[500], *buffer[100], *params1[100], cwd[1024];
	int nr = 0;
	
	while(1) {
	
	     if (getcwd(cwd, sizeof(cwd)) != NULL) {
                     printf("%s$  ", cwd);
             }
             
             else 
             {
                  perror("getcwd failed\n");
             }

	     fgets(buf, 500, stdin);

	     if(hasConditions(buf)) { // operadores || e &&
                   executeConditions(buf);
             }
             else if(strchr(buf, '|')) {
			tokenizeBuffer(buffer, &nr, buf, "|");
			executePiped(buffer, nr);
	     }
	     else if(strchr(buf, '&')) {
			tokenizeBuffer(buffer, &nr, buf, "&");
			executeAsync(buffer, nr);
	     }
		else {
			tokenizeBuffer(params1, &nr, buf, " ");
			if(strstr(params1[0], "exit")) {
				exit(0);
			}
			else executeBasic(params1);
		}
	}

	return 0;
}