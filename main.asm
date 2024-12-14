.include beta.uasm


|; Constants (/ Identifiers). DO NOT DEFINE NEW CONSTANTS IN YOUR CODE, THESE ARE JUST FOR THE CANVAS
|; You do not have to use them in your code.
bit_per_word = 32 |; Note that in beta.uasm, a WORD is 16 bits (and a LONG is 32 bits). But in the theoretical course, a word is 32 bits. This is why we use 32 bits here.
words_per_line = 8
bit_per_line = bit_per_word * words_per_line
lines = 125 |; not 128 because the first line is lost by the bootstrap code and 2 lines are left blank for better visualization
canvas_size = words_per_line * lines


|; bootstrap
CMOVE(stack__, SP)
MOVE(SP, BP)
BR(main)
STORAGE(5) |; 5 words to pad the bootstrap code to the end of the first line


STORAGE(words_per_line)      |; blank line for better visualization

canvas:
    STORAGE(canvas_size)     |; canvas

STORAGE(words_per_line)      |; blank line for better visualization


.include util.asm
.include square.asm
.include circle_bresenham.asm
.include fractal.asm


|; You can modify this value to test your drawFractal function. You can assume
|; that maxDepth is always greater than 0.
maxDepth:
    LONG(3)


main:

    |; *---------------------------------------------------------------------*
    |; |                                                                     |
    |; |     You can uncomment the code here to test your drawSquare and     |
    |; |                      drawCircleBres functions.                      |
    |; |                                                                     |
    |; *---------------------------------------------------------------------*

    |; Draw square (debug code; You can uncomment it to see a square)
|;     CMOVE(130, R1)             |; Reg[R1] <- xTopLeft
|;     CMOVE(30, R2)              |; Reg[R2] <- yTopLeft
|;     CMOVE(30, R3)              |; Reg[R3] <- sideLength
|;     .breakpoint
|;     PUSH(R3) PUSH(R2) PUSH(R1) |; Last-argument-pushed-first (LAPF) convention
|;     CALL(drawSquare, 3)        |; Draw the square

    |; Draw circle (debug code; You can uncomment it to see a circle)
     CMOVE(192, R1)             |; Reg[R1] <- xc
     CMOVE(63, R2)              |; Reg[R2] <- yc
     CMOVE(50, R3)              |; Reg[R3] <- radius
     PUSH(R3) PUSH(R2) PUSH(R1) |; Last-argument-pushed-first (LAPF) convention
    .breakpoint
     CALL(drawCircleBres, 3)    |; Draw the circle

    |; *---------------------------------------------------------------------*
    |; |                                                                     |
    |; |                       End of the debug code.                        |
    |; |                                                                     |
    |; *---------------------------------------------------------------------*


    |; Draw fractal

    |; Last-argument-pushed-first (LAPF) convention
    LD(maxDepth, R1) |; Reg[R1] <- maxDepth
    PUSH(R1)

    CMOVE(lines, R2) |; Reg[R2] <- sideLength (number of lines)
    PUSH(R2)

    |; Reg[R31] = yTopLeft = 0
    PUSH(R31)

    |; computation to make the fractal centered
    CMOVE(bit_per_line, R3)
    DIVC(R3, 2, R3)  |; bit_per_line / 2
    SUBC(R2, 1, R2)  |; lines - 1
    DIVC(R2, 2, R2)  |; (lines - 1) / 2
    SUB(R3, R2, R3)  |; Reg[R3] <- xTopLeft = bit_per_line / 2 - (lines - 1) / 2
    PUSH(R3)

    CALL(drawFractal, 4)  |; Draw the fractal

    HALT()


    |; check for 0xDEADCAFE in the memory explorer
    |; to find the base of the stack
    LONG(0xDEADCAFE)
stack__:
    STORAGE(1024)
