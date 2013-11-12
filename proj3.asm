;;; Casey Allred
;;; Project 3
        ;; TRP     #99
        ;; setup stack
        LDA     RSL STKLMT:
        LDR     RSB STKBTM:
        MOV     RSP RSB
        SUB     RFP RFP         ; delete anything that is in RFP (being doubly safe)

        ;; Call function "FMAIN"
        ;; Test for overflow
        MOV     R10 RSP
        ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
        CMP     R10 RSL
        BLT     R10 OVRFLW:
        ;; Create Activation Record and invoke F
        MOV     R10 RFP
        MOV     RFP RSP
        ADI     RSP #-4
        STR     R10 (RSP)
        ADI     RSP #-4
        ;; parameters on the stack
        ;; local varibales on the stack
        ;; Temp variables on the stack 
        ;; set the return address and jump
        MOV     R10 RPC         ; PC already at next instruction
        ADI     R10 #12
        STR     R10 (RFP)
        JMP     FMAIN:


        
EXIT:   TRP     #0
OVRFLW: LDB     R0 LTRCO:
        TRP     #3
        LDB     R0 NL:
        TRP     #3
        TRP     #0
UDRFLW: LDB     R0 LTRCU:
        TRP     #3
        LDB     R0 NL:
        TRP     #3
        TRP     #0
        
        ;; Functions
        ;; void opd(char s, int k, char j) {
FOPD:  	MOV     R10 RFP
	ADI     R10 #-8
        LDR     R6 (R10)         ; Get s
        MOV     R10 RFP
	ADI     R10 #-12
	LDR     R1 (R10)         ; Get k
        MOV     R10 RFP
	ADI     R10 #-16
	LDR     R2 (R10)         ; Get j
        ;; int t = 0;  // Local var
        MOV     R10 RFP
	ADI     R10 #-20
	LDR     R3 (R10)         ; Get t
        ;; zero init t
        LDR     R12 ZERO:
        AND     R3 R12
        
        ;; if (j == '0')      // Convert
        MOV     R4 R2
	ADI     R4 #-48
        BNZ     R4 0ELSE:
        ;; 	t = 0
        ADI     R3 #0           ;not really necessary,just there for consistency
        JMP     EIF0:
        ;; else if (j == '1')
0ELSE:  MOV     R4 R2
        ADI     R4 #-49
        BNZ     R4 1ELSE:
        ;; 	t = 1
        ADI     R3 #1
        JMP     EIF0:
        ;; else if (j == '2')
1ELSE:  MOV     R4 R2
        ADI     R4 #-50
        BNZ     R4 2ELSE:
        ;; 	t = 2
        ADI     R3 #2
        JMP     EIF0:
        ;; else if (j == '3')
2ELSE:  MOV     R4 R2
        ADI     R4 #-51
        BNZ     R4 3ELSE:
        ;; 	t = 3
        ADI     R3 #3
        JMP     EIF0:
        ;; else if (j == '4')
3ELSE:  MOV     R4 R2
        ADI     R4 #-52
        BNZ     R4 4ELSE:
        ;; 	t = 4
        ADI     R3 #4
        JMP     EIF0:
        ;; else if (j == '5')
4ELSE:  MOV     R4 R2
        ADI     R4 #-53
        BNZ     R4 5ELSE:
        ;; 	t = 5
        ADI     R3 #5
        JMP     EIF0:
        ;; else if (j == '6')
5ELSE:  MOV     R4 R2
        ADI     R4 #-54
        BNZ     R4 6ELSE:
        ;; 	t = 6
        ADI     R3 #6
        JMP     EIF0:
        ;; else if (j == '7')
6ELSE:  MOV     R4 R2
        ADI     R4 #-55
        BNZ     R4 7ELSE:
        ;; 	t = 7
        ADI     R3 #7
        JMP     EIF0:
        ;; else if (j == '8')
7ELSE:  MOV     R4 R2
        ADI     R4 #-56
        BNZ     R4 8ELSE:
        ;; 	t = 8
        ADI     R3 #8
        JMP     EIF0:
        ;; else if (j == '9')
8ELSE:  MOV     R4 R2
        ADI     R4 #-57
        BNZ     R4 9ELSE:
        ;; 	t = 9
        ADI     R3 #9
        JMP     EIF0:
        ;; else {
	;; 	printf("%c is not a number\n", j)
9ELSE:  MOV     R0 R2
        TRP     #1
        ;; print space
        LDB     R0 SP:
        TRP     #3
        ;; print "is"
        LDB     R0 LTRI:
        TRP     #3
        LDB     R0 LTRS:
        TRP     #3
        ;; print space
	LDB     R0 SP:
	TRP     #3
        ;; print "not"
        LDB     R0 LTRN:
	TRP     #3
	LDB     R0 LTRO:
	TRP     #3	
	LDB     R0 LTRT:
	TRP     #3
	;; print space
	LDB     R0 SP:
	TRP     #3
	;; print "a"
	LDB     R0 LTRA:
	TRP     #3	
	;; print space
	LDB     R0 SP:
	TRP     #3
        ;; print "number"
	LDB     R0 LTRN:
	TRP     #3
	LDB     R0 LTRU:
	TRP     #3	
	LDB     R0 LTRM:
	TRP     #3	
	LDB     R0 LTRB:
	TRP     #3
	LDB     R0 LTRE:
	TRP     #3	
	LDB     R0 LTRR:
	TRP     #3
        ;; print new line
	LDB     R0 NL:
	TRP     #3
        ;; 	flag = 1
        AND     R5 R12
        ADI     R5 #1
        STR     R5 FLAG:
        ;; }
        ;; if (!flag) {        
EIF0:   LDR     R5 FLAG:
        BNZ     R5 EIF1:
        ;; 	if (s == '+')
        ADI     R6 #-43
        BNZ     R6 PLSEL:
        ;; 		t *= k
        MUL     R3 R1
        JMP     EIF2:
        ;; 	else
        ;; 		t *= -k
PLSEL:  AND     R7 R12
        ADI     R7 #-1
        MUL     R1 R7
        MUL     R3 R1
        ;; 	opdv += t        
EIF2:   LDR     R8 OPDV:
        ADD     R8 R3
        STR     R8 OPDV:
        ;; }	
	;; }
        ;; return from function
	;; test for underflow
EIF1:   MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	;; store the return value
	JMR     R10             ; go back

        ;; void flush() {	
	;; data = 0
FFLUSH: LDR     R12 ZERO:
        STR     R12 DATA:
        ;; c[0] = getchar()
        LDR     R0 C:
        TRP     #4
        STR     R0 C:
        ;; while (c[0] != '\n')
        MOV     R1 R0
        ADI     R1 #-10	
        BRZ     R1 FFEWHL:
        ;; 	c[0] = getchar()
	LDR     R0 C:
	TRP     #4
	STR     R0 C:
        ;; }
        ;; return from function
	;; test for underflow
FFEWHL: MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	JMR     R10             ; go back
        
        ;; void getdata() {	
FGTDTA: LDR     R1 CNT:
        LDR     R2 SIZE:
        SUB     R1 R2
        ;; if (cnt < SIZE) { // Get data if there is room
        BRZ     R1 DTAELS:
        BGT     R1 DTAELS:      ; just in case for some reason they aren't equal but cnt is bigger
        ;; 	c[cnt] = getchar();  // Your TRP 4 should work like getchar()
        LDA     R10 C:
        LDR     R11 CNT:
        LDR     R12 ASIZE:
        MUL     R11 R12
        ADD     R10 R11
        TRP     #4
        STR     R0 (R10)
        ;; 	cnt++
        LDR     R11 CNT:
        ADI     R11 #1
        STR     R11 CNT:
        ;; } else {	
	JMP     DAENIF:
        ;; 	printf("Number too Big\n")
        ;; print out Number
DTAELS: LDB     R0 LTRCN:
        TRP     #3	
	LDB     R0 LTRU:
	TRP     #3	
	LDB     R0 LTRM:
	TRP     #3	
	LDB     R0 LTRB:
	TRP     #3
	LDB     R0 LTRE:
	TRP     #3	
	LDB     R0 LTRR:
	TRP     #3
	;; print space
	LDB     R0 SP:
	TRP     #3
        ;; print too
        LDB     R0 LTRT:
        TRP     #3
        LDB     R0 LTRO:
        TRP     #3
        TRP     #3	
	;; print space
	LDB     R0 SP:
	TRP     #3
        ;; print Big
	LDB     R0 LTRCB:
        TRP     #3
        LDB     R0 LTRI:
        TRP     #3
        LDB     R0 LTRG:
        TRP     #3	
	;; print new line
	LDB     R0 NL:
	TRP     #3
        ;; 	flush()
  	;; Call function "FLUSH"
        ;; Test for overflow
        MOV     R10 RSP
        ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
        CMP     R10 RSL
        BLT     R10 OVRFLW:
        ;; Create Activation Record and invoke F
        MOV     R10 RFP
        MOV     RFP RSP
        ADI     RSP #-4
        STR     R10 (RSP)
        ADI     RSP #-4
        ;; parameters on the stack
        ;; local varibales on the stack
        ;; Temp variables on the stack 
        ;; set the return address and jump
        MOV     R10 RPC         ; PC already at next instruction
        ADI     R10 #12
        STR     R10 (RFP)
        JMP     FFLUSH:
        ;; }
       	;; return from function
        ;; test for underflow
DAENIF: MOV     RSP RFP
        MOV     R10 RSP
        CMP     R10 RSB
        BGT     R10 UDRFLW:     ; oopsy underflow problem
        ;; set previous frame to current frame and return
        LDR     R10 (RFP)
        MOV     R11 RFP
        ADI     R11 #-4         ; now pointing at PFP
        LDR     RFP (R11)       ; make FP = PFP
        ;; store the return value
        JMR     R10             ; go back
        ;; }

        ;; void reset(int w, int x, int y, int z) {
FRESET: MOV     R10 RFP
	ADI     R10 #-8
	LDR     R1 (R10)         ; Get w (R1)
	MOV     R10 RFP
	ADI     R10 #-12
	LDR     R2 (R10)         ; Get x (R2)
	MOV     R10 RFP
	ADI     R10 #-16
	LDR     R3 (R10)         ; Get y (R3)	
	MOV     R10 RFP
	ADI     R10 #-20
	LDR     R4 (R10)         ; Get z (R4)
	;; int k;  // Local var
	MOV     R10 RFP
	ADI     R10 #-24
	LDR     R5 (R10)         ; Get k (R5)
        ;; for (k= 0; k < SIZE; k++)	
	;; zero init k
	LDR     R12 ZERO:
	AND     R5 R12
        LDR     R7 SIZE:
        ;; k < SIZE
REFOR:  MOV     R6 R5
        SUB     R6 R7
        BRZ     R6 EREFOR:
        ;;      c[k] = 0;
        LDA     R8 C:
        LDR     R9 ASIZE:
        MUL     R9 R5
        ADD     R8 R9
        STR     R12 (R8)
        ;; k++
        ADI     R5 #1
        JMP     REFOR:
        
        ;; data = w;
EREFOR: STR     R1 DATA:
        ;; opdv = x;
        STR     R2 OPDV:
        ;; cnt  = y;
        STR     R3 CNT:
        ;; flag = z;
        STR     R4 FLAG:
        ;; }
        ;; return from function
	;; test for underflow
	MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	;; store the return value
	JMR     R10             ; go back


        ;; void main() {	
	;; reset(1, 0, 0, 0); // Reset globals
        ;; Call function "reset"
	;; Test for overflow
FMAIN:  MOV     R10 RSP
	ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke reset
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
        LDR     R1 ZERO:
	ADI     R1 #1           ; w
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; x
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; y
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; z
	STR     R1 (RSP)
	ADI     RSP #-4
	;; local varibales on the stack	
	LDR     R1 ZERO:        ; k
	STR     R1 (RSP)
	ADI     RSP #-4
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FRESET:
        ;; getdata();         // Get data
        MOV     R10 RSP
	ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke getdata
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	;; local varibales on the stack	
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FGTDTA:
        ;; while (c[0] != '@') { // Check for stop symbol '@'
MWH1:   LDR     R10 C:
        LDB     R11 AT:
        SUB     R10 R11
        BRZ     R10 EMWH1:
        ;;      if (c[0] == '+' || c[0] == '-') { // Determine sign
        ;; c[0] == '+'
        LDR     R10 C:
        LDB     R11 PLUS:
        SUB     R10 R11
        BRZ     R10 MIF1:
        ;; c[0] == '-'
        LDR     R10 C:
        LDB     R11 MINUS:
        SUB     R10 R11
        BNZ     R10 MIFE1:
        ;; 	        getdata(); // Get most significant byte
MIF1:   MOV     R10 RSP
	ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke getdata
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	;; local varibales on the stack	
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FGTDTA:
        JMP     MIFD1:
        ;;	} else {  // Default sign is '+'	
	;; 		c[1] = c[0]; // Make room for the sign
MIFE1:  LDR     R11 ASIZE:
        LDA     R10 C:
        ADD     R11 R10
        LDR     R12 (R10)       ; load c[0]
        STR     R12 (R11)       ; store it in c[1]
        ;; 		c[0] = '+';
        LDB     R12 PLUS:       ; load the + byt (other bytes are 0)
        STR     R12 (R10)       ; store that at c[0]
        ;; 		cnt++;
        LDR     R10 CNT:
        ADI     R10 #1
        STR     R10 CNT:
        ;; 	}
MIFD1:  ADI     R0 #0           ; holder for label of end of if
        ;; 	while(data) {  // Loop while there is data to process
MWH2:   LDR     R10 DATA:
        BRZ     R10 EMWH2:
        ;;      	if (c[cnt-1] == '\n') { // Process data now
MIF2:   LDR     R10 CNT:
        ADI     R10 #-1
        LDR     R11 ASIZE:
        MUL     R10 R11         ; offset
        LDA     R12 C:          ; base
        ADD     R12 R10
        LDR     R10 (R12)
        LDB     R11 NL:
        SUB     R10 R11
        BNZ     R10 MIFEL2:
        ;; 			data = 0;
        LDR     R10 ZERO:
        STR     R10 DATA:
        ;; 			tenth = 1;
        LDR     R10 ONE:
        STR     R10 TENTH:
        ;;                      cnt = cnt - 2;
        LDR     R10 CNT:
        ADI     R10 #-2
        STR     R10 CNT:
        ;;      		while (!flag && cnt != 0) { // Compute a number
MWH3:   LDR     R10 FLAG:
        BNZ     R10 EMWH3:
        LDR     R10 CNT:
        BRZ     R10 EMWH3:
        ;; 				opd(c[0], tenth, c[cnt]);	
	;; Call function "FOPD"
	;; Test for overflow
	MOV     R10 RSP
	ADI     R10 #-24        ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke opd
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	LDR     R1 C:           ; s
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 TENTH:       ; k
	STR     R1 (RSP)
	ADI     RSP #-4
        LDR     R10 CNT:        ; j
        LDR     R11 ASIZE:
	MUL     R10 R11         ; offset
	LDA     R12 C:          ; base
	ADD     R12 R10
	LDR     R1 (R12)
	STR     R1 (RSP)
	ADI     RSP #-4
	;; local varibales on the stack
	LDR     R1 ZERO:        ; t
	STR     R1 (RSP)
	ADI     RSP #-4
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FOPD:
        ;; 				cnt--;
        LDR     R10 CNT:
        ADI     R10 #-1
        STR     R10 CNT:
        ;; 				tenth *= 10;
        LDR     R10 TENTH:
        LDR     R11 TEN:
        MUL     R10 R11
        STR     R10 TENTH:
        ;; 			}
	JMP	MWH3:
	;; 			if (!flag)  //  Good number entered
EMWH3:  LDR     R10 FLAG:
        BNZ     R10 MIFE2:
        ;; 				printf("Operand is %d\n", opdv);
        ;; print Operand
        LDB     R0 LTRCO:
        TRP     #3
        LDB     R0 LTRP:
        TRP     #3
        LDB     R0 LTRE:
        TRP     #3
        LDB     R0 LTRR:
        TRP     #3
        LDB     R0 LTRA:
        TRP     #3
        LDB     R0 LTRN:
        TRP     #3
        LDB     R0 LTRD:
        TRP     #3
        ;; print space
        LDB     R0 SP:
        TRP     #3
        ;; print is
        LDB     R0 LTRI:
        TRP     #3
        LDB     R0 LTRS:
        TRP     #3
        ;; print space
        LDB     R0 SP:
        TRP     #3
        ;; print opdv
        LDR     R0 OPDV:
        TRP     #1
        ;; print new line
        LDB     R0 NL:
        TRP     #3
        JMP     MIFE2:
        ;; 		}
        ;; 		else	
	;; 			getdata(); // Get next byte of data
MIFEL2: MOV     R10 RSP
	ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke getdata
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	;; local varibales on the stack	
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FGTDTA:
MIFE2:  JMP	MWH2:
        ;; 	}
        ;; 	reset(1, 0, 0, 0);  // Reset globals        
EMWH2:  MOV     R10 RSP
	ADI     R10 #-28          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke reset
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	LDR     R1 ZERO:
	ADI     R1 #1           ; w
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; x
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; y
	STR     R1 (RSP)
	ADI     RSP #-4	
	LDR     R1 ZERO:        ; z
	STR     R1 (RSP)
	ADI     RSP #-4
	;; local varibales on the stack	
	LDR     R1 ZERO:        ; k
	STR     R1 (RSP)
	ADI     RSP #-4
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FRESET:
        ;; 	getdata();          // Get data
        MOV     R10 RSP
	ADI     R10 #-8          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke getdata
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	;; local varibales on the stack	
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FGTDTA:
        JMP     MWH1:
        ;; }
        ;; }
        ;; return from function
	;; test for underflow
EMWH1:  MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	;; store the return value
	JMR     R10             ; go back

        
        
        ;; global data
NL:     .BYT    '\n'
AT:     .BYT    '@'
PLUS:   .BYT    '+'
MINUS:  .BYT    '-'
SP:     .BYT    32
ZERO:   .INT    0
ONE:    .INT    1
TEN:    .INT    10
ASIZE:  .INT    4
        ;; is not a number
LTRI:   .BYT    'i'
LTRS:   .BYT    's'
LTRN:   .BYT    'n'
LTRCN:  .BYT    'N'
LTRO:   .BYT    'o'
LTRCO:  .BYT    'O'
LTRT:   .BYT    't'
LTRA:   .BYT    'a'
LTRU:   .BYT    'u'
LTRM:   .BYT    'm'
LTRB:   .BYT    'b'
LTRCB:  .BYT    'B'
LTRE:   .BYT    'e'
LTRR:   .BYT    'r'
LTRG:   .BYT    'g'
LTRP:   .BYT    'p'
LTRD:   .BYT    'd'
LTRCU:  .BYT    'U'
        ;; int  cnt
        ;; int  tenth
        ;; int  data
        ;; int  flag
        ;; int  opdv
        ;; const int  SIZE = 7
        ;; char c[SIZE]
CNT:    .INT    0
TENTH:  .INT    0
DATA:   .INT    0
FLAG:   .INT    0
OPDV:   .INT    0
SIZE:   .INT    7
C:      .BYT    0               ;[0]
        .BYT    0               ;[1]
        .BYT    0               ;[2]
        .BYT    0               ;[3]
        .BYT    0               ;[4]
        .BYT    0               ;[5]
        .BYT    0               ;[6]
        .BYT    0               ;[7]

STKLMT: TRP     #99             ;just a marker for top of the stack, meaningless TRP here
STKBTM: .INT    4999995         ;last int (address holder) of memory location




        ;; Instructions and meaning
;;; JMP LABEL    ;branch to label
;;; JMR RS       ;branch to address in souce register
;;; BNZ RS,LABEL ;branch to label if source register is not zero
;;; BGT RS,LABEL ;branch to label if source register is greater then zero
;;; BLT RS,LABEL ;branch to label if source register is less then zero
;;; BRZ RS,LABEL ;branch to label if source register is zero
;;; MOV RD,RS    ;move data from source register to destination register
;;; LDA RD,LABEL ;load address
;;; STR RS,LABEL ;store data into mem from source register
;;; LDR RD,LABEL ;load destination register with data from mem
;;; STB RS,LABEL ;store byte into mem from source register
;;; LDB RD,LABEL ;load destination register with byte from mem
;;; ADD RD,RS    ;add source register to destination register, result in destination register
;;; ADI RD,IMM   ;add immediate data to destination register
;;; SUB RD,RS    ;subtract source register from destination register, result in destination register
;;; MUL RD,RS    ;multiply source register by destination register, result in destination register
;;; DIV RD,RS    ;divide destination register by source register, result in destination register
;;; AND RD,RS    ;perform boolean AND operation, result in destination register
;;; OR RD,RS     ;perform a boolean OR opertion, result in destination register
;;; CMP RD,RS    ;set destination register to zero if destination is equal to source; set destination register to greater than zero if destination is greater than source; set destination register to less than zero if destination is less than source
;;; TRP IMM      ;execute an I/O routine (a type of operation system or library routine) (1) write integer to standard out (2) read an integer from standard in (3) write character to standard out (4) read a character from standar in
;;; TRP IMM      ;execute STOP trap routine (0) stop program
;;; TRP IMM      ;execute a converstion trap routine. Only one char at a time is converted (10) char to int (11) int to char
;;; TRP IMM      ;debug (99) if you use the TRP its output must be suppressed in teh version of code you supply me
;;; .INT value   ;integer
;;; .ALN         ;align the next byte ona word boundary (NOT USED)
;;; .BYT value   ;a byte
