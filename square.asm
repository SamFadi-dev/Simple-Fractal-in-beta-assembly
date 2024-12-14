|; drawSquare(xTopLeft, yTopLeft, sideLength)
|; Draw a square on the canvas.
|; @param xTopLeft    the x-coordinate of the top-left corner of the square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the square.
|; @param sideLength  the length of the side of the square (in number of pixels).
drawSquare:
    PUSH(LP) PUSH(BP)           |; Save the link and base pointer
    MOVE(SP, BP)                |; Set up the new stack frame

    PUSH(R1) PUSH(R2) PUSH(R3)  |; Save necessary registers

    |; Load parameters
    LD(BP, -12, R1)             |; R1 = xTopLeft
    LD(BP, -16, R2)             |; R2 = yTopLeft
    LD(BP, -20, R3)             |; R3 = sideLength

    |; Compute xBottomRight and yBottomRight
    ADDC(R3, -1, R3)            |; R3 = sideLength - 1
    ADD(R1, R3, R4)             |; R4 = xBottomRight
    ADD(R2, R3, R5)             |; R5 = yBottomRight

    |; Loop for yCur (R2 is reused directly)
    MOVE(R2, R6)                |; R6 = yCur (start at yTopLeft)
y_loop:
    CMPLE(R6, R5, R0)           |; Compare yCur <= yBottomRight
    BEQ(R0, end_square, R31)    |; Exit if yCur > yBottomRight

    |; Loop for xCur (reuse R7 for xCur)
    MOVE(R1, R7)                |; R7 = xCur (start at xTopLeft)
x_loop:
    CMPLE(R7, R4, R0)           |; Compare xCur <= xBottomRight
    BEQ(R0, next_y, R31)        |; Exit if xCur > xBottomRight

    |; Check if the pixel is on the edge
    SUB(R7, R1, R8)             |; R8 = xCur - xTopLeft
    BEQ(R8, on_edge, R31)       |; If xCur == xTopLeft, it's an edge

    SUB(R7, R4, R8)             |; R8 = xCur - xBottomRight
    BEQ(R8, on_edge, R31)       |; If xCur == xBottomRight, it's an edge

    SUB(R6, R2, R8)             |; R8 = yCur - yTopLeft
    BEQ(R8, on_edge, R31)       |; If yCur == yTopLeft, it's an edge

    SUB(R6, R5, R8)             |; R8 = yCur - yBottomRight
    BEQ(R8, on_edge, R31)       |; If yCur == yBottomRight, it's an edge

    BR(skip_pixel)              |; Skip the pixel if not on edge

on_edge:
    PUSH(R6) PUSH(R7)           |; Push yCur and xCur
    CALL(canvas_set_to_1, 2)    |; Set the pixel

skip_pixel:
    ADDC(R7, 1, R7)             |; xCur++
    BR(x_loop)                  |; Continue x loop

next_y:
    ADDC(R6, 1, R6)             |; yCur++
    BR(y_loop)                  |; Continue y loop

end_square:
    POP(R3) POP(R2) POP(R1)     |; Restore registers
    POP(BP) POP(LP)
    RTN()                       |; Return


