        ;; Call function "MAIN:"
        ;; Test for overflow
        MOV     R10 RSP
        ADI     R10 #-12          ; 4 bytes for Return address & 4 bytes for Previous Frame Pointer 4 bytes for this (+ params) (+ local variables) (+ temp variables)
        CMP     R10 RSL
        BLT     R10 OVRFLW:
        ;; Create Activation Record and invoke F
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
        ;; Temp variables on the stack 
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
UDRFLW: LDB     R0 LTRCU:
	TRP     #3
	LDB     R0 NL:
	TRP     #3
	TRP     #0
        	
	        
	;; global data
NL:     .BYT    '\n'
LTRCU:  .BYT    'U'        	
LTRCO:  .BYT    'O'
        
        ;; functions
