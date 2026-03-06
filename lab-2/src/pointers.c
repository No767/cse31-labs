#include <stdio.h>

int main() {
    int SIZE = 10;

    int x, y, *px, *py;
    int arr[SIZE];


    // for (int i = 0; i < SIZE; i ++) {
    //     printf("%d\n", *(arr + 1));
    // }

    printf("First value of arr via arr[0]: %d (%p)", arr[0], &arr[0]);
    printf("\n");
    printf("First value of arr via pointer: %d (%p)", *(arr + 0), &*(arr + 0));

    printf("");

    // printf("value for x: %d, value for y: %d", x, y);
    // printf("\n");
    // printf("x: %p, y: %p", &x, &y);
    // printf("\n");

    // printf("\n");

    // px = &x;
    // py = &y;

    // printf("value for *px: %d, value for *py: %d", *px, *py);
    // printf("\n");
    // printf("*px: %p, *py: %p", px, py);
    // printf("\n");
    // printf("arr10: %p", &arr);

    // printf("arr[10]: %d", arr);

    return 0;
}