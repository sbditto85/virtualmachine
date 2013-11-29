;;; To test threading and make sure its working

        ;; TRP     #99
        RUN     R0 PRINT:
        RUN     R0 PRINT:
        RUN     R0 PRINT:
        BLK
        LDR     R0 ZERO:
        ADI     R0 #10
        TRP     #3

        
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
	
        
        ;; PRINT:  LCK     PNTLCK:
PRINT:  TRP     #1

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
	LDR     R0 (RSP)
        TRP     #1
        LDB     R0 NL:
        TRP     #3

        ;; ULK     PNTLCK:
        END

PRINTA: TRP     #1
        TRP     #1
        TRP     #1
        END

PNTLCK: .INT    -1
ZERO:   .INT    0
LTRCO:  .BYT    'O'        	
LTRCU:  .BYT    'U'
NL:     .BYT    '\n'
COMMA:  .BYT    ','
SP:     .BYT    32

        ;; return from function
	;; test for underflow
FFACT:  SUB     R1 R1
        ADI     R1 #10
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


;;; INSTRUCTION
        
        ;; RUN	REG, LABEL
        ;; Run signals to the VM to create a new thread.
        ;; REG will return a unique thread identifier (number) that will be associated with the thread.  The register is to be set by your VM, not by the programmer calling the RUN instruction.  You can determine what action to perform if all available identifiers are in use (throwing an exception is fine). Running out of identifiers means you have created two many threads and are out of Stack Space.
        ;; The LABEL will be jumped to by the newly created thread.  The current thread will continue execution at the statement following the RUN.

        ;; END
        ;; End will terminate the execution of a non-MAIN thread.  In functionality END is very similar to TRP 0, but only for a non-MAIN threads. END should only be used for non-MAIN threads.  END will have no effect if called in the MAIN Thread.

        ;; BLK
        ;; Block will cause the MAIN thread (the initial thread created when you start executing your program) to wait for all other threads to terminate (END) before continuing to the next instruction following the block.  Block is only to be used on the MAIN thread. BLK will have no effect if called in a Thread which is not the MAIN thread.

        ;; LCK LABEL
        ;; Lock will be used to implement a blocking mutex lock.  Calling lock will cause a Thread to try to place a lock on the mutex identified by Label. If the mutex is locked the Thread will block until the mutex is unlocked.  The data type for the Label is .INT

        ;; ULK LABEL
        ;; Unlock will remove the lock from a mutex.  Unlock should have no effect on a mutex if the Thread did not lock the mutex (a.k.a., only the Thread that locks a mutex should unlock the mutex).
