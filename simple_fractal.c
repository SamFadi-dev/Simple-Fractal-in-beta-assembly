#include <stdio.h>
#include <stdlib.h>

// WIDTH is chosen to be 125 (instead of 256 like in beta-assembly) to make the
// fractal better fit in small console windows. But since the fractal is
// rotationally symmetric, this does not change the result (you simply have
// less blank space at the right of the fractal).
#define WIDTH 125    // Width of the console canvas
#define HEIGHT 125   // Height of the console canvas

// The canvas is defined as a global variable for consistency with the
// beta-assembly version.
char canvas[WIDTH * HEIGHT];  // The canvas to draw the fractal on



/* -------------------------- Function prototypes -------------------------- */

void drawFractal(int xTopLeft, int yTopLeft, int sideLength, int maxDepth);

void drawSquare(int xTopLeft, int yTopLeft, int sideLength);

int drawCircleBres(int xc, int yc, int radius);



/* ------------- Static functions (no need to implement these) ------------- */

/* Helper function to get the index of a pixel in the canvas.
 * You should not need to use this in beta-assembly as using canvas_set_to_1
 * from util.asm should be enough.
 * x, y:       The coordinates of the pixel.
 * return:     The index of the pixel in the canvas.
 */
static inline int canvasIndex(int x, int y) {
    return y * WIDTH + x;
}


/* Place the current pixels of the circle using symmetry.
 * This function has already been implemented for you in beta-assembly.
 * xc, yc:           The center of the circle.
 * circleX, circleY: The current pixel to place, using the center of the circle as origin.
 */
static void placeCirclePixels(int xc, int yc, int circleX, int circleY) {
    canvas[canvasIndex(xc + circleX, yc + circleY)] = '*';
    canvas[canvasIndex(xc - circleX, yc + circleY)] = '*';
    canvas[canvasIndex(xc + circleX, yc - circleY)] = '*';
    canvas[canvasIndex(xc - circleX, yc - circleY)] = '*';
    canvas[canvasIndex(xc + circleY, yc + circleX)] = '*';
    canvas[canvasIndex(xc - circleY, yc + circleX)] = '*';
    canvas[canvasIndex(xc + circleY, yc - circleX)] = '*';
    canvas[canvasIndex(xc - circleY, yc - circleX)] = '*';
}


/* Initialize the canvas with spaces.
 * You do not have to write this function in beta-assembly.
 */
static void initCanvas() {
    for (int i = 0; i < HEIGHT*WIDTH; i++) {
        canvas[i] = ' ';
    }
}


/* Print the canvas to the console.
 * You do not have to write this function in beta-assembly.
 */
static void printCanvas() {
    printf("\n"); // blank line for better visualization
    for (int yCur = 0; yCur < HEIGHT; yCur++) {
        for (int xCur = 0; xCur < WIDTH; xCur++) {
            printf("%c", canvas[canvasIndex(xCur, yCur)]);
        }
        printf("\n");
    }
}



/* --------- Function implementations (you need to implement these) -------- */

/* Draw a fractal using squares and circles.
 * xTopLeft, yTopLeft: The top left corner of the current square.
 * sideLength:         The side length of the current square.
 * maxDepth:           The maximum depth of the fractal.
 */
void drawFractal(int xTopLeft, int yTopLeft, int sideLength, int maxDepth) {
    if (maxDepth == 0) {
        return;
    }

    // This is to avoid having different side lengths for the square and the circle
    if ((sideLength & 1) == 0) {
        sideLength--;
    }

    // Draw the current square
    drawSquare(xTopLeft, yTopLeft, sideLength);

    // Calculate the parameters of the circle
    int xc = xTopLeft + sideLength / 2;
    int yc = yTopLeft + sideLength / 2;
    int radius = sideLength / 2;

    // Draw the current circle
    // The return value is useful to know where to draw the next square
    int lastPixelCircleX = drawCircleBres(xc, yc, radius);

    int shift = radius - lastPixelCircleX;
    if (shift < 1) {
        // Subsequent iterations will not improve the fractal
        return;
    }

    drawFractal(xTopLeft + shift,
                yTopLeft + shift,
                sideLength - (2 * shift),
                maxDepth - 1);
}


/* Draw a square on the canvas.
 * xTopLeft, yTopLeft: The top left corner of the square.
 * sideLength:         The side length of the square (in number of pixels).
 */
void drawSquare(int xTopLeft, int yTopLeft, int sideLength) {
    int xBottomRight = xTopLeft + sideLength - 1;
    int yBottomRight = yTopLeft + sideLength - 1;
    for (int yCur = yTopLeft; yCur <= yBottomRight; yCur++) {
        for (int xCur = xTopLeft; xCur <= xBottomRight; xCur++) {
            if (xCur == xTopLeft || xCur == xBottomRight
                                 || yCur == yTopLeft
                                 || yCur == yBottomRight) {
                canvas[canvasIndex(xCur, yCur)] = '*';
            }
        }
    }
}


/* Draw a circle using Bresenham's algorithm.
 * xc, yc:           The center of the circle (using the canvas axes).
 * radius:           The radius of the circle.
 * return:           The x coordinate, using the center of the circle as
 *                   origin, of the last pixel placed (on one of the top
 *                   right "octant"), i.e. the top right pixel of the
 *                   circle.
 */
int drawCircleBres(int xc, int yc, int radius) {
    int decisionVar = 3 - (2 * radius);

    // !! circleX and circleY use the circle center as origin !!
    int circleX = 0;
    int circleY = radius;

    while (circleX <= circleY) {
        placeCirclePixels(xc, yc, circleX, circleY);

        // Mathematics magic :)
        if (decisionVar > 0) {
            decisionVar += 4 * (circleX - circleY) + 10;
            circleY--;
        } else {
            decisionVar += 4 * circleX + 6;
        }
        circleX++;
    }

    return circleX - 1;
}



/* ------------------ Main function (no need to implement) ----------------- */

int main(int argc, const char *argv[]) {
    int maxDepth = 3;

    if (argc > 2) {
        fprintf(stderr, "Usage: %s [maxDepth]\n", argv[0]);
        return EXIT_FAILURE;
    }
    else if (argc == 2) {
        // Ideally, we should print an error if the input is not a positive
        // integer but we don't want to complicate the code.
        maxDepth = atoi(argv[1]) > 0 ? atoi(argv[1]) : 3;
    }

    initCanvas();

    int sideLength = WIDTH < HEIGHT ? WIDTH : HEIGHT;
    drawFractal(0, 0, sideLength, maxDepth);

    printCanvas();

    return EXIT_SUCCESS;
}
