;;; Project 2
;;; Casey Allred
        ;; #Part 1
        ;; int SIZE = 10
        ;; int arr[] = { 10, 2, 3, 4, 15, -6, 7, 8, 9, 10 }
        ;; int i = 0
	LDR     R3 ZERO:
        ;; int sum = 0
        LDR     R5 ZERO:
        ;; int temp
        LDR     R6 ZERO:
        ;; int result
        LDR     R7 ZERO:

        LDR     R9 ISIZE:       ;size of elements in array (doesn't change)
        LDA     R10 ARR:        ;store array address in register for easy access
        LDR     R11 TWO:        ;for use in determining if its even

        ;; while (i < SIZE) {
WHILE:  LDR     R4 SIZE:
        CMP     R4 R3
        BRZ     R4 EWHILE:
        ;; 	​sum += arr[i]
        LDR     R8 ZERO:        ;offset holder
        ADD     R8 R3
        MUL     R8 R9           ;calculate offset
        MOV     R2 R10          ;load array address
        ADD     R2 R8           ;calculate address of element
        LDR     R1 (R2)         ;load indirect of address in R2
        ADD     R5 R1           ;the acutaly adding to sum

        ;; 	​result = arr[i] % 2
;;; int div by 2
        MOV     R0 R1           ;tmp location
        DIV     R0 R11          ;div by 2
;;; mul that by 2
        MUL     R0 R11
;;; sub original by result
        MOV     R7 R1          ;keep R1 for the print
        SUB     R7 R0          ;sub by mult to get 1 or 0
;;; 0 even 1 odd
	;;      	​printf("%d is even\n", arr[i])
        MOV     R0 R1           ;print %d
        TRP     #1

        ;; print space
        LDB     R0 LTRSP:
        TRP     #3
        ;; print "is"
        LDB     R0 LTRI:
        TRP     #3
        LDB     R0 LTRS:
        TRP     #3
        ;; print space
	LDB     R0 LTRSP:
	TRP     #3
        ;;     	​if (result == 0)
	BNZ     R7 ELSE:
	;; print "even"
        LDB     R0 LTRE:
        TRP     #3
        LDB     R0 LTRV:
        TRP     #3
        LDB     R0 LTRE:
        TRP     #3
        LDB     R0 LTRN:
        TRP     #3

        JMP     ENDIF:
        ;; 	​else
        ;;      	​printf("%d is odd\n", arr[i])
	;; print "odd"
ELSE:   LDB     R0 LTRO:
	TRP     #3
	LDB     R0 LTRD:
	TRP     #3
	TRP     #3
	;; print new line
ENDIF:  LDB     R0 NL:
	TRP     #3

        ;; 	i++
	ADI     R3 #1
        ;; }
        JMP WHILE:

        ;; printf("Sum is %d\n", sum);
        ;; print Sum
EWHILE: LDB     R0 LTRCS:
        TRP     #3
        LDB     R0 LTRU:
        TRP     #3
        LDB     R0 LTRM:
        TRP     #3
	;; print space
	LDB     R0 LTRSP:
	TRP     #3
        ;; print "is"
	LDB     R0 LTRI:
	TRP     #3
	LDB     R0 LTRS:
	TRP     #3
	;; print space
	LDB     R0 LTRSP:
	TRP     #3
        ;; print sum
        MOV     R0 R5           ;ready sum for printing
        TRP     #1
        ;; print new line
	LDB     R0 NL:
	TRP     #3

;;; START PART 2
        ;; print DAGS
        LDB     R0 DAGSD:
        TRP     #3
        LDB     R0 DAGSA:
        TRP     #3
	LDB     R0 DAGSG:
	TRP     #3
	LDB     R0 DAGSS:
	TRP     #3

	;; print new line
	LDB     R0 NL:
	TRP     #3

        ;; print int value for DAGS
        LDR     R0 DAGSD:
        MOV     R1 R0           ;save for sub at end
        TRP     #1

	;; print new line
	LDB     R0 NL:
	TRP     #3

        ;; swap
        LDB     R3 DAGSD:
        LDB     R4 DAGSG:
        STB     R3 DAGSG:
        STB     R4 DAGSD:

        ;; print GADS (D and G swapped but label is same)
	LDB     R0 DAGSD:
	TRP     #3
	LDB     R0 DAGSA:
	TRP     #3
	LDB     R0 DAGSG:
	TRP     #3
	LDB     R0 DAGSS:
	TRP     #3

	;; print new line
	LDB     R0 NL:
	TRP     #3

	;; print int value for GADS
	LDR     R0 DAGSD:
        MOV     R2 R0           ;save for subtraction
	TRP     #1

	;; print new line
	LDB     R0 NL:
	TRP     #3

        ;; subtract the 2 values
        SUB     R2 R1
        ;; print the value
        MOV     R0 R2
        TRP     #1

	;; print new line
	LDB     R0 NL:
	TRP     #3

QUIT:   TRP     #0              ;End the program (protect the data from being executed)

TWO:    .INT    2               ;for use in determining if even
ZERO:   .INT    0
ISIZE:  .INT    4               ;size of elements in array
SIZE:   .INT    10              ;Size of the Array
ARR:    .INT    10              ;Start of the Array
        .INT    2
        .INT    3
        .INT    4
        .INT    15
        .INT    -6
        .INT    7
        .INT    8
        .INT    9
        .INT    10

NL:     .BYT    '\n'
LTRSP:  .BYT    32
LTRI:   .BYT    'i'
LTRS:   .BYT    's'
LTRE:   .BYT    'e'
LTRV:   .BYT    'v'
LTRN:   .BYT    'n'
LTRO:   .BYT    'o'
LTRD:   .BYT    'd'
LTRCS:  .BYT    'S'
LTRU:   .BYT    'u'
LTRM:   .BYT    'm'

;;; PART 2 DATA
DAGSD:  .BYT    'D'
DAGSA:  .BYT    'A'
DAGSG:  .BYT    'G'
DAGSS:  .BYT    'S'

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
