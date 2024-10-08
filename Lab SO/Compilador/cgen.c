#include "globals.h"
#include "symtab.h"
#include "cgen.h"
#include "parse.h"
#include "analyze.h"
#include "assembly.h"

/* prototype for internal recursive code generator */
static void cGen(TreeNode *tree);

QuadList head = NULL;

int location = 0;
int mainLocation;
int nlabel = 0;
int ntemp = 1;
int nparams = -1;
int posMem;
char escopoAtual[30] = "global";
int nso = 1;

Address labelAux;
Address aux;
Address var;
Address offset;
Address empty;

const char *OpKindNames[] = {"add", "sub", "mult", "div", "bgeq", "bgt", "bleq", "blt", "bne","beq", "atrib", "alloc", "immed", "load", "store",
                             "vec", "goto", "ret", "fun", "end", "param", "call", "arg", "lab", "end"};

// função que faz a impressao das linhas no arquivo
void emitComment( char * c ) { 
  if (TraceCode) fprintf(code,"// %s\n",c);
  printf("%s\n", c);
}

 //insere na lista de quadriplas
void quad_insert(OpKind op, Address addr1, Address addr2, Address addr3){

  Quad quad;
  quad.op = op;
  quad.addr1 = addr1;
  quad.addr2 = addr2;
  quad.addr3 = addr3;
  QuadList new = (QuadList)malloc(sizeof(struct QuadListRec));
  new->location = location;
  new->quad = quad;
  new->next = NULL;
  if (head == NULL){//primeira insersão
    head = new;
  }
  else{
    QuadList q = head;
    while (q->next != NULL){//procura local de insersão
      q = q->next;
    }  
    q->next = new;
  }
  location++;//atualiza atual localização
}

int quad_update(int loc, Address addr1, Address addr2, Address addr3){//atualizar a quadrupla na localização pedida
  QuadList q = head;
  while (q != NULL){//procura a quadrupla na localização pedida
    if (q->location == loc)
      break;
    q = q->next;
  }
  if (q == NULL)//quadrupla não localizada
    return 0;
  else{//atualiza quadrupla
    q->quad.addr1 = addr1;
    q->quad.addr2 = addr2;
    q->quad.addr3 = addr3;
    return 1;
  }
}

char *newLabel(){
  char *label = (char *)malloc((nlabel_size + 3) * sizeof(char));
  sprintf(label, "L%d", nlabel);
  nlabel++;
  return label;
}

char *newTemp(){
    char *temp = (char *)malloc((ntemp_size + 3) * sizeof(char));
    sprintf(temp, "$t%d", ntemp);
    ntemp = (ntemp % nregtemp)+1; 
    return temp;
}

Address addr_createEmpty(){
  Address addr;
  addr.kind = Empty;
  addr.contents.var.name = NULL;
  addr.contents.var.scope = NULL;
  return addr;
}

Address addr_createIntConst(int val){
  Address addr;
  addr.kind = IntConst;
  addr.contents.val = val;
  return addr;
}

Address addr_createString(char *name, char *scope){
  Address addr;
  addr.kind = String;
  addr.contents.var.name = (char *)malloc(strlen(name) * sizeof(char));
  strcpy(addr.contents.var.name,name);
  if(scope == NULL){
    addr.contents.var.scope = (char *)malloc(strlen(name) * sizeof(char));
    strcpy(addr.contents.var.scope,name);}
  else {
    addr.contents.var.scope = (char *)malloc(strlen(scope)* sizeof(char));
    strcpy(addr.contents.var.scope,scope);
  }
  return addr;
}

//gera código em um nó de instrução
static void genStmt(TreeNode *tree){
  TreeNode *p1, *p2, *p3;
  Address addr1, addr2, addr3;
  Address aux1, aux2, tempLabel;
  int loc1, loc2, loc3;
  char *label;
  char *temp;

  switch (tree->kind.stmt){
  case IfK:
    if (TraceCode)
      emitComment("-> if");
    p1 = tree->child[0]; //arg
    p2 = tree->child[1]; //if true
    p3 = tree->child[2]; //if false
    // condicao if
    cGen(p1);
    tempLabel = labelAux;
    // if true
    cGen(p2);
    //goes to end
    loc2 = location;
    quad_insert(opGOTO, empty, empty, empty); //jump else
    // end if
    label = tempLabel.contents.var.name;
    quad_insert(opLAB,addr_createString(label, escopoAtual), empty, empty);
    // if false comes to here
    quad_update(loc1, addr1,addr_createString(label, escopoAtual), empty);
    // else
    cGen(p3);
    if (p3 != NULL){
      // goes to the end
      loc3 = location;
    }
    label = newLabel();
    // final
    quad_insert(opLAB,addr_createString(label, escopoAtual), empty, empty);
    quad_update(loc2,addr_createString(label, escopoAtual), empty, empty);
    if (p3 != NULL)
      quad_update(loc3,addr_createString(label, escopoAtual), empty, empty);
    if (TraceCode)
      emitComment("<- if");
    break;

  case WhileK:
    if (TraceCode)
      emitComment("-> while");
    p1 = tree->child[0];//arg
    p2 = tree->child[1];//body
    // inicio do while
    label = newLabel();
    quad_insert(opLAB,addr_createString(label, escopoAtual), empty, empty); 
    // condicao while
    cGen(p1);
    tempLabel = labelAux;
    // while
    cGen(p2); //body
    loc3 = location;
    quad_insert(opGOTO,addr_createString(label, escopoAtual), empty, empty);
    // final
    label = tempLabel.contents.var.name;
    quad_insert(opLAB,addr_createString(label, escopoAtual), empty, empty);
    //if condition is false comes to here
    quad_update(loc1, addr1,addr_createString(label, escopoAtual), empty);
    if (TraceCode)
      emitComment("<- while");
    break;

  case AssignK:
    if (TraceCode)
      emitComment("-> atrib");
    p1 = tree->child[0];//arg
    p2 = tree->child[1];//body
    // var
    cGen(p1);
    addr1 = aux;
    aux1 = var;
    aux2 = offset;
    // exp
    cGen(p2);
    addr2 = aux;
    quad_insert(opASSIGN, addr1, addr2, empty);
    quad_insert(opSTORE, aux1, aux2, addr1);
    if (TraceCode)
      emitComment("<- atrib");
    break;

  case ReturnINT:
    if (TraceCode)
      emitComment("-> returnINT");
    p1 = tree->child[0];
    cGen(p1);
    addr1 = aux;
    quad_insert(opRET, addr1, empty, empty);
    if (TraceCode)
      emitComment("<- returnINT");
    break;
  case ReturnVOID:
    if (TraceCode)
      emitComment("-> returnVOID");
    addr1 = empty;
    quad_insert(opRET, addr1, empty, empty);
    if (TraceCode)
      emitComment("<- returnVOID");
    break;
  default:
    break;
  }
}

//gera código em um nó de expressão
static void genExp(TreeNode *tree){
  TreeNode *p1, *p2, *p3;
  Address addr1, addr2, addr3;
  int loc1, loc2, loc3;
  char *label;
  char *temp;
  char *s = "";

  switch (tree->kind.exp){
  case ConstK:
    if (TraceCode)
      emitComment("-> Const");
    addr1 = addr_createIntConst(tree->attr.val);
    temp = newTemp();
    aux = addr_createString(temp, escopoAtual);
    quad_insert(opIMMED, aux, addr1, empty);
    if (TraceCode)
      emitComment("<- Const");
    break;

  case IdK:
    if (TraceCode)
      emitComment("-> Id");
    aux = addr_createString(tree->attr.name, escopoAtual);
    p1 = tree->child[0];
    if (p1 != NULL){
      temp = newTemp();
      addr1 =addr_createString(temp, escopoAtual);
      addr2 = aux;
      cGen(p1);
      quad_insert(opVEC, addr1, addr2, aux);
      var = addr2;
      offset = aux;
      aux = addr1;
    }
    else{
      posMem = getMemLoc(tree->attr.name,escopoAtual);
      temp = newTemp();
      addr1 =addr_createString(temp, escopoAtual);
      addr3 =addr_createIntConst(posMem);
      quad_insert(opLOAD, addr1, aux, addr3);
      var = aux;
      offset = addr_createIntConst(posMem);;
      aux = addr1;
    }
    if (TraceCode)
      emitComment("<- Id");
    break;

  case FunDeclK:
    strcpy(escopoAtual,tree->attr.name);
    posMem = getMemLoc(tree->attr.name,"global");//atribui uma posição de memoria
    if (TraceCode)
      emitComment("-> Fun");
    // if main
    if (strcmp(tree->attr.name, "main") == 0)
      mainLocation = location;//salva alocalização da main
    if ((strcmp(tree->attr.name, "input") != 0) && (strcmp(tree->attr.name, "output") != 0) && (strcmp(tree->attr.name, "storeStack") != 0) && (strcmp(tree->attr.name, "loadStack") != 0) && (strcmp(tree->attr.name, "storeRegs") != 0) && (strcmp(tree->attr.name, "loadRegs") != 0)){
      quad_insert(opFUN, addr_createString(tree->attr.name, escopoAtual), addr_createIntConst(posMem), empty);//aloca espaço na memoria princ. para a funçao
      // params
      p1 = tree->child[1];
      cGen(p1);
      // dec & exp
      p2 = tree->child[2];
      cGen(p2);
      quad_insert(opEND, addr_createString(tree->attr.name, escopoAtual), empty, empty);
      strcpy(escopoAtual, "global");
    }
    if (TraceCode)
      emitComment("<- Fun");
    break;

  case AtivK://ativação de função
    if (TraceCode)
      emitComment("-> Call");
    nparams = tree->params;
    p1 = tree->child[0];
    while (p1 != NULL){
      if(p1->kind.exp == IdK){//verifica paramentros da função
        if(getVarType(p1->attr.name,escopoAtual) == VET)
        {
          temp = newTemp();
          aux = addr_createString(temp,escopoAtual);
          quad_insert(opIMMED,aux,addr_createIntConst(getMemLoc(p1->attr.name,escopoAtual)),empty);
        
        }
        else cGen(p1);
      }
      else{
        cGen(p1);
      }
      quad_insert(opPARAM, aux, empty, empty);
      nparams--;
      p1 = p1->sibling;
    }
    nparams = -1;
    aux = addr_createString("$ret", escopoAtual);
    quad_insert(opCALL, aux, addr_createString(tree->attr.name, escopoAtual), addr_createIntConst(tree->params));

    if (TraceCode)
      emitComment("<- Call");
    break;

  case VarParamK:
    posMem = getMemLoc(tree->attr.name,escopoAtual);
    if (TraceCode)
      emitComment("-> Param");
    quad_insert(opARG, addr_createString(tree->attr.name, escopoAtual), addr_createIntConst(posMem), addr_createString(escopoAtual,escopoAtual));
    if (TraceCode)
      emitComment("<- Param");
    break;

  case VarDeclK:
    posMem = getMemLoc(tree->attr.name,escopoAtual);
    if (TraceCode)
      emitComment("-> Var");
    if (posMem != -1){
      quad_insert(opALLOC, addr_createString(tree->attr.name, escopoAtual), addr_createIntConst(1), addr_createString(escopoAtual,escopoAtual));
    }
    else{
      Error = TRUE;
      return;
    }
    if (TraceCode)
      emitComment("<- Var");
    break;

  case VetorK:
    posMem = getMemLoc(tree->attr.name,escopoAtual);
    if (TraceCode)
      emitComment("-> Vet");
    if (posMem != -1){
      quad_insert(opALLOC, addr_createString(tree->attr.name, escopoAtual), addr_createIntConst(tree->child[1]->attr.val), addr_createString(escopoAtual,escopoAtual));
    }
    else{
      Error = TRUE;
      return;
    }
    if (TraceCode)
      emitComment("<- Vet");
    break;

  case OpK:
    if (TraceCode)
      emitComment("-> Op");
    p1 = tree->child[0];
    p2 = tree->child[1];
    cGen(p1);
    addr1 = aux;
    cGen(p2);
    addr2 = aux;
    switch (tree->attr.op){
    case SOM:
      temp = newTemp();
      aux =addr_createString(temp, escopoAtual);
      quad_insert(opADD, addr1, addr2, aux);
      break;
    case SUB:
      temp = newTemp();
      aux =addr_createString(temp, escopoAtual);
      quad_insert(opSUB, addr1, addr2, aux);
      break;
    case MUL:
      temp = newTemp();
      aux =addr_createString(temp, escopoAtual);
      quad_insert(opMULT, addr1, addr2, aux);
      break;
    case DIV:
      temp = newTemp();
      aux =addr_createString(temp, escopoAtual);
      quad_insert(opDIV, addr1, addr2, aux);
      break;
    case MENO:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opLT, addr1, addr2, labelAux);
      break;
    case MEIG:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opLEQUAL, addr1, addr2, labelAux);
      break;
    case MAIO:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opGT, addr1, addr2, labelAux);
      break;
    case MAIG:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opGREQUAL, addr1, addr2, labelAux);
      break;
    case IGL:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opIGL, addr1, addr2, labelAux);
      break;
    case DIF:
      labelAux = addr_createString(newLabel(), escopoAtual);
      quad_insert(opDIF, addr1, addr2, labelAux);
      break;
    default:
      emitComment("ERRO: operador não encontrado");
      break;
    }
    if (TraceCode)
      emitComment("<- Op");
    break;

  default:
    break;
  }
}

/* Procedure cGen recursively generates code by
 * tree traversal
 */
static void cGen(TreeNode *tree){
  if (tree != NULL){
    switch (tree->nodekind){
    case StmtK:
      if(TraceCode) printf("-> Stmt %d\n",tree->lineno);
      genStmt(tree);
      break;
    case ExpK:
      if(TraceCode) printf("-> Exp %d\n",tree->lineno);
      genExp(tree);
      break;
    default:
      break;
    }
    if (nparams == -1 || nparams == 0){
      cGen(tree->sibling);
    }
  }
}

void printCode(){
  QuadList q = head;
  Address a1, a2, a3;
  while (q != NULL){
    a1 = q->quad.addr1;
    a2 = q->quad.addr2;
    a3 = q->quad.addr3;
    printf("(%s, ", OpKindNames[q->quad.op]);
    switch (a1.kind){
    case Empty:
      printf("-");
      break;
    case IntConst:
      printf("%d", a1.contents.val);
      break;
    case String:
      printf("%s", a1.contents.var.name);
      break;
    default:
      break;
    }
    printf(", ");
    switch (a2.kind){
    case Empty:
      printf("-");
      break;
    case IntConst:
      printf("%d", a2.contents.val);
      break;
    case String:
      printf("%s", a2.contents.var.name);
      break;
    default:
      break;
    }
    printf(", ");
    switch (a3.kind){
    case Empty:
      printf("-");
      break;
    case IntConst:
      printf("%d", a3.contents.val);
      break;
    case String:
      printf("%s", a3.contents.var.name);
      break;
    default:
      break;
    }
    printf(" )\n");
    q = q->next;
  }
}


//procedimento que gera o cod intermediario
void codeGen(TreeNode *syntaxTree, char *codefile){
  char *s = malloc(strlen(codefile) + 7);
  strcpy(s, "File: ");
  strcat(s, codefile);
  emitComment("\nC- Intermediate Code");
  emitComment(s);
  empty = addr_createEmpty();
  cGen(syntaxTree);
  quad_insert(opHLT, empty, empty, empty);
  printCode();
  emitComment("End of execution");
}

QuadList getIntermediate(){
  return head;
}
