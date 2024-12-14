|; drawCircleBres(xc, yc, radius)
|; Draw a circle using Bresenham's algorithm.
|;  @param xc      the x-coordinate of the center of the circle.
|;  @param yc      the y-coordinate of the center of the circle.
|;  @param radius  the radius of the circle.
|;  @return        the x coordinate, using the center of the circle as origin,
|;                 of the last pixel placed (on one of the top right "octant"),
|;                 i.e. the top right pixel of the circle.
drawCircleBres:
    |; Save the return address
    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    |; Save the registers
    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4)
    PUSH(R5) PUSH(R6) PUSH(R7)

    LD(BP, -12, R1) |; xc
    LD(BP, -16, R2) |; yc
    LD(BP, -20, R3) |; radius

    |; decisionVar
    CMOVE(2, R4)      |; R4 = 2
    MUL(R3, R4, R4)   |; R4 = 2 * radius
    CMOVE(3, R0)      |; R0 = 3
    SUB(R0, R4, R4)   |; R4 = 3 - (2 * radius)

    
    CMOVE(0, R5)      |; circleX = 0
    MOVE(R3, R6)     |; circleY = radius

    loop:
        CMPLE(R5, R6, R0)  |; circleX <= circleY
        BEQ(R0, end_circle, R31) |; if circleX > circleY, end

        |; Place the pixels of the circle
        PUSH(R6) PUSH(R5) PUSH(R2) PUSH(R1)           
        CALL(placeCirclePixels, 4)

        CMPLT(R31, R4, R0)   |; R0 = 1 if 0 < decisionVar
        BEQ(R0, else_branch, R31) |; if decisionVar <= 0, go to else_branch

        |; if branch: decisionVar += 4 * (circleX - circleY) + 10
        SUB(R5, R6, R7)    |; R7 = circleX - circleY
        MULC(R7, 4, R7)    |; R7 = 4 * (circleX - circleY)
        ADDC(R7, 10, R7)   |; R7 += 10
        ADD(R4, R7, R4)    |; decisionVar = decisionVar + R7
        SUBC(R6, 1, R6)    |; circleY--

        BR(update_circleX) |; go to update_circleX and loop again

        else_branch:
            |; decisionVar += 4 * circleX + 6
            MULC(R5, 4, R7)    |; R7 = 4 * circleX
            ADDC(R7, 6, R7)    |; R7 += 6
            ADD(R4, R7, R4)    |; decisionVar = decisionVar + R7

        update_circleX:
            ADDC(R5, 1, R5)    |; circleX++
            BR(loop)           |; loop again

    end_circle:
    SUBC(R5, 1, R0)    |; circleX - 1

    POP(R7) POP(R6) POP(R5) POP(R4) 
    POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)

    RTN()


|; placeCirclePixels(xc, yc, circleX, circleY)
|; Place the current pixels of the circle using symmetry.
|; @param xc       the x-coordinate of the center of the circle.
|; @param yc       the y-coordinate of the center of the circle.
|; @param circleX  the x-coordinate of the current pixel to place, using the center of the circle as origin.
|; @param circleY  the y-coordinate of the current pixel to place, using the center of the circle as origin.
placeCirclePixels:

    PUSH(LP) PUSH(BP)
    MOVE(SP, BP)

    PUSH(R1) PUSH(R2) PUSH(R3) PUSH(R4) PUSH(R5)

    LD(BP, -12, R1) |; xc
    LD(BP, -16, R2) |; yc
    LD(BP, -20, R3) |; circleX
    LD(BP, -24, R4) |; circleY

    ADD(R1, R3, R5) |; xc + circleX
    ADD(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R3, R5) |; xc - circleX
    ADD(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R3, R5) |; xc + circleX
    SUB(R2, R4, R0) |; yc - circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R3, R5) |; xc - circleX
    SUB(R2, R4, R0) |; yc + circleY
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R4, R5) |; xc + circleY
    ADD(R2, R3, R0) |; yc + circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R4, R5) |; xc - circleY
    ADD(R2, R3, R0) |; yc + circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    ADD(R1, R4, R5) |; xc + circleY
    SUB(R2, R3, R0) |; yc - circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    SUB(R1, R4, R5) |; xc - circleY
    SUB(R2, R3, R0) |; yc - circleX
    PUSH(R0) PUSH(R5)
    CALL(canvas_set_to_1, 2)

    POP(R5) POP(R4) POP(R3) POP(R2) POP(R1)

    POP(BP) POP(LP)

    RTN()
