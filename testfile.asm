LDA     R9 FREE:
;; Call function "MAIN:"
;; Test for overflow
MOV     R10 RSP
ADI     R10 #-52          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke MAIN
MOV     R10 RFP
MOV     RFP RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
SUB     R1 R1           ; get this from where its at
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack
;; local varibales on the stack
ADI     RSP #-4
ADI     RSP #-4
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     MAIN:
EXIT:   TRP     #0
OVRFLW: LDB     R0 LTRCO:
TRP     #3
LDB     R0 NL:
TRP     #3
TRP     #0
HOVRFLW: LDB     R0 LTRCH:
TRP     #3
LDB     R0 LTRCO:
TRP     #3
LDB     R0 NL:
TRP     #3
TRP     #0
UDRFLW: LDB     R0 LTRCU:
TRP     #3
LDB     R0 NL:
TRP     #3
TRP     #0
;; global data
NL:     .BYT    '\n'
LTRCU:  .BYT    'U'
LTRCO:  .BYT    'O'
LTRCH:  .BYT    'H'
Li32:	.INT	1
Li25:	.INT	10
Li14:	.INT	5
Li20:	.INT	0
Li30:	.INT	3
;; functions
Co5:   ADI   R0 #0 ;    Dogs(int tmp[]) {
;; Call function "St11:        Dogs(int tmp[]) {"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke St11
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     Dogs(int tmp[]) {
;; Temp variables on the stack
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     St11:
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-16	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;	o = tmp;
	ADI	R10 #-12	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-16	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
;; return from function
;; test for underflow
MOV     RSP RFP
LDR     R15 (RSP)
MOV     R10 RSP
CMP     R10 RSB
BGT     R10 UDRFLW:     ; oopsy underflow problem
;; store the return value
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R0 (R10)	;
STR     R0 (RSP)        ; R0 is whatever the value is for return
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "    }"


Me7:   ADI   R0 #0 ;    public void set(int t) {
        TRP     #99
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-16	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-16	;
	LDR	R13 (R10)	;
	LDR	R13 (R13)
	LDR	R14 Li20:	;
	SUB	R12 R12
	ADI	R12 #4
	MUL	R14 R12
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-20	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;	o[0] = t;
	ADI	R10 #-12	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-20	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
        TRP     #99
;; return from function
;; test for underflow
MOV     RSP RFP
LDR     R15 (RSP)
MOV     R10 RSP
CMP     R10 RSB
BGT     R10 UDRFLW:     ; oopsy underflow problem
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "    }"


Me8:   ADI   R0 #0 ;    public void print() {
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDR	R13 (R10)	;
	LDR	R13 (R13)
	LDR	R14 Li20:	;
	SUB	R12 R12
	ADI	R12 #4
	MUL	R14 R12
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-16	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-16	;
	LDR	R13 (R10)	;
	LDR	R0 (R13)	;Load to register
	TRP	#1	;	cout << o[0];
;; return from function
;; test for underflow
MOV     RSP RFP
LDR     R15 (RSP)
MOV     R10 RSP
CMP     R10 RSB
BGT     R10 UDRFLW:     ; oopsy underflow problem
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "    }"


St11:   ADI   R0 #0 ;}
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #0
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STR	R13 (R10)	;
	SUB	R4 R4	;    private int i[] = new int[5];
	ADI	R4 #4	;    private int i[] = new int[5];
	LDR	R3 Li14:	;
	MUL	R3 R4	;    private int i[] = new int[5];
	MOV	R10 RFP	;
	ADI	R10 #-20	;
	STR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-20	;
	LDR	R3 (R10)	;
;; Test for heap overflow
MOV     R10 R9
ADD     R10 R3
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADD     R9 R3
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    private int i[] = new int[5];
	ADI	R10 #-16	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-24	;
	STR	R13 (R10)	;
;; return from function
;; test for underflow
MOV     RSP RFP
LDR     R15 (RSP)
MOV     R10 RSP
CMP     R10 RSB
BGT     R10 UDRFLW:     ; oopsy underflow problem
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "}"


MAIN:   ADI   R0 #0 ;void main() {
	SUB	R4 R4	;    int os[] = new int[10];
	ADI	R4 #4	;    int os[] = new int[10];
	LDR	R3 Li25:	;
	MUL	R3 R4	;    int os[] = new int[10];
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	STR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	LDR	R3 (R10)	;
;; Test for heap overflow
MOV     R10 R9
ADD     R10 R3
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADD     R9 R3
	MOV	R10 RFP	;
	ADI	R10 #-20	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    int os[] = new int[10];
	ADI	R10 #-20	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	STR	R3 (R10)	;
;; Test for heap overflow
	MOV     R10 R9
ADI     R10 #8
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADI     R9 #8
	MOV	R10 RFP	;
	ADI	R10 #-28	;
	STR	R11 (R10)	;
;; Call function "Co5:        Dogs d2 = new Dogs(os);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-20          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Co5
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-28	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Lv9)  ;     Dogs d2 = new Dogs(os);
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     Dogs d2 = new Dogs(os);
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-20
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Co5:
	LDR	R11 (RSP)	;    Dogs d2 = new Dogs(os);
	MOV	R10 RFP	;
	ADI	R10 #-28	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    Dogs d2 = new Dogs(os);
	ADI	R10 #-28	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R3 (R10)	;
        TRP     #99
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDR	R13 (R10)	;
	LDR	R14 Li30:	;
	SUB	R12 R12
	ADI	R12 #4
	MUL	R14 R12
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-32	;
	STR	R13 (R10)	;
	LDR	R3 Li30:	;    os[3] = 3;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-32	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
        TRP     #99
;; Call function "Me7:        d2.set(1);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-24          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me7
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li32)  ;     d2.set(1);
	LDR	R1 Li32:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     d2.set(1);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-24
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me7:
	LDR	R11 (RSP)	;    d2.set(1);
	MOV	R10 RFP	;
	ADI	R10 #-36	;
	STR	R11 (R10)	;
;; Call function "Me8:        d2.print();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-20          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me8
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     d2.print();
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-20
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me8:
	LDR	R11 (RSP)	;    d2.print();
	MOV	R10 RFP	;
	ADI	R10 #-40	;
	STR	R11 (R10)	;
;; Call function "Me7:        d2.set(3);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-24          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me7
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li30)  ;     d2.set(3);
	LDR	R1 Li30:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     d2.set(3);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-24
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me7:
	LDR	R11 (RSP)	;    d2.set(3);
	MOV	R10 RFP	;
	ADI	R10 #-44	;
	STR	R11 (R10)	;
;; Call function "Me8:        d2.print();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-20          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me8
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     d2.print();
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-20
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me8:
	LDR	R11 (RSP)	;    d2.print();
	MOV	R10 RFP	;
	ADI	R10 #-48	;
	STR	R11 (R10)	;
;; return from function
;; test for underflow
MOV     RSP RFP
LDR     R15 (RSP)
MOV     R10 RSP
CMP     R10 RSB
BGT     R10 UDRFLW:     ; oopsy underflow problem
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "}"


;; Heap starts here
FREE:    .INT 0
