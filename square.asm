|; drawSquare(xTopLeft, yTopLeft, sideLength)
|; Draw a square on the canvas.
|; @param xTopLeft    the x-coordinate of the top-left corner of the square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the square.
|; @param sideLength  the length of the side of the square (in number of pixels).
drawSquare:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3)
    PUSH(R4) PUSH(R5) PUSH(R6)

    LD(BP, -12, R1)  |; xTopLeft
    LD(BP, -16, R2)  |; yTopLeft
    LD(BP, -20, R3)  |; sideLength

    |; Compute xBottomRight and yBottomRight
    ADDC(R3, -1, R3)            |; R3 = sideLength - 1
    ADD(R1, R3, R4)             |; R4 = xBottomRight
    ADD(R2, R3, R5)             |; R5 = yBottomRight

    MOVE(R2, R6)                |; R6 = yTopLeft (yCur)

    y_loop:
        CMPLE(R6, R5, R0)           |; Is yCur <= yBottomRight?
        BEQ(0, end_program, R31)    |; Exit if yCur > yBottomRight

        MOVE(R1, R7)                |; R7 = xTopLeft (xCur)

    x_loop:
        CMPLE(R7, R4, R0)           |; Is xCur <= xBottomRight?
        BEQ(R0, next_y, R31)        |; Exit if xCur > xBottomRight

        |; Check if the current pixel is on the edge of the square
        |; xCur == xTopLeft or xCur == xBottomRight
        SUB(R7, R1, R8)             |; R8 = xCur - xTopLeft
        CMOVE(0, R9)                |; R9 = 0
        BEQ(R8, is_on_edge, R9)     |; If xCur == xTopLeft, pixel is on the edge

        SUB(R7, R4, R8)             |; R8 = xCur - xBottomRight
        CMOVE(0, R9)
        BEQ(R8, is_on_edge, R9)     |; If xCur == xBottomRight, pixel is on the edge

        |; yCur == yTopLeft or yCur == yBottomRight
        SUB(R6, R2, R8)             |; R8 = yCur - yTopLeft
        CMOVE(0, R9)
        BEQ(R8, is_on_edge, R9)     |; If yCur == yTopLeft, pixel is on the edge

        SUB(R6, R5, R8)             |; R8 = yCur - yBottomRight
        CMOVE(0, R9)
        BEQ(R8, is_on_edge, R9)     |; If yCur == yBottomRight, pixel is on the edge

        BR(skip_pixel)             |; Skip the pixel if it is not on the edge

    is_on_edge:
        |; Draw pixel (xCur, yCur)
        PUSH(R6) PUSH(R7)           |; Push yCur, xCur
        CALL(canvas_set_to_1, 2)    |; Set the pixel to 1

    skip_pixel:
        ADDC(R7, 1, R7)             |; xCur++
        BR(x_loop)                  |; loop again for xCur

    next_y:
        ADDC(R6, 1, R6)             |; yCur++
        BR(y_loop)                  |; loop again for yCur

    end_program:
        POP(R6) POP(R5) POP(R4)
        POP(R3) POP(R2) POP(R1)
        POP(BP) POP(LP)
        RTN()


