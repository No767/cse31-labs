#include<stdio.h>
#include<string.h>
#include <stdlib.h> // Apparently clangd complains if this is not included

int size; // Variable to record size of original array arr
int evenCount = 0, oddCount = 0; // Variables to record sizes of new arrays arr_even and arr_odd
int *arr; // Dynamically allocated original array with #elements = size
int *arr_even;  // Dynamically allocated array with #elements = #even elements in arr (evenCount)
int *arr_odd;   // Dynamically allocated array with #elements = #odd elements in arr (oddCount)
char *str1 = "Original array's contents: ";
char *str2 = "Contents of new array containing even elements from original: ";
char *str3 = "Contents of new array containing odd elements from original: ";

/*
 * DO NOT change the definition of the printArr function when it comes to 
 * adding/removing/modifying the function parameters, or changing its return 
 * type. 
 */
void printArr(int *a, int size, char *prompt){
    printf("%s", prompt);

    if (size == 0) {
        printf("empty\n");
        return;
    }

    for (int i = 0; i < size; i++) {
        printf("%d ", *(a + i));
    }
    printf("\n");
}

/* 
 * DO NOT change the definition of the arrCopy function when it comes to 
 * adding/removing/modifying the function parameters, or changing its return 
 * type. 
 */
void arrCopy(){
	// Your code here

    // The pointers are just to not mess up the global index of where it is pointing to on the element
    // It just ensures that the data will be the same at the end, with the index being pointing to 0
    // If we assigned it back, it would just be a single int, ruining the whole program
    int* temp_arr = arr;
    int* temp_arr_even = arr_even;
    int* temp_arr_odd = arr_odd;

    // The variable "size" would already be initalized by this point
    // So it' safe to use
    for (int i = 0; i < size; i++) {
        // Deference the value and check whether it is even or not
        int currElement = *(temp_arr + i);
        if (currElement % 2 == 0) {

            // What we basically are doing instead is to do the following:
            // 1. On the first slot, assign the correct number from our temp_arr
            // 2. Offset by 4 bytes (using the ++ operator) to get to the next set of elements to put in
            *temp_arr_even = currElement;
            temp_arr_even++;
        }
        else {
            *temp_arr_odd = currElement;
            temp_arr_odd++;
        }
    }
    
}

int main(){
    int i;
    printf("Enter the size of array you wish to create: ");
    scanf("%d", &size);

    // Dynamically allocate memory for arr (of appropriate size)
    // Your code here
    arr = (int *) malloc(size * sizeof(int));
    

    // Ask user to input content of arr and compute evenCount and oddCount
	// Your code here
    for (int i = 0; i < size; i++) {
        printf("Enter array element #%d: ", i + 1);
        scanf("%d", arr + i);

        int isEven = *(arr + i) % 2;
        if (isEven == 0) {
            evenCount++;
        }
        else {
            oddCount++;
        }
    }

    // Dynamically allocate memory for arr_even and arr_odd (of appropriate size)
    // Your code here    
    arr_even = (int*) malloc(evenCount * sizeof(int));
    arr_odd = (int*) malloc(oddCount * sizeof(int));

    printf("\n");
	
/*************** YOU MUST NOT MAKE CHANGES BEYOND THIS LINE! ***********/
	
	// Print original array
    printArr(arr, size, str1);

	/// Copy even elements of arr into arr_even and odd elements into arr_odd
    arrCopy();

    // Print new array containing even elements from arr
    printArr(arr_even, evenCount, str2);

    // Print new array containing odd elements from arr
    printArr(arr_odd, oddCount, str3);

    printf("\n");

    return 0;
}