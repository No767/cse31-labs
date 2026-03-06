#include <stdio.h>
#include <stdlib.h>

char* get_suffix(int n) {
    if (n < 0) {
        n = -n;
    }

    int last_two_digits = n % 100;
    if (last_two_digits >= 11 && last_two_digits <= 13) {
        return "th";
    }

    int last_digit = n % 10;

    if (last_digit == 1) {
        return "st";
    }
    else if (last_digit == 2) {
        return "nd";
    }
    else if (last_digit == 3) {
        return "rd";
    }
    else {
        return "th";
    }
}

int is_total_even(int n) {
    if (n < 0) n = -n;

    int sum = 0;
    while (n > 0) {
        sum += (n % 10);
        n /= 10;
    }
    
    return (sum % 2 == 0);
}
int main() {
    int capacity = 2;
    int count = 0;

    int *inputs = (int * )malloc(capacity * sizeof(int));

    float even_sum = 0;
    float odd_sum = 0;
    
    int even_sum_count = 0;
    int odd_sum_count = 0;

    int input;
    while (printf("Enter the %d%s value: ", count + 1, get_suffix(count + 1)), scanf("%d", &input) == 1 && input != 0) {
        
        // This is entirely overkill for this purpose
        if (count == capacity) {
            capacity *= 2;

            int *temp = realloc(inputs, capacity * sizeof(int));

            inputs = temp;
        }

        if (is_total_even(input) == 1) {
            even_sum += input;
            even_sum_count++;
        }
        else {
            odd_sum += input;
            odd_sum_count++;
        }

        inputs[count] = input;
        count++;
    }

    printf("\n");

    if (even_sum_count > 0) {
        printf("Average of input values whose digits sum up to an even number: %f\n", even_sum / even_sum_count);
    }
    if (odd_sum_count > 0) {
        printf("Average of input values whose digits sum up to an odd number: %f", odd_sum / odd_sum_count);
    }

    if (even_sum_count == 0 && odd_sum_count == 0) {
        printf("There is no average to compute.");
    }

    



    // printf("\nYou stored %d numbers: ", count);
    // for (int i = 0; i < count; i++) {
    //     printf("%d ", inputs[i]);
    // }
    // printf("\n");


    free(inputs);

    

    // for (int i = 1; i < 11; i++) {
    //     printf("Enter the %d%s value: ", i, get_suffix(i));
    //     scanf("%d", &input_value);
    //     printf("Output is: %d\n", input_value);
    // }

    return 0;
}