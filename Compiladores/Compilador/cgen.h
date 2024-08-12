#ifndef _CGEN_H_
#define _CGEN_H_

#define nlabel_size 3
#define ntemp_size 3

typedef enum {  opADD, opSUB, opMULT, opDIV, opLT, opLEQUAL, opGT, opGREQUAL, opIGL, opDIF, opASSIGN, opALLOC, opIMMED, opLOAD, opSTORE,
                opVEC, opGOTO, opRET, opFUN, opEND, opPARAM, opCALL, opARG, opLAB, opHLT } OpKind;

typedef enum {  Empty, IntConst, String } AddrKind;

//estrutura do endereçamento 
typedef struct {
  AddrKind kind;
  union {
    int val;
    struct{
      char * name;
      char * scope;
    }var;
  }contents;
} Address;

//estrutura das quadruplas
typedef struct {
  OpKind op;
  Address addr1, addr2, addr3;
} Quad;

//estrutura das listas de quadruplas
typedef struct QuadListRec {
  int location;
  Quad quad;
  struct QuadListRec * next;
} * QuadList;

void codeGen(TreeNode * syntaxTree, char * codefile);

QuadList getIntermediate();

#endif
