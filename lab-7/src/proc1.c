#include <stdio.h>

// Sum procedure
int sum(int a, int b) {
    return a + b;
}

int main() {
    int m = 10;
    int n = 5;
    
    int result = sum(m, n);
    printf("%d", result);
    
    return 0;
}