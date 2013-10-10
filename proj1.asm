        ;; CASEY ALLRED PROJECT 1
        ;; Print your name on the screen.
        ;; Print a blank line.
        ;; Add all the elements of list B together print each result (intermediate and final) on screen.  Put 2 spaces between each result. (e.g., 450)
        ;; Print a blank line.
        ;; Multiply all the elements of list A together print each result (intermediate and final) on screen. Put 2 spaces between each result. (e.g., 2)
        ;; Print a blank line
        ;; Divide the final result from part 3, by each element in list B (the results are not cumulative). Put 2 spaces between each result. (e.g., 1)
        ;; Print a blank line.
        ;; Subtract from the final result of part 5 each element of list C (the results are not cumulative). Put 2 spaces between each result. (e.g., 220)
        ;; A = (1, 2, 3, 4, 5, 6)
        ;; B = (300, 150, 50, 20, 10, 5)
        ;; C = (500, 2, 5, 10)

        ;; CASEY
        LDB     R0 LTRC:
        TRP     #3
	LDB     R0 LTRA:
        TRP     #3
        LDB     R0 LTRS:
	TRP     #3
	LDB     R0 LTRE:
	TRP     #3
	LDB     R0 LTRY:
	TRP     #3

        ;; SPACE
	LDB     R0 LTRSP:
	TRP     #3

        ;; ALLRED
	LDB     R0 LTRA:
	TRP     #3
	LDB     R0 LTRL:
	TRP     #3
	LDB     R0 LTRL:
	TRP     #3
	LDB     R0 LTRR:
	TRP     #3
	LDB     R0 LTRE:
	TRP     #3
	LDB     R0 LTRD:
	TRP     #3

        ;; (blank line)
	LDB     R0 LTRNL:
	TRP     #3
	TRP     #3

	;; Add all the elements of list B together print each result (intermediate and final) on screen.  Put 2 spaces between each result. (e.g., 450)
        ;; B = (300, 150, 50, 20, 10, 5)
        LDR     R2 ZERO:
        AND     R1 R2
        ADI     R1 #300
        ADI     R1 #150
        AND     R0 R2
	ADD     R0 R1
        TRP     #1

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

        ADI     R1 #50
        AND     R0 R2
        ADD     R0 R1
        TRP     #1

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	ADI     R1 #20
	AND     R0 R2
	ADD     R0 R1
	TRP     #1

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	ADI     R1 #10
	AND     R0 R2
	ADD     R0 R1
	TRP     #1

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	ADI     R1 #5
	AND     R0 R2
	ADD     R0 R1
	TRP     #1

        ;; Store result of part 3 in R5 for later use
        AND     R5 R2
        ADD     R5 R1

	;; (blank line)
	LDB     R0 LTRNL:
	TRP     #3
	TRP     #3

        ;;Multiply all the elements of list A together print each result (intermediate and final) on screen. Put 2 spaces between each result. (e.g., 2)
        LDR     R3 ZERO:
        LDR     R1 A1:
        LDR     R2 A2:
        MUL     R1 R2
        AND     R0 R3
        ADD     R0 R1
        TRP     #1               ;Print the 1st operation (A1: * A2:)

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

        LDR     R2 A3:
        MUL     R1 R2
	AND     R0 R3
	ADD     R0 R1
	TRP     #1               ;Print the 2nd operation (A1: * A2: * A3:)

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	LDR     R2 A4:
	MUL     R1 R2
	AND     R0 R3
	ADD     R0 R1
	TRP     #1               ;Print the 3rd operation (A1: * A2: * A3: * A4:)

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	LDR     R2 A5:
	MUL     R1 R2
	AND     R0 R3
	ADD     R0 R1
	TRP     #1               ;Print the 4th operation (A1: * A2: * A3: * A4: * A5:)

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	LDR     R2 A6:
	MUL     R1 R2
	AND     R0 R3
	ADD     R0 R1
	TRP     #1               ;Print the 2nd operation (A1: * A2: * A3: * A4: * A5: * A6:)

        ;; STORE result of part 5 in reg 6 for later use
        AND     R6 R0
        ADD     R6 R1
	;; (blank line)
	LDB     R0 LTRNL:
	TRP     #3
	TRP     #3

	;; Divide the final result from part 3, by each element in list B (the results are not cumulative). Put 2 spaces between each result. (e.g., 1)
        ;; ASSUME R5 has the total to be the numerator
        LDR     R3 ZERO:
        AND     R1 R3
        ADD     R1 R5

        AND     R0 R3
        ADD     R0 R1
        LDR     R2 B1:
        DIV     R0 R2
        TRP     #1               ;Print result/B1:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 B2:
	DIV     R0 R2
	TRP     #1               ;Print result/B2:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 B3:
	DIV     R0 R2
	TRP     #1               ;Print result/B3:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 B4:
	DIV     R0 R2
	TRP     #1               ;Print result/B4:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 B5:
	DIV     R0 R2
	TRP     #1               ;Print result/B5:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 B6:
	DIV     R0 R2
	TRP     #1               ;Print result/B6:

	;; (blank line)
	LDB     R0 LTRNL:
	TRP     #3
	TRP     #3

	;; Subtract from the final result of part 5 each element of list C (the results are not cumulative). Put 2 spaces between each result. (e.g., 220)
        ;; ASSUME PART 5 RESULT IN R6
        LDR     R3 ZERO:
        AND     R1 R3
        ADD     R1 R6

        AND     R0 R3
        ADD     R0 R1
        LDR     R2 C1:
        SUB     R0 R2
        TRP     #1               ;Print result - C1:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 C2:
	SUB     R0 R2
	TRP     #1               ;Print result - C2:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

        AND     R0 R3
	ADD     R0 R1
	LDR     R2 C3:
	SUB     R0 R2
	TRP     #1               ;Print result - C3:

	;; SPACE
	LDB     R0 LTRSP:
	TRP     #3
	;; SPACE
	TRP     #3

	AND     R0 R3
	ADD     R0 R1
	LDR     R2 C4:
	SUB     R0 R2
	TRP     #1               ;Print result - C4:

	;; (blank line)
	LDB     R0 LTRNL:
	TRP     #3

        TRP     #0
        ;; FINISHED

ZERO:   .INT    0
LTRC:   .BYT    'C'
LTRA:   .BYT    'A'
LTRS:   .BYT    'S'
LTRE:   .BYT    'E'
LTRY:   .BYT    'Y'
LTRSP:  .BYT    32
LTRL:   .BYT    'L'
LTRR:   .BYT    'R'
LTRD:   .BYT    'D'
LTRNL:  .BYT    '\n'

A1:     .INT    1
A2:     .INT    2
A3:     .INT    3
A4:     .INT    4
A5:     .INT    5
A6:     .INT    6

B1:     .INT    300
B2:     .INT    150
B3:     .INT    50
B4:     .INT    20
B5:     .INT    10
B6:     .INT    5

C1:     .INT    500
C2:     .INT    2
C3:     .INT    5
C4:     .INT    10
