#define nregisters 32
#define nregtemp 12
#define nregparam 6
#define nregso 6


typedef enum {  add, sub, mult, divi, and, or, xor, nor, mov, movi, nand, lw, sw, in, out, addi, subi, multi, divim, lt, andi, ori, beq, bne, blt, bgt, bleq, bgeq, j, jal, jra, not, jr, xnor, end ,pause,spc} InstrKind;

typedef enum {  formatR, format_I, formatO, formatJ } InstrFormat;

typedef enum {  instr, lbl } LineKind;

typedef enum {  simple, vector, address } VarKind;

typedef enum { $zero, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10, $t11, $t12, $p1, $p2, $p3, $p4, $p5, $p6, $s1, $s2, $s3, $s4, $s5, $s6 ,$sp, $ra, $bp, $ret} Reg;


typedef struct {
    InstrFormat format;
    InstrKind opcode;
    char *op_bin;
    Reg reg1;
    Reg reg2;
    Reg reg3;
    int im;
    char *imlbl;
} Instruction;

typedef struct AssemblyCodeRec {
    int lineno;
    LineKind kind;
    union {
        Instruction instruction;
        char *label;
    } line;
    struct AssemblyCodeRec *next;
} *AssemblyCode;

typedef struct VarListRec {
    char * id;
    int size;
    int memloc;
    VarKind kind;
    struct VarListRec * next;
} *VarList;

typedef struct FunListRec {
    char * id;
    int size;
    int memloc;
    VarList vars;
    struct FunListRec * next;
} *FunList;

void generateAssembly (QuadList head);

AssemblyCode getAssembly ();