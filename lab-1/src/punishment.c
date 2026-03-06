#include <stdio.h>

int main() {
    int count, typo_line;

    printf("Enter the repetition count for the punishment phrase: ");
    while (scanf("%d", &count) == 1) {
        if (count > 0) {
            break;
        } 

        printf("You entered an invalid value for the repetition count! Please re-enter: ");
    }

    printf("\n");
    printf("Enter the line where you want to insert the typo: ");
    while (scanf("%d", &typo_line) == 1) {
        if (typo_line > 0 && typo_line <= count) {
            break;
        }

        printf("You entered an invalid value for the typo placement! Please re-enter: ");
    }

    printf("\n");
    // Iterate from 1 up to the repetition count
    for (int i = 1; i <= count; i++) {
        
        // If the current line is the typo line, print the typo
        if (i == typo_line) {
            printf("Cading wiht is C avesone!\n");
        } 
        // Otherwise, print the correct sentence
        else {
            printf("Coding with C is awesome!\n");
        }
    }

    return 0;
}