;;; Casey Allred
;;; Project 4


        ;; test printing the array
        ;; set CNT: to 30 * 4  (one past the end)
        LDA     R6 ARY:
        ADI     R6 #120

        ;; set back to CNT: -1
        LDR     R7 ISZE:
        SUB     R6 R7
        ;; set front to 0
        LDA     R5 ARY:

        ;; while front < back
TWH2:   MOV     R4 R5
        SUB     R4 R6
        BGT     R4 ETWH2:

        ;; print front
        LDR     R0 (R5)
        TRP     #1
        ;; increment front
        LDR     R7 ISZE:
        ADD     R5 R7

        ;; print new line
	LDB     R0 NL:
	TRP     #3
        
        ;; print back
        LDR     R0 (R6)
        TRP     #1
        ;; decrement back
        LDR     R7 ISZE:
        SUB     R6 R7

        ;; print new line
	LDB     R0 NL:
	TRP     #3

        JMP     TWH2:

        ;; we're done for now
        ;; ETWH1:  TRP     #0
        

        ;; Call function "FMAIN"
        ;; Test for overflow
ETWH2:  MOV     R10 RSP
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

        ;; AAANDDD we're done
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

        ;; GLOBAL DATA
ZERO:   .INT    0	
NL:     .BYT    '\n'
SP:     .BYT    32
LTRCO:  .BYT    'O'        	
LTRCU:  .BYT    'U'
ISZE:   .INT    4

LTRA:   .BYT    'a'
LTRC:   .BYT    'c'
LTRCF:  .BYT    'F'
LTRF:   .BYT    'f'
LTRI:   .BYT    'i'
LTRL:   .BYT    'l'
LTRO:   .BYT    'o'
LTRR:   .BYT    'r'
LTRS:   .BYT    's'
LTRT:   .BYT    't'

CNT:    .INT    0
ARY:    .INT    0               ;0
        .INT    1
	.INT    2
	.INT    3
	.INT    4               ;4
	.INT    5
	.INT    6
	.INT    7
	.INT    8
	.INT    9               ;9
	.INT    10
	.INT    11
	.INT    12
	.INT    13
	.INT    14              ;14
	.INT    15
	.INT    16
	.INT    17
	.INT    18
	.INT    19              ;19
	.INT    20
	.INT    21
	.INT    22
	.INT    23
	.INT    24              ;24
	.INT    25
	.INT    26
	.INT    27
	.INT    28
	.INT    29              ;29

        
        ;; Functions

        ;; call FDOFAC:
FMAIN:	MOV     R10 RSP
	ADI     R10 #-12          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
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
	STR     R0 (RSP)        ; temp varaible to store last entered number
	ADI     RSP #-4
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FDOFAC:

        ;; print the array
	;; set front to 0
	LDA     R5 ARY:
	;; set back to CNT: -1
        LDR     R6 CNT:
	LDR     R7 ISZE:
        SUB     R6 R7
        ADD     R6 R5

	;; while front < back
TWH1:   MOV     R4 R5
	SUB     R4 R6
	BGT     R4 ETWH1:
        
	;; print front
	LDR     R0 (R5)
	TRP     #1
	;; increment front
	LDR     R7 ISZE:
	ADD     R5 R7
        
	;; print new line
	LDB     R0 NL:
	TRP     #3
	        
	;; print back
	LDR     R0 (R6)
	TRP     #1
	;; decrement back
	LDR     R7 ISZE:
	SUB     R6 R7

	;; print new line
	LDB     R0 NL:
	TRP     #3
        
	JMP     TWH1:

	;; we're done for now
        ;; ETWH1:  TRP     #0
        
        ;; return from function
	;; test for underflow
ETWH1:  MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	;; store the return value (if needed)	
	JMR     R10             ; go back


FFACT:  MOV     R10 RFP
	ADI     R10 #-8
	LDR     R1 (R10)        ; Get n (R1)

        ;; if n == 0 then return 1
        BNZ     R1 FFEL:
        ADI     R1 #1           ; setup return value of 1
        
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
	;; store the return value (if needed)
	STR     R1 (RSP)        ; R0 is wherever the value is for return
	JMR     R10             ; go back

        ;; call FFACT with n - 1
	;; Test for overflow
FFEL:   MOV     R10 RSP
	ADI     R10 #-12          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke F
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	ADI     R1 #-1          ; n - 1
	STR     R1 (RSP)	
	ADI     RSP #-4	
	;; local varibales on the stack
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FFACT:

        ;; get the return value
        LDR     R6 (RSP)

        ;; times the return value by n (must get again off stack)
        MOV     R10 RFP
	ADI     R10 #-8
	LDR     R1 (R10)        ; Get n (R1)
        MUL     R1 R6
        
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
	;; store the return value (if needed)	
	STR     R1 (RSP)        ; R0 is wherever the value is for return
	JMR     R10             ; go back

        

        ;; test count <= 15
FDOFAC:  LDR     R6 CNT:
        LDR     R7 ISZE:
        DIV     R6 R7
	ADI     R6 #-29
        BGT     R6 EWH1:

        ;; get value and test not 0
        TRP     #2
	BRZ     R0 EWH1:
	        
        ;; good to go lets get the value
        MOV     R10 RFP
	ADI     R10 #-8
	STR     R0 (R10)
        ;; CALL FFACT:
        ;; Test for overflow
	MOV     R10 RSP
	ADI     R10 #-12          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer (+ params) (+ local variables) (+ temp variables)
	CMP     R10 RSL
	BLT     R10 OVRFLW:
	;; Create Activation Record and invoke F
	MOV     R10 RFP
	MOV     RFP RSP
	ADI     RSP #-4
	STR     R10 (RSP)
	ADI     RSP #-4
	;; parameters on the stack
	STR     R0 (RSP)	
	ADI     RSP #-4	
	;; local varibales on the stack
	;; Temp variables on the stack 
	;; set the return address and jump
	MOV     R10 RPC         ; PC already at next instruction
	ADI     R10 #12
	STR     R10 (RFP)
	JMP     FFACT:

	;; get return value into R6
	LDR     R6 (RSP)

        ;; print "Factorial of X is Y"
        ;; print Factorial
        LDB     R0 LTRCF:
        TRP     #3
        LDB     R0 LTRA:
        TRP     #3
        LDB     R0 LTRC:
        TRP     #3
        LDB     R0 LTRT:
        TRP     #3
        LDB     R0 LTRO:
        TRP     #3
        LDB     R0 LTRR:
        TRP     #3
        LDB     R0 LTRI:
        TRP     #3
        LDB     R0 LTRA:
        TRP     #3
        LDB     R0 LTRL:
        TRP     #3
        ;; print space
        LDB     R0 SP:
        TRP     #3
        ;; print of
        LDB     R0 LTRO:
        TRP     #3
        LDB     R0 LTRF:
        TRP     #3	
	;; print space
	LDB     R0 SP:
	TRP     #3
        ;; print n
        MOV     R10 RFP
	ADI     R10 #-8
	LDR     R0 (R10)
        TRP     #1
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
	;; print out the return value	
	LDR     R0 (RSP)
	TRP     #1
	;; print new line
	LDB     R0 NL:
	TRP     #3

        ;; Store value entered in the array
        ;; get the address to store in
        LDA     R5 ARY:
        LDR     R6 CNT:
        ADD     R5 R6
	;; get value entered
	MOV     R10 RFP
	ADI     R10 #-8
	LDR     R1 (R10)
        ;; store it
        STR     R1 (R5)
        ;; update count
        LDR     R7 ISZE:
        ADD     R6 R7
        STR     R6 CNT:
        ;; Store result in the array
        ;; get the address to store in
	LDA     R5 ARY:
	LDR     R6 CNT:
	ADD     R5 R6
	;; get result	
	LDR     R1 (RSP)
        ;; store it
	STR     R1 (R5)
	;; update count
	LDR     R7 ISZE:
	ADD     R6 R7
	STR     R6 CNT:
	        
        JMP     FDOFAC:          ; WH1:
        ;; return from function
	;; test for underflow
EWH1:   MOV     RSP RFP
	MOV     R10 RSP
	CMP     R10 RSB
	BGT     R10 UDRFLW:     ; oopsy underflow problem
	;; set previous frame to current frame and return
	LDR     R10 (RFP)
	MOV     R11 RFP
	ADI     R11 #-4         ; now pointing at PFP
	LDR     RFP (R11)       ; make FP = PFP
	;; store the return value (if needed)	
	JMR     R10             ; go back

        
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
