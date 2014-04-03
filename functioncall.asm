;;; Casey Allred
;;; Project 3
        ;; setup stack
        LDA     RSL STKLMT:
        LDR     RSB STKBTM:
        MOV     RSP RSB
        SUB     RFP RFP         ; delete anything that is in RFP (being doubly safe)

        ;; Call function "F"
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
        ADI     R1 #10          ; could just as easily done LDR R1 LBL:
        STR     R1 (RSP)
        ADI     RSP #-4
        ;; local varibales on the stack
        ;; Temp variables on the stack 
        ;; set the return address and jump
        MOV     R10 RPC         ; PC already at next instruction
        ADI     R10 #12
        STR     R10 (RFP)
        JMP     F:
        ;; get return value into R6
        LDR     R6 (RSP)

        ;; print out the return value
        MOV     R0 R6
        TRP     #1

        ;; print new line
        LDB     R0 NL:
        TRP     #3
        
        ;; continuing on after the jump
        ADD     R1 R1
        
        
EXIT:   TRP     #0
OVRFLW: TRP     #0
UDRFLW: TRP     #0
        
        ;; Functions
F:      ADD     R0 R0
        MOV     R1 RFP
        ADI     R1 #-8
        LDR     R0 (R1)         ; access the passed parameter
        TRP     #1

        ;; print new line
        LDB     R0 NL:
        TRP     #3

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
        STR     R0 (RSP)        ; R0 is wherever the value is for return
        JMR     R10             ; go back

        
        ;; Global data
NL:     .BYT    '\n'

STKLMT: TRP     #99             ;just a marker for top of the stack, meaningless TRP here
STKBTM: .INT    4999995         ;last int (address holder) of memory location
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
