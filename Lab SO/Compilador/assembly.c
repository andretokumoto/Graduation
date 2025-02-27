#include "globals.h"
#include "symtab.h"
#include "cgen.h"
#include "assembly.h"
#include "string.h"

AssemblyCode codehead = NULL;
FunList funlisthead = NULL;
 
int line = 0; 
int nscopes = 0;
int curmemloc = 0;
int curparam = 0;
int curarg = 0;
int narg = 0;
int jmpmain = 0;
int i;


const char * InstrNames[] =  {  "add", "sub", "mult", "div", "and", "or", "xor", "nor", "mov", "movi", "nand", "lw", "sw", "in", "out", "addi", "subi", "multi", "divi", "lt", "andi", "ori", "beq", "bne", "blt", "bgt", "bleq", "bgeq", "j", "jal", "jra", "not", "jr", "xnor", "end","pause","spc","inproc","outproc"};

const char * regNames[] = { "$zero", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$t9", "$t10","$t11", "$t12", "$p1", "$p2", "$p3", "$p4", "$p5", "$p6", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6","$sp","$ra", "$bp","$ret"};


void insertFun (char * id) {
    
    FunList new = (FunList) malloc(sizeof(struct FunListRec));
    new->id = (char *) malloc(strlen(id) * sizeof(char));
    strcpy(new->id, id);
    new->size = 0;
    new->memloc = curmemloc;
    new->next = NULL;
    if (funlisthead == NULL) {
        funlisthead = new;
    }
    else {
        FunList f = funlisthead;
        while (f->next != NULL) f = f->next;
        f->next = new;
    }
    nscopes ++;
}

void insertVar (char * scope, char * id, int size, VarKind kind) {
    FunList f = funlisthead;

    if(scope == NULL){
        if(kind == 1 )
            scope= f->id;
        else
            scope= f->next->id;
    }

    while (f != NULL && strcmp(f->id, scope) != 0)  f = f->next;

    if (f == NULL) {
        insertFun(scope);
        f = funlisthead;

        while (f != NULL && strcmp(f->id, scope) != 0 ) 
            f = f->next;
    }
    VarList new = (VarList) malloc(sizeof(struct VarListRec));
    new->id = (char *) malloc(strlen(id) * sizeof(char));
    strcpy(new->id, id);
    new->size = size;
    new->memloc = f->size;
    curmemloc = curmemloc + size;
    new->kind = kind;
    new->next = NULL;
    if (f->vars == NULL) {
        f->vars = new;
    }
    else {
        VarList v = f->vars; 
        while (v->next != NULL) v = v->next;
        v->next = new;
    }
    f->size = f->size + size;
}

void insertLabel (char * label) {
    AssemblyCode new = (AssemblyCode) malloc(sizeof(struct AssemblyCodeRec));
    new->lineno = line;
    new->kind = lbl;
    new->line.label = (char *) malloc(strlen(label) * sizeof(char));
    strcpy(new->line.label, label);
    new->next = NULL;
    if (codehead == NULL) {
        codehead = new;
    }
    else {
        AssemblyCode a = codehead;
        while (a->next != NULL) a = a->next;
        a->next = new;
    }
}

//insere a instrução na lista de instuções de acordo com seu formato
void insertInstruction (InstrFormat format, InstrKind opcode, Reg reg1, Reg reg2, Reg reg3, int im, char * imlbl){
    Instruction i;
    i.format = format;
    i.opcode = opcode;
    i.reg1 = reg1;
    i.reg2 = reg2;
    i.reg3 = reg3;
    i.im = im;

    //printf("ins %s\n",InstrNames[opcode]);

    if (imlbl != NULL) {//insere lambel
        i.imlbl = (char *) malloc(strlen(imlbl) * sizeof(char));
        strcpy(i.imlbl, imlbl);
    }
    AssemblyCode new = (AssemblyCode) malloc(sizeof(struct AssemblyCodeRec));
    new->lineno = line;
    new->kind = instr;
    new->line.instruction = i;
    new->next = NULL;
    if (codehead == NULL) {//primeira instrução
        codehead = new;
    }
    else {
        AssemblyCode a = codehead;
        while (a->next != NULL) a = a->next;
        a->next = new;
    }
    line ++;
}



void instructionFormatR (InstrKind opcode, Reg reg1, Reg reg2, Reg reg3) { // Tipo R
    insertInstruction(formatR, opcode, reg1, reg2, reg3, 0, NULL);
}

void instructionFormatJ (InstrKind opcode, int im, char * imlbl) { // Tipo J
    insertInstruction(formatJ, opcode, $zero, $zero, $zero, im, imlbl);
}

void instructionFormatI (InstrKind opcode, Reg reg1, Reg reg2, int im, char * imlbl) { // Tipo I 
    insertInstruction(format_I, opcode, reg1, reg2, $zero, im, imlbl);
}

void instructionFormatO (InstrKind opcode, Reg reg1, int im, char * imlbl) { // Tipo O 
    insertInstruction(formatO, opcode, reg1, $zero, $zero, im, imlbl);
}

Reg getParamReg () {
        return (Reg) nregtemp + 1 + curparam;
}

Reg getArgReg () {

        return (Reg) nregtemp + curarg + 1;
}

Reg getReg (char * regName) {

        for (int i = 0; i < nregisters; i ++) {
            if (strcmp(regName, regNames[i]) == 0) return (Reg) i;
        }

    return $zero;
}

int getLabelLine (char * label) {//retorna a linha de determinada label
    AssemblyCode a = codehead;
    while (a->next != NULL) {
        if (a->kind == lbl && strcmp(a->line.label, label) == 0) return a->lineno;
        a = a->next;
    }
    return -1;
}

VarKind checkType (QuadList l) {//verifica o tipo de quadrupla
    QuadList aux = l;
    Quad q = aux->quad;
    aux = aux->next;
    while (aux != NULL && aux->quad.op != opEND) {
        if (aux->quad.op == opVEC && strcmp(aux->quad.addr2.contents.var.name, q.addr1.contents.var.name) == 0) return address;
        aux = aux->next;
    }
    return simple;
}

VarKind getVarKind (char * id, char * scope) {
    FunList f = funlisthead;
    while (f != NULL && strcmp(f->id, scope) != 0) f = f->next;
    if (f == NULL) {
        return simple;
    }
    VarList v = f->vars;
    while (v != NULL) {
        if (strcmp(v->id, id) == 0) return v->kind;
        v = v->next;
    }
    return simple;
}

int getFunSize (char * id) {//retorna o tamanho de função
    FunList f = funlisthead;
    while (f != NULL && strcmp(f->id, id) != 0) f = f->next;
    if (f == NULL) return -1;
    return f->size;
}

void init_pointers(){

    instructionFormatI(movi,$sp,$zero, 1, NULL);
    instructionFormatI(movi,$bp,$zero, 30, NULL);

}


//verifica o tipo da quadripla e faz a chamada de insersão de acordo com seu tipo
void generateInstruction (QuadList l) {
    Quad q;
    Address a1, a2, a3;
    int aux;
    VarKind v;

    while (l != NULL) {
        q = l->quad;
        a1 = q.addr1;
        a2 = q.addr2;
        a3 = q.addr3;

        switch (q.op) {
            case opADD:
                instructionFormatR(add, getReg(a3.contents.var.name), getReg(a1.contents.var.name), getReg(a2.contents.var.name));
                break;
    
            case opSUB:
                instructionFormatR(sub, getReg(a3.contents.var.name), getReg(a1.contents.var.name), getReg(a2.contents.var.name));
                break;
    
            case opMULT:
                instructionFormatR(mult, getReg(a3.contents.var.name), getReg(a1.contents.var.name), getReg(a2.contents.var.name));
                break;
    
            case opDIV:
                instructionFormatR(divi, getReg(a3.contents.var.name), getReg(a1.contents.var.name), getReg(a2.contents.var.name));
                break;
    
            case opLT:
                instructionFormatI(bgeq, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;
    
            case opLEQUAL:
                instructionFormatI(bgt, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;
    
            case opGT:
                instructionFormatI(bleq, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;
    
            case opGREQUAL:
                instructionFormatI(blt, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;

            case opIGL:
                instructionFormatI(bne, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;
    
            case opDIF:
                instructionFormatI(beq, getReg(a1.contents.var.name), getReg(a2.contents.var.name), -1, a3.contents.var.name);
                break;
            
            case opASSIGN:
                //instructionFormatR(add, getReg(a1.contents.var.name), $zero, getReg(a2.contents.var.name));
                instructionFormatI(mov, getReg(a1.contents.var.name), getReg(a2.contents.var.name), 0, NULL);
                break;
            
            case opALLOC:
                if (a2.contents.val == 1)
                 insertVar(a3.contents.var.name, a1.contents.var.name,  a2.contents.val, simple);
                else insertVar(a3.contents.var.name, a1.contents.var.name,  a2.contents.val, vector);
                break;
            
            case opIMMED:
                //instructionFormatI(addi,getReg(a1.contents.var.name),$zero, a2.contents.val, NULL);
                 instructionFormatI(movi, getReg(a1.contents.var.name), $zero, a2.contents.val, NULL);
                break;
    
            case opLOAD:
                aux = getMemLoc(a2.contents.var.name, a2.contents.var.scope);
                if (aux == -1){
                        aux = getMemLoc(a2.contents.var.name, "global");
                        instructionFormatI(lw, getReg(a1.contents.var.name), $bp, 1, NULL);    
                }
                else{
                        instructionFormatI(lw, getReg(a1.contents.var.name), $sp, aux, NULL);    
                }
                break;
    
            case opSTORE:
                    aux = getMemLoc(a1.contents.var.name, a1.contents.var.scope);

                 
                    v = getVarKind(a1.contents.var.name, a1.contents.var.scope);
                    if(v == vector)
                        instructionFormatI(sw, getReg(a3.contents.var.name),getReg(a2.contents.var.name), aux, NULL);
                     //instructionFormatI(sw, getReg(a2.contents.var.name), getReg(a3.contents.var.name), aux, NULL);
                    else
                        instructionFormatI(sw, getReg(a3.contents.var.name), $sp, aux, NULL);
                    
                
                break;
            
            case opVEC:
                aux = getMemLoc(a2.contents.var.name, a2.contents.var.scope);

                    v = getVarKind(a2.contents.var.name, a2.contents.var.scope);

                    instructionFormatI(lw,$sp,getReg(a1.contents.var.name),getMemLoc(a2.contents.var.name,a2.contents.var.scope),NULL);
                    instructionFormatR(add, getReg(a3.contents.var.name), getReg(a1.contents.var.name),getReg(a3.contents.var.name));
                    instructionFormatI(lw,getReg(a3.contents.var.name),getReg(a1.contents.var.name),0,NULL);
                
                break;
            
            case opGOTO:
                instructionFormatJ(j, -1, a1.contents.var.name);
                break;
            
            case opRET:
                if (a1.kind == String) instructionFormatR(add, $ret, $zero, getReg(a1.contents.var.name));
                else
                    //instructionFormatR(add, $ret, $zero, a1.contents.val);
                    instructionFormatI(mov, $ret, a1.contents.val, 0, NULL);
                if(strcmp(a1.contents.var.scope, "main") != 0){
                    aux = getFunSize(a1.contents.var.scope);
                    
                    instructionFormatI(lw, $ra, $bp, 1, NULL);   
                    instructionFormatJ(jra, -1, NULL); 
                }
                else
                    instructionFormatJ(j, -1, "end");
                break;
            
            case opFUN:
                if (jmpmain == 0) {//jump para main
                    instructionFormatJ(j, -1, "main");
                    jmpmain = 1;
                }
               /* if(strcmp(a1.contents.var.scope, "main") != 0){
                    instructionFormatI(movi, $bp, $zero, curmemloc, NULL);
                    instructionFormatI(mov, $sp, $bp, curmemloc, NULL);
                }*/

                insertLabel(a1.contents.var.name);
                insertFun(a1.contents.var.name);
                curarg = 0;
                break;
            
            case opEND:
                if (strcmp(a1.contents.var.name, "main") == 0)
                    instructionFormatJ(j, -1, "end");
                else{
                    aux = getFunSize(a1.contents.var.name);
                    instructionFormatI(lw, $ra, $bp, 1, NULL); 
                    instructionFormatJ(jra, 0, NULL);
                }
                break;
            
            case opPARAM:
                //instructionFormatR(add, getParamReg(), $zero, getReg(a1.contents.var.name));
                instructionFormatI(mov, getParamReg(), getReg(a1.contents.var.name), 0, NULL);
                curparam = (curparam+1)%nregparam; 
                break;
            
            case opCALL://chada de função
                if (strcmp(a2.contents.var.name, "input") == 0) {//entrada de dados
                    instructionFormatO(in, getReg(a1.contents.var.name), 0, NULL);
                    instructionFormatR(mov, getReg(a1.contents.var.name), $s6, $zero);
                }
                else if (strcmp(a2.contents.var.name, "output") == 0) {//saida de dados
                    instructionFormatO(out, getArgReg(), 0, NULL);
                    //instructionFormatR(pause, $zero, $zero, $zero);
                }
                else{//outros tipos de função
                        aux = getFunSize(a1.contents.var.scope);
                       /* if(strcmp(a1.contents.var.scope, "main") == 0){
                            instructionFormatI(movi, $bp, $zero, curmemloc, NULL);
                            instructionFormatI(mov, $bp, $sp, curmemloc, NULL);
                        } */
                        instructionFormatI(addi,$bp,$bp,aux,NULL);//cria pilha
                        instructionFormatR(spc, $ra, $zero, $zero);//salva pc
                        instructionFormatI(sw, $ra, $bp,1, NULL);//salva na pilha
                        instructionFormatJ(j, -1, a2.contents.var.name);//salta para a função 
                        instructionFormatI(subi,$bp, $bp, aux, NULL);//desempilha
                }
                narg = a3.contents.val;
                curparam = 0; 
                break;
            
            case opARG:
                insertVar(a3.contents.var.name, a1.contents.var.name, 1, checkType(l));
                FunList f = funlisthead;
                    instructionFormatI(sw, getArgReg(), $sp,getMemLoc(a1.contents.var.name,a1.contents.var.scope), NULL);

                curarg ++;
                break;
            
            case opLAB:
                insertLabel(a1.contents.var.name);
                break;
            
            case opHLT:
                insertLabel("end");
                instructionFormatR(end, $zero, $zero, $zero);
                break;
    
            default:
                break;
        }
        l = l->next;
    }
}

void generateInstructions (QuadList head) {
    QuadList l = head;
    
    generateInstruction(l);
    AssemblyCode a = codehead;
    while (a != NULL) {
        if (a->kind == instr) {
            if(a->line.instruction.opcode == j && a->line.instruction.imlbl == NULL){
                continue;
            }
            if (a->line.instruction.opcode == j || a->line.instruction.opcode == jal || a->line.instruction.opcode == beq || a->line.instruction.opcode == bne || a->line.instruction.opcode == blt || a->line.instruction.opcode == bgt ||
            a->line.instruction.opcode == bleq || a->line.instruction.opcode == bgeq) 
                a->line.instruction.im = getLabelLine(a->line.instruction.imlbl);
        }
        a = a->next;
    }
}

void printAssembly () {
    AssemblyCode a = codehead;
    printf("\nCódigo Assembly C-\n");
    while (a != NULL) {
        if (a->kind == instr) {
            if (a->line.instruction.format == formatR) {
                if(a->line.instruction.opcode == end)
                    printf("%d:\t%s\n",    a->lineno, InstrNames[a->line.instruction.opcode]);
                else
                    printf("%d:\t%s %s, %s, %s\n",    a->lineno, InstrNames[a->line.instruction.opcode], regNames[a->line.instruction.reg1], 
                                                regNames[a->line.instruction.reg2], regNames[a->line.instruction.reg3]);
            }
            else if (a->line.instruction.format == format_I) {
                    printf("%d:\t%s %s, %s, %d\n",    a->lineno, InstrNames[a->line.instruction.opcode], regNames[a->line.instruction.reg1], 
                                                regNames[a->line.instruction.reg2], a->line.instruction.im);

            }
            else if (a->line.instruction.format == formatO) {
                printf("%d:\t%s %s\n",    a->lineno, InstrNames[a->line.instruction.opcode], regNames[a->line.instruction.reg1]);
            }
            else {
                if (a->line.instruction.opcode == jra)
                    printf("%d:\t%s\n",    a->lineno, InstrNames[a->line.instruction.opcode]);
                else
                    printf("%d:\t%s %d\n",    a->lineno, InstrNames[a->line.instruction.opcode], a->line.instruction.im);
            }
        }
        else
            printf(".%s\n", a->line.label);
        a = a->next;
    }
}

void generateAssembly (QuadList head) {
    init_pointers();
    generateInstructions(head);
    printAssembly();
}

AssemblyCode getAssembly() {
    return codehead;
}