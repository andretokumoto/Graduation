#include "globals.h"
#include "symtab.h"
#include "cgen.h"
#include "assembly.h"
#include "binary.h"

char *get_register(Reg r){

   switch (r)
   {
    case $zero:
     return RZERO;
    break;

   case $t1:
     return RT1;
    break;

   case $t2:
     return RT2;
    break;

   case $t3:
     return RT3;
    break;

   case $t4:
     return RT4;
    break; 
   
    case $t5:
     return RT5;
    break;

   case $t6:
     return RT6;
    break;

   case $t7:
     return RT7;
    break;

   case $t8:
     return RT8;
    break;

   case $t9:
     return RT9;
    break; 

   case $t10:
     return RT10;
    break;

   case $t11:
     return RT11;
    break;

   case $t12:
     return RT12;
    break;

   case $p1:
     return RP1;
    break;

   case $p2:
     return RP2;
    break;

   case $p3:
     return RP3;
    break;

   case $p4:
     return RP4;
    break;

   case $p5:
     return RP5;
    break;

   case $p6:
     return RP6;
    break;        

   case $s1:
     return RS1;
    break;

   case $s2:
     return RS2;
    break;

   case $s3:
     return RS3;
    break;

   case $s4:
     return RS4;
    break;

   case $s5:
     return RS5;
    break;

   case $s6:
     return RS6;
    break;  

   case $sp:
     return RSP;
    break;  

   case $bp:
     return RBP;
    break;  

   case $ra:
     return RA;
   break;  

   case $ret:
     return RRET;
   break;  

   default:
    break;
   }
}

char *get_op(InstrKind tipo){

   switch (tipo)
   {
    case add:
      return OP_ADD;
    break;

    case sub:
      return OP_SUB;
    break;   

    case mult:
      return OP_MULT;
    break;

    case divi:
      return OP_DIV;
    break; 
    
    case or:
      return OP_OR;
    break;

    case xor:
      return OP_XOR;
    break;   


    case lw:
      return OP_LW;
    break; 

    case sw:
      return OP_SW;
    break;   

    case in:
      return OP_IN;
    break;

    case out:
      return OP_OUT;
    break;   
    
    case addi:
      return OP_ADDI;
    break;

    case subi:
      return OP_SUBI;
    break;   

    case multi:
      return OP_MULTI;
    break;

    case divim:
      return OP_DIVI;
    break; 

    case andi:
      return OP_ANDI;
    break;

    case ori:
      return OP_ORI;
    break; 

    case beq:
      return OP_BEQ;
    break;

    case bne:
      return OP_BNE;
    break; 

    case blt:
      return OP_BLT;
    break;

    case bgt:
      return OP_BGT;
    break; 

    case bleq:
      return OP_BLEQ;
    break; 

    case bgeq:
      return OP_BGEQ;
    break;

    case j:
      return OP_J;
    break; 

    case jra:
      return OP_JR;
    break; 

    case jr:
      return OP_JR;
    break;

    case mov:
      return OP_MOV;
    break; 

    case movi:
      return OP_MOVI;
    break; 

    case end:
      return OP_END;
    break;

    case pause:
      return OP_PAUSE;
    break;

    case spc:
      return OP_SPC;
    break;

    default:
    break;
   }

}

char * assumbly_para_binario (Instruction i) {

    char * bin = (char *) malloc(200 * sizeof(char));
 

    if (i.format == formatR) {
            sprintf(bin, "%s,%s,%s,%s,%s", get_op(i.opcode), get_register(i.reg1), get_register(i.reg2), get_register(i.reg3), "11'd0");
    }
    else if (i.format == format_I) {
        if(i.opcode == lw)
            sprintf(bin, "%s,%s,%s,16'd%i", get_op(i.opcode), get_register(i.reg1), get_register(i.reg2),i.im);
        else if(i.opcode == sw)
            sprintf(bin, "%s,%s,%s,%s,11'd%i", get_op(i.opcode),RZERO, get_register(i.reg2), get_register(i.reg1), i.im);
        else
            sprintf(bin, "%s,%s,%s,16'd%i", get_op(i.opcode), get_register(i.reg1), get_register(i.reg2), i.im);
    }
    else if (i.format == formatO) {
        if (i.opcode == in)
            sprintf(bin, "%s,%s,%s", OP_IN, get_register(i.reg1),"21'd0");
        if (i.opcode == out)
            sprintf(bin, "%s,%s,%s,%s", OP_OUT, RZERO, get_register(i.reg1), "16'd0");
    }
    else {
        if (i.opcode == jra )
            sprintf(bin, "%s,%s,%s,%s,%s",OP_JR, RZERO,RA,RZERO,"11'd0");
        else if (i.opcode == jr )
            sprintf(bin, "%s,%s,%s,%s,%s", OP_JR , RZERO,get_register(i.reg1), RZERO,"11'd0");
        else if (i.opcode == jal )
            sprintf(bin, "%s,%s,%s,%s,11'd%i", OP_JAL,RZERO,RBP,RZERO,i.im);  
        else
            sprintf(bin, "%s,26'd%i", get_op(i.opcode),i.im);
         
    }
    return bin;
}

void generateBinary (AssemblyCode head) {
    AssemblyCode a = head;
    FILE * c = code;
    char * bin;

    printf("\nC- Binary Code\n");

    while (a != NULL) {
        if (a->kind == instr) {

            fprintf(c, "memoria[32'd%d] ={", a->lineno);
            printf("memoria[32'd%d] =" , a->lineno);
            bin = assumbly_para_binario(a->line.instruction);
            fprintf(c, "%s};\n",bin);
            printf("%s;\n", bin);
        }
        else {
            fprintf(c, "//%s\n", a->line.label);
            printf("//.%s\n", a->line.label);
        }
        a = a->next;
    }
}