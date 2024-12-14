|; drawFractal(xTopLeft, yTopLeft, sideLength, maxDepth)
|; Draw a fractal using squares and circles.
|; @param xTopLeft    the x-coordinate of the top-left corner of the current square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the current square.
|; @param sideLength  the length of the side of the current square.
|; @param maxDepth    the maximum depth of the fractal.
drawFractal:
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3)
    PUSH(R4) PUSH(R5) PUSH(R6) PUSH(R7) PUSH(R8)

    LD(BP, -12, R1)             |; xTopLeft
    LD(BP, -16, R2)             |; yTopLeft
    LD(BP, -20, R3)             |; sideLength
    LD(BP, -24, R4)             |; maxDepth

    |; Check if maxDepth == 0
    CMOVE(0, R0)                |; R0 = 0
    BEQ(R4, end_fractal, R0)    |; if maxDepth == 0, end the fractal

    |; Check if sideLength == 0
    ANDC(R3, 1, R0)             |; R0 = sideLength & 1
    BEQ(R0, skip_adjust, R31)   |; if sideLength is even, skip the adjustment
    SUBC(R3, 1, R3)             |; otherwise, sideLength--

skip_adjust:

    PUSH(R4)                    |; Push maxDepth
    PUSH(R3) PUSH(R2) PUSH(R1)  |; Push sideLength, yTopLeft, xTopLeft
    CALL(drawSquare, 3)         |; Draw the square
    POP(R4) |; Restore maxDepth

    |; Compute the center of the circle
    DIVC(R3, 2, R5)             |; R5 = radius = sideLength / 2
    ADD(R1, R5, R6)             |; R6 = xc = xTopLeft + radius
    ADD(R2, R5, R7)             |; R7 = yc = yTopLeft + radius

    PUSH(R5) PUSH(R7) PUSH(R6)  |; Push radius, yc, xc
    CALL(drawCircleBres, 3)     |; Draw the circle
    MOVE(R0, R8)                |; R8 = lastPixelCircleX (return the last pixel x-coordinate)

    |; Compute the shift of the next square
    SUB(R5, R8, R9)             |; R9 = shift = radius - lastPixelCircleX
    CMOVE(1, R0)                |; R0 = 1
    CMPLT(R0, R9, R0)           |; R0 = 1 si shift < 1
    BEQ(R0, end_fractal, R31)   |; if shift < 1, end the fractal

    |; Compute the new parameters for the next fractal
    SUB(R3, R9, R3)             |; sideLength = sideLength - 2 * shift
    SUB(R3, R9, R3)
    ADD(R1, R9, R1)             |; xTopLeft = xTopLeft + shift
    ADD(R2, R9, R2)             |; yTopLeft = yTopLeft + shift
    SUBC(R4, 1, R4)             |; maxDepth--

    PUSH(R4) PUSH(R3) PUSH(R2) PUSH(R1) |; Push maxDepth, sideLength, yTopLeft, xTopLeft
    CALL(drawFractal, 4)        |; Draw the next fractal (recursive call)

end_fractal:
    POP(R8) POP(R7) POP(R6)
    POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()

