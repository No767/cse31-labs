#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int bSize;

// ### Utilities

// Bools are represented through 0 and 1
// 0 - False
// 1 - True

// bypasses casting to lower/uppercase
int isSame(char c1, char c2) {
    // exact check on address
    if (c1 == c2) {
        return 1;
    }

    // Ascii-encoding dedicates:
    // See: https://www.ascii-code.com/characters/ascii-alphabet-characters
    // Uppercase A-Z: 64-90
    // Lowercase a-z: 97-122
    // lowercase (97) - uppercase (64) = 32

    // Case 1: a vs A
    // check bounds first
    if (c1 >= 'A' && c1 <= 'Z') {
        char diff = c1 + 32;
        if (diff == c2) {
            return 1;
        }
    }

    // Case 2: A vs a
    // check bounds first
    if (c1 >= 'a' && c1 <= 'z') {
        char diff = c1 - 32;
        if (diff == c2) {
            return 1;
        }
    }

    // We've exhausted all options, so in fact, they are NOT the same
    return 0;
}

// ### Search Logic

// Actual recursive backtracking DFS search logic
int findPath(char **arr, int **path, char *word, int row, int col, int index) {
    if (row < 0 || row >= bSize || col < 0 || col >= bSize) {
        return 0;
    }

    if (!isSame(*(*(arr + row) + col), *(word + index))) {
        return 0;
    }

    // replace the value with our "new" one
    // multiplying by 10 appends our value
    // i + 1 shifts from 0-based to 1-based indexing; human-readable format
    int temp = *(*(path + row) + col);
    *(*(path + row) + col) = (temp * 10) + (index + 1);

    // If we reach a null-terminating character, we are done with the word
    if (*(word + index + 1) == '\0') {
        return 1;
    }

    // Search the 8 neighbors
    // We do this by searching the three rows of the neighbors while skipping the current middle cell
    // row == 0 and col == 0 is the middle cell
    int r, c;
    for (r = row - 1; r <= row + 1; r++) {
        for (c = col - 1; c <= col + 1; c++) {
            if (r != row || c != col) {
                if (findPath(arr, path, word, r, c, index + 1) == 1) {
                    return 1;
                }
            }
        }
    }

    // Backtrack if nothing found
    *(*(path + row) + col) = temp;

    return 0;
}

void printPuzzle(char **arr) {
    // This function will print out the complete puzzle grid (arr).
    // It must produce the output in the SAME format as the samples
    // in the instructions.
    // Your implementation here...
    int i, j;

    for (i = 0; i < bSize; i++) {
        for (j = 0; j < bSize; j++) {
            char *rowChar = *(arr + i);
            char c = *(rowChar + j);

            printf("%c ", c);
        }
        printf("\n");
    }
}

void searchPuzzle(char **arr, char *word) {
    // This function checks if arr contains the search word. If the
    // word appears in arr, it will print out a message and the path
    // as shown in the sample runs. If not found, it will print a
    // different message as shown in the sample runs.
    // Your implementation here...

    int i, j;
    int words_found = 0;

    // Has to be done separately, or else it would result in a seg fault
    int **path = (int **)malloc(bSize * sizeof(int *));
    for (i = 0; i < bSize; i++) {
        *(path + i) = (int *)malloc(bSize * sizeof(int));
        for (j = 0; j < bSize; j++) {
            *(*(path + i) + j) = 0;
        }
    }

    for (i = 0; i < bSize; i++) {
        for (j = 0; j < bSize; j++) {
            if (findPath(arr, path, word, i, j, 0) == 1) {
                words_found++;
            }
        }
    }

    if (words_found > 0) {
        printf("\nWord found!\n");
        printf("Printing the search path:\n");
        for (i = 0; i < bSize; i++) {
            for (j = 0; j < bSize; j++) {
                // Just a fancier way of putting 5 spaces in between
                printf("%-5d", *(*(path + i) + j));
            }
            printf("\n");
        }
    } else {
        printf("\nWord not found!\n");
    }

    for (i = 0; i < bSize; i++) {
        free(*(path + i));
    }
    free(path);
}

// Main function, DO NOT MODIFY
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <puzzle file name>\n", argv[0]);
        return 2;
    }
    int i, j;
    FILE *fptr;

    // Open file for reading puzzle
    fptr = fopen(argv[1], "r");
    if (fptr == NULL) {
        printf("Cannot Open Puzzle File!\n");
        return 0;
    }

    // Read the size of the puzzle block
    fscanf(fptr, "%d\n", &bSize);

    // Allocate space for the puzzle block and the word to be searched
    char **block = (char **)malloc(bSize * sizeof(char *));
    char *word = (char *)malloc(20 * sizeof(char));

    // Read puzzle block into 2D arrays
    for (i = 0; i < bSize; i++) {
        *(block + i) = (char *)malloc(bSize * sizeof(char));
        for (j = 0; j < bSize - 1; ++j) {
            fscanf(fptr, "%c ", *(block + i) + j);
        }
        fscanf(fptr, "%c \n", *(block + i) + j);
    }
    fclose(fptr);

    printf("Enter the word to search: ");
    scanf("%19s", word);

    // Print out original puzzle grid
    printf("\nPrinting puzzle before search:\n");
    printPuzzle(block);

    // Call searchPuzzle to the word in the puzzle
    searchPuzzle(block, word);

    // Free allocated memory
    for (i = 0; i < bSize; i++)
        free(*(block + i));
    free(block);
    free(word);

    return 0;
}