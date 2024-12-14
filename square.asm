|; drawSquare(xTopLeft, yTopLeft, sideLength)
|; Draw a square on the canvas.
|; @param xTopLeft    the x-coordinate of the top-left corner of the square.
|; @param yTopLeft    the y-coordinate of the top-left corner of the square.
|; @param sideLength  the length of the side of the square (in number of pixels).
drawSquare:
    PUSH(LP) PUSH(BP)           |; Sauvegarder le pointeur de lien et le pointeur de base
    MOVE(SP, BP)                |; Configurer le nouveau cadre de pile

    PUSH(R1) PUSH(R2) PUSH(R3)  |; Sauvegarder les registres nécessaires
    PUSH(R4) PUSH(R5) PUSH(R6)

    |; Charger les paramètres
    LD(BP, -12, R1)  |; xTopLeft
    LD(BP, -16, R2)  |; yTopLeft
    LD(BP, -20, R3)  |; sideLength

    |; Calcul des coordonnées xBottomRight et yBottomRight
    ADDC(R3, -1, R0)            |; R3 = sideLength - 1
    ADD(R1, R3, R4)             |; R4 = xBottomRight
    ADD(R2, R3, R5)             |; R5 = yBottomRight
    |; Boucle pour yCur (R6)
    MOVE(R2, R6)                |; R6 = yTopLeft (yCur)
y_loop:
    CMPLE(R6, R5, R0)           |; Comparer yCur <= yBottomRight
    BEQ(0, end_program, R31)   |; Sortir si yCur > yBottomRight
    |; Boucle pour xCur (R7)
    MOVE(R1, R7)                |; R7 = xTopLeft (xCur)
x_loop:
    CMPLE(R7, R4, R0)           |; Comparer xCur <= xBottomRight
    BEQ(R0, next_y, R31)        |; Sortir si xCur > xBottomRight

    |; Vérifier si le pixel est sur le bord
    |; xCur == xTopLeft ou xCur == xBottomRight
    SUB(R7, R1, R8)             |; R8 = xCur - xTopLeft
    CMOVE(0, R9)                |; R9 = 0
    BEQ(R8, is_on_edge, R9)     |; Si xCur == xTopLeft, pixel sur le bord

    SUB(R7, R4, R8)             |; R8 = xCur - xBottomRight
    CMOVE(0, R9)
    BEQ(R8, is_on_edge, R9)     |; Si xCur == xBottomRight, pixel sur le bord

    |; yCur == yTopLeft ou yCur == yBottomRight
    SUB(R6, R2, R8)             |; R8 = yCur - yTopLeft
    CMOVE(0, R9)
    BEQ(R8, is_on_edge, R9)     |; Si yCur == yTopLeft, pixel sur le bord

    SUB(R6, R5, R8)             |; R8 = yCur - yBottomRight
    CMOVE(0, R9)
    BEQ(R8, is_on_edge, R9)     |; Si yCur == yBottomRight, pixel sur le bord

    BR(skip_pixel)             |; Si aucune condition n'est remplie, ignorer le pixel

is_on_edge:
    |; Dessiner le pixel (xCur, yCur)
    PUSH(R6) PUSH(R7)           |; Empiler yCur et xCur
    CALL(canvas_set_to_1, 2)    |; Appeler canvas_set_to_1

skip_pixel:
    ADDC(R7, 1, R7)             |; xCur++
    BR(x_loop)                 |; Recommencer pour xCur

next_y:
    ADDC(R6, 1, R6)             |; yCur++
    BR(y_loop)                 |; Recommencer pour yCur

end_program:
    POP(R6) POP(R5) POP(R4)     |; Restaurer les registres
    POP(R3) POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()                       |; Retour


