LDA     R9 FREE:
;; Call function "MAIN:"
;; Test for overflow
MOV     R10 RSP
ADI     R10 #-96          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
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
ADI     RSP #-4
ADI     RSP #-4
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
Li37:	.INT	8
Li59:	.INT	7
Li65:	.INT	2
Li55:	.BYT	'!'
Li69:	.INT	1
Li40:	.BYT	'='
Li22:	.INT	3
Li38:	.BYT	'a'
Li45:	.BYT	'E'
Li42:	.BYT	'\n'
Li56:	.INT	9
Li57:	.BYT	0
Li74:	.INT	4
Li23:	.BYT	1
Li47:	.BYT	'y'
Li53:	.BYT	's'
Li39:	.BYT	32
Li46:	.BYT	'm'
Li52:	.BYT	'i'
Li73:	.BYT	'-'
;; functions
Co5:   ADI   R0 #0 ;    Casey(Emmy tmp) {
;; Call function "St19:        Casey(Emmy tmp) {"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-24          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke St19
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
;; local varibales on the stack    ;     Casey(Emmy tmp) {
;; Temp variables on the stack
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-24
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     St19:
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-16	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;	e2 = tmp;
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


Me6:   ADI   R0 #0 ;    public void printEmmys() {
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #0
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STR	R13 (R10)	;
;; Call function "Me15:    	e1.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDR	R13 (R10)	;
	LDR	R1 (R13)	;Load to register
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ; 	e1.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;	e1.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #4
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-20	;
	STR	R13 (R10)	;
;; Call function "Me15:    	e2.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;Load Address
	ADI	R10 #-20	;
	LDR	R13 (R10)	;
	LDR	R1 (R13)	;Load to register
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ; 	e2.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;	e2.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-24	;
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
JMR     R15             ; go back "    }"


St19:   ADI   R0 #0 ;}
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #0
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STR	R13 (R10)	;
;; Test for heap overflow
	MOV     R10 R9
ADI     R10 #5
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADI     R9 #5
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R11 (R10)	;
;; Call function "Co12:        private Emmy e1 = new Emmy(3,true);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-30          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Co12
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
;; parameters on the stack (Li22)  ;     private Emmy e1 = new Emmy(3,true);
	LDR	R1 Li22:	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li23)  ;     private Emmy e1 = new Emmy(3,true);
	LDB	R1 Li23:	;
STB     R1 (RSP)
ADI     RSP #-1
;; local varibales on the stack    ;     private Emmy e1 = new Emmy(3,true);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-1
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-30
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Co12:
	LDR	R11 (RSP)	;    private Emmy e1 = new Emmy(3,true);
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    private Emmy e1 = new Emmy(3,true);
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
	ADI	R10 #-20	;
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


Co12:   ADI   R0 #0 ;    Emmy(int age, bool yeah) {
;; Call function "St32:        Emmy(int age, bool yeah) {"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-17          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke St32
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
;; local varibales on the stack    ;     Emmy(int age, bool yeah) {
;; Temp variables on the stack
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-17
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     St32:
	LDB	R0 Li38:	;
	TRP	#3	;	cout << 'a';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	LDB	R0 Li40:	;
	TRP	#3	;	cout << '=';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-17	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-17	;
	LDR	R13 (R10)	;
	LDR	R0 (R13)	;Load to register
	TRP	#1	;	cout << ageMonths;
	LDB	R0 Li42:	;
	TRP	#3	;	cout << '\n';
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-21	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;	ageMonths = age;
	ADI	R10 #-12	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-21	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #0
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-25	;
	STB	R13 (R10)	;
	MOV	R10 RFP	;	awesome = yeah;
	ADI	R10 #-16	;
	LDB	R3 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-25	;
	LDB	R13 (R10)	;
	STB	R3 (R13)	;Save from Register
	LDB	R0 Li45:	;
	TRP	#3	;	cout << 'E';
	LDB	R0 Li46:	;
	TRP	#3	;	cout << 'm';
	LDB	R0 Li46:	;
	TRP	#3	;	cout << 'm';
	LDB	R0 Li47:	;
	TRP	#3	;	cout << 'y';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	LDB	R0 Li40:	;
	TRP	#3	;	cout << '=';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-26	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-26	;
	LDR	R13 (R10)	;
	LDR	R0 (R13)	;Load to register
	TRP	#1	;	cout << ageMonths;
	LDB	R0 Li42:	;
	TRP	#3	;	cout << '\n';
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


Me14:   ADI   R0 #0 ;    public void addMonthToAge(int months) {
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-16	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-20	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R4 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-20	;
	LDR	R13 (R10)	;
	LDR	R3 (R13)	;Load to register
	ADD	R3 R4	;	ageMonths = ageMonths + months;
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	STR	R3 (R10)	;
	MOV	R10 RFP	;	ageMonths = ageMonths + months;
	ADI	R10 #-24	;
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
;; set previous frame to current frame and return
MOV     R11 RFP
ADI     R11 #-4         ; now pointing at PFP
LDR     RFP (R11)       ; make FP = PFP
JMR     R15             ; go back "    }"


Me15:   ADI   R0 #0 ;    public void printAge() {
	LDB	R0 Li45:	;
	TRP	#3	;	cout << 'E';
	LDB	R0 Li46:	;
	TRP	#3	;	cout << 'm';
	LDB	R0 Li46:	;
	TRP	#3	;	cout << 'm';
	LDB	R0 Li47:	;
	TRP	#3	;	cout << 'y';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	LDB	R0 Li52:	;
	TRP	#3	;	cout << 'i';
	LDB	R0 Li53:	;
	TRP	#3	;	cout << 's';
	LDB	R0 Li39:	;
	TRP	#3	;	cout << ' ';
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STR	R13 (R10)	;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDR	R13 (R10)	;
	LDR	R0 (R13)	;Load to register
	TRP	#1	;	cout << ageMonths;
	LDB	R0 Li55:	;
	TRP	#3	;	cout << '!';
	LDB	R0 Li42:	;
	TRP	#3	;	cout << '\n';
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


St32:   ADI   R0 #0 ;}
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #0
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-12	;
	STB	R13 (R10)	;
	LDB	R3 Li23:	;    private bool awesome = true;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-12	;
	LDB	R13 (R10)	;
	STB	R3 (R13)	;Save from Register
	MOV	R10 RFP	;
	ADI	R10 #-8	;
	LDR	R13 (R10)	;
	SUB	R14 R14
	ADI	R14 #1
	ADD	R13 R14
	MOV	R10 RFP	;Save Address
	ADI	R10 #-13	;
	STR	R13 (R10)	;
	LDR	R3 Li37:	;    public int ageMonths = 8;
	MOV	R10 RFP	;Load Address
	ADI	R10 #-13	;
	LDR	R13 (R10)	;
	STR	R3 (R13)	;Save from Register
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
;; Test for heap overflow
	MOV     R10 R9
ADI     R10 #5
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADI     R9 #5
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	STR	R11 (R10)	;
;; Call function "Co12:        Emmy e = new Emmy(9, false);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-30          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Co12
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li56)  ;     Emmy e = new Emmy(9, false);
	LDR	R1 Li56:	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li57)  ;     Emmy e = new Emmy(9, false);
	LDB	R1 Li57:	;
STB     R1 (RSP)
ADI     RSP #-1
;; local varibales on the stack    ;     Emmy e = new Emmy(9, false);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-1
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-30
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Co12:
	LDR	R11 (RSP)	;    Emmy e = new Emmy(9, false);
	MOV	R10 RFP	;
	ADI	R10 #-24	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    Emmy e = new Emmy(9, false);
	ADI	R10 #-24	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	STR	R3 (R10)	;
;; Test for heap overflow
	MOV     R10 R9
ADI     R10 #5
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADI     R9 #5
	MOV	R10 RFP	;
	ADI	R10 #-28	;
	STR	R11 (R10)	;
;; Call function "Co12:        Emmy b = new Emmy(7, true);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-30          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Co12
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
;; parameters on the stack (Li59)  ;     Emmy b = new Emmy(7, true);
	LDR	R1 Li59:	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li23)  ;     Emmy b = new Emmy(7, true);
	LDB	R1 Li23:	;
STB     R1 (RSP)
ADI     RSP #-1
;; local varibales on the stack    ;     Emmy b = new Emmy(7, true);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-1
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-30
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Co12:
	LDR	R11 (RSP)	;    Emmy b = new Emmy(7, true);
	MOV	R10 RFP	;
	ADI	R10 #-28	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    Emmy b = new Emmy(7, true);
	ADI	R10 #-28	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	STR	R3 (R10)	;
;; Test for heap overflow
	MOV     R10 R9
ADI     R10 #8
CMP     R10 RSL
BGT     R10 HOVRFLW:
MOV     R11 R9
ADI     R9 #8
	MOV	R10 RFP	;
	ADI	R10 #-32	;
	STR	R11 (R10)	;
;; Call function "Co5:        Casey c = new Casey(b);"
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
	ADI	R10 #-32	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Lv17)  ;     Casey c = new Casey(b);
	MOV	R10 RFP	;
	ADI	R10 #-16	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     Casey c = new Casey(b);
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
	LDR	R11 (RSP)	;    Casey c = new Casey(b);
	MOV	R10 RFP	;
	ADI	R10 #-32	;
	STR	R11 (R10)	;
	MOV	R10 RFP	;    Casey c = new Casey(b);
	ADI	R10 #-32	;
	LDR	R3 (R10)	;
	MOV	R10 RFP	;
	ADI	R10 #-20	;
	STR	R3 (R10)	;
;; Call function "Me15:        e.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    e.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-36	;
	STR	R11 (R10)	;
;; Call function "Me15:        b.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
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
;; local varibales on the stack    ;     b.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    b.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-40	;
	STR	R11 (R10)	;
;; Call function "Me14:        e.addMonthToAge(2);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me14
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li65)  ;     e.addMonthToAge(2);
	LDR	R1 Li65:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.addMonthToAge(2);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me14:
	LDR	R11 (RSP)	;    e.addMonthToAge(2);
	MOV	R10 RFP	;
	ADI	R10 #-44	;
	STR	R11 (R10)	;
;; Call function "Me15:        e.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    e.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-48	;
	STR	R11 (R10)	;
;; Call function "Me15:        b.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
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
;; local varibales on the stack    ;     b.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    b.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-52	;
	STR	R11 (R10)	;
;; Call function "Me14:        e.addMonthToAge(1);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me14
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; parameters on the stack (Li69)  ;     e.addMonthToAge(1);
	LDR	R1 Li69:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.addMonthToAge(1);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me14:
	LDR	R11 (RSP)	;    e.addMonthToAge(1);
	MOV	R10 RFP	;
	ADI	R10 #-56	;
	STR	R11 (R10)	;
;; Call function "Me15:        e.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    e.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-60	;
	STR	R11 (R10)	;
;; Call function "Me15:        b.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
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
;; local varibales on the stack    ;     b.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    b.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-64	;
	STR	R11 (R10)	;
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li42:	;
	TRP	#3	;    cout << '\n';
;; Call function "Me14:        b.addMonthToAge(4);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me14
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
;; parameters on the stack (Li74)  ;     b.addMonthToAge(4);
	LDR	R1 Li74:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     b.addMonthToAge(4);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me14:
	LDR	R11 (RSP)	;    b.addMonthToAge(4);
	MOV	R10 RFP	;
	ADI	R10 #-68	;
	STR	R11 (R10)	;
;; Call function "Me15:        e.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    e.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-72	;
	STR	R11 (R10)	;
;; Call function "Me15:        b.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
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
;; local varibales on the stack    ;     b.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    b.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-76	;
	STR	R11 (R10)	;
;; Call function "Me14:        b.addMonthToAge(2);"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me14
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
;; parameters on the stack (Li65)  ;     b.addMonthToAge(2);
	LDR	R1 Li65:	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     b.addMonthToAge(2);
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me14:
	LDR	R11 (RSP)	;    b.addMonthToAge(2);
	MOV	R10 RFP	;
	ADI	R10 #-80	;
	STR	R11 (R10)	;
;; Call function "Me15:        e.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-12	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     e.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    e.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-84	;
	STR	R11 (R10)	;
;; Call function "Me15:        b.printAge();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-16          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me15
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
;; local varibales on the stack    ;     b.printAge();
;; Temp variables on the stack
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-16
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me15:
	LDR	R11 (RSP)	;    b.printAge();
	MOV	R10 RFP	;
	ADI	R10 #-88	;
	STR	R11 (R10)	;
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li73:	;
	TRP	#3	;    cout << '-';
	LDB	R0 Li42:	;
	TRP	#3	;    cout << '\n';
;; Call function "Me6:        c.printEmmys();"
;; Test for overflow
:   MOV     R10 RSP
ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
CMP     R10 RSL
BLT     R10 OVRFLW:
;; Create Activation Record and invoke Me6
MOV     R10 RFP
MOV     R15 RSP
ADI     RSP #-4
STR     R10 (RSP)
ADI     RSP #-4
;; this
	MOV	R10 RFP	;
	ADI	R10 #-20	;
	LDR	R1 (R10)	;
STR     R1 (RSP)
ADI     RSP #-4
;; local varibales on the stack    ;     c.printEmmys();
;; Temp variables on the stack
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
ADI     RSP #-4
;; set the stack pointer
	MOV	RSP R15
	ADI	RSP #-28
;; set the frame pointer
MOV     RFP R15
;; set the return address and jump
MOV     R10 RPC         ; PC already at next instruction
ADI     R10 #12
STR     R10 (RFP)
JMP     Me6:
	LDR	R11 (RSP)	;    c.printEmmys();
	MOV	R10 RFP	;
	ADI	R10 #-92	;
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
