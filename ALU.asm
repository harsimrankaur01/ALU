ORG 100h
.MODEL SMALL
.STACK 200h

.DATA
num1 DW ?
num2 DW ?
result DW ?
choice DB ?

INVALID_CHOICE_MSG DB "Invalid choice. Please enter a valid choice ~.", 0
RESULT_MSG DB "Result: $"

FIRST_NUM_PROMPT DB 0ah,0dh,"Enter first number: $"
SECOND_NUM_PROMPT DB 0ah,0dh,"Enter second number: $"
OPERATION_PROMPT DB 0ah,0dh,"Enter operation (+, -, *, /, &, v, ^, >, <, ],[,I, D, C):$"

YOUR_RESULT_MSG DB 0ah,0dh,"Your result is: $"

.CODE
HELLO PROC
MOV AX, @DATA
MOV DS, AX

CALL INPUT_NUM1        
CALL INPUT_NUM2        
CALL INPUT_CHOICE      

#................ARITHMETIC OPERATIONS............
 
CMP choice, '+'
JE ADD_OPERATION 
CMP choice, '-'
JE SUB_OPERATION
CMP choice, '*'
JE MULTIPLY_OPERATION
CMP choice, '/'
JE DIVIDE_OPERATION

CMP choice, 'I'
JE INCREMENT_OPERATION
CMP choice, 'D'
JE DECREMENT_OPERATION
CMP choice, '='
JE COMPARE_OPERATION
 

#................LOGICAL OPERATIONS................

CMP choice, '&'
JE AND_OPERATION
CMP choice, 'v'
JE OR_OPERATION    
CMP choice, '^'
JE XOR_OPERATION
CMP choice, 'C'
JE COMPLEMENT_OPERATION

#..............SHIFT/ROTATE OPERATIONS.............

CMP choice, '>'
JE RIGHT_SHIFT_OPERATION
CMP choice, '<'
JE LEFT_SHIFT_OPERATION
CMP choice, '['
JE ROTATE_LEFT_OPERATION
CMP choice, ']'
JE ROTATE_RIGHT_OPERATION


#...........INVALID CHOICE........................

CALL DISPLAY_INVALID_CHOICE
JMP EXIT


ADD_OPERATION:
MOV AX, num1
ADD AX, num2
MOV result, AX
JMP DISPLAY_RESULT

SUB_OPERATION:
MOV AX, num1
SUB AX, num2
MOV result, AX
JMP DISPLAY_RESULT 


MULTIPLY_OPERATION:
MOV AX, num1
MUL num2
MOV result, AX
JMP DISPLAY_RESULT

DIVIDE_OPERATION:
MOV AX, num1
MOV BX, num2
DIV BL
XOR AH, AH
MOV result, AX
JMP DISPLAY_RESULT


AND_OPERATION:
MOV AX, num1
AND AX, num2
MOV result, AX
JMP DISPLAY_RESULT 


COMPLEMENT_OPERATION:
MOV AX, num1
NEG AX   
XOR AH, AH
MOV result, AX
JMP DISPLAY_RESULT



OR_OPERATION:
MOV AX, num1
OR AX, num2
MOV result, AX
JMP DISPLAY_RESULT

XOR_OPERATION:
MOV AX, num1
XOR AX, num2
MOV result, AX
JMP DISPLAY_RESULT



RIGHT_SHIFT_OPERATION:
MOV AX, num1
MOV BX, num2
MOV CL, BL
SHR AX, CL
MOV result, AX
JMP DISPLAY_RESULT

LEFT_SHIFT_OPERATION:
MOV AX, num1
MOV BX, num2
MOV CL, BL
SHL AX, CL
MOV result, AX
JMP DISPLAY_RESULT

ROTATE_LEFT_OPERATION:
MOV AX, num1
MOV BX, num2
MOV CL, BL
ROL AX, CL
MOV result, AX
JMP DISPLAY_RESULT

ROTATE_RIGHT_OPERATION:
MOV AX, num1
MOV BX, num2
MOV CL, BL
ROR AX, CL
MOV result, AX
JMP DISPLAY_RESULT

COMPARE_OPERATION:
MOV AX, num1
CMP AX, num2
JMP DISPLAY_RESULT

INCREMENT_OPERATION:
MOV AX, num1
INC AX
MOV result, AX
JMP DISPLAY_RESULT

DECREMENT_OPERATION:
MOV AX, num1
DEC AX
MOV result, AX
JMP DISPLAY_RESULT



#...............DISPLAY RESULT or error...............

DISPLAY_RESULT:
LEA SI, YOUR_RESULT_MSG
CALL DISPLAY_STRING
MOV AX, result
CALL DISPLAY_NUM
JMP EXIT

DISPLAY_INVALID_CHOICE:
LEA SI, INVALID_CHOICE_MSG
CALL DISPLAY_STRING
JMP EXIT

EXIT:
MOV AH, 4Ch
INT 21h

INPUT_NUM1 PROC
    LEA SI, FIRST_NUM_PROMPT
    CALL DISPLAY_STRING
    XOR AX, AX
    MOV CX, 10
INPUT_LOOP:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE EXIT_INPUT_LOOP                                                
    CMP AL, 10
    JE EXIT_INPUT_LOOP
    SUB AL, '0'
    MOV BL, AL
    MOV AX, num1
    MUL CX
    ADD AX, BX
    MOV num1, AX
    JMP INPUT_LOOP
EXIT_INPUT_LOOP:
    RET
INPUT_NUM1 ENDP    

INPUT_NUM2 PROC
    LEA SI, SECOND_NUM_PROMPT
    CALL DISPLAY_STRING
    XOR AX, AX
    MOV CX, 10
INPUT_LOOP2:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE EXIT_INPUT_LOOP2
    CMP AL, 10
    JE EXIT_INPUT_LOOP2
    SUB AL, '0'
    MOV BL, AL
    MOV AX, num2
    MUL CX
    ADD AX, BX
    MOV num2, AX
    JMP INPUT_LOOP2
EXIT_INPUT_LOOP2:
    RET
INPUT_NUM2 ENDP

INPUT_CHOICE PROC
    LEA SI, OPERATION_PROMPT
    CALL DISPLAY_STRING
    MOV AH, 01h
    INT 21h
    MOV choice, AL
    RET
INPUT_CHOICE ENDP

DISPLAY_STRING PROC
    MOV AH, 09
    MOV DX, SI
    INT 21h
    RET
DISPLAY_STRING ENDP

DISPLAY_NUM PROC
    MOV CX, 01h         
DISPLAY_LOOP:
    MOV BL, 100
    XOR DX, DX         
    DIV BL    
    MOV DL, AL
    MOV BH, AH         
    ADD DL, '0'        
    MOV AH, 02h        
    INT 21h
    MOV AL, BH 
    XOR AH, AH  
    MOV BL, 10
    XOR DX, DX         
    DIV BL    
    MOV DL, AL
    MOV BH, AH         
    ADD DL, '0'        
    MOV AH, 02h        
    INT 21h
    MOV AL, BH 
    XOR AH, AH  
    XOR DX, DX             
    MOV DL, AL         
    ADD DL, '0'        
    MOV AH, 02h        
    INT 21h  
    LOOP DISPLAY_LOOP                        
DISPLAY_NUM ENDP

END HELLO