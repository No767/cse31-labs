#include <stdio.h>
#include <stdlib.h>

int* bubbleSort(int arr[], int n) {
    int temp, i = 0, j = 0;
    int *s_arr = (int *) malloc(n * sizeof(int));

    // Copy arr to s_arr
    for(i = 0; i < n; i++)
        s_arr[i] = arr[i];

    // Sorting using array notations
    // Answers to question 1:
    // 1a. We need to pass in the size (denoted by "n") in order to allocate the proper amount of memory
    //     We could use the length of the array, but it's not initalized so we don't know how many until the user specifies
    //     
    // 1b. No. *s_arr is an entirely new array based off of the passed-in size. So there are no edits done to the original function; thus no.
    //
    // 1c. If we sorted in-place, we would lose the original order of the array. So, in order to preserve the order of the original array, we copy it.
    //     If this wasn't done, then the program can't display the before and after state
    
	// Comment this when implementing pointer version.
    // for (i = 0; i < n - 1; i++) {
    //     for(j = 0; j < n - 1; j++) {
    //         if(s_arr[j] > s_arr[j + 1]) {
    //             temp = s_arr[j + 1];
    //             s_arr[j + 1] = s_arr[j];
    //             s_arr[j] = temp;
    //         }
    //     }
    // }

    // Sorting using pointer notations. i.e. you cannot use "[]"!
    // Your code goes here...
    
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - 1; j++) {
        int curr_element = *(s_arr + j);
        int next_element = *(s_arr + j + 1);
        
        if (curr_element > next_element) {
          temp = next_element;
          *(s_arr + j + 1) = *(s_arr + j);
          *(s_arr + j) = temp;
        }
      }
    }

    return s_arr;

}

void printArray(int arr[], int n) {
    int i = 0;
    printf("[");
    for(i = 0; i < n; i++)
        printf("%d ", arr[i]);
    printf("]\n");
}

int bSearch(int *arr, int a, int b, int key) {
    // Binary search function. arr is the array, key is the value to search for, a and b are the boundaries of arr to be searched within.
    // You must use pointer notations. i.e. no "[]"
    // Your code goes here:
    //
    if (b >= a) {
      int middle = a + (b - a) / 2;

      if (*(arr + middle) == key) {
        return middle;
      }

      if (*(arr + middle) > key) {
        return bSearch(arr, a, middle - 1, key);
      }
      return bSearch(arr, middle + 1, b, key);
    }


	return -1; // Modify this to return an appropriate value!
}

int main() {

    int i = 0, size = 0, key = 0, result = 0;
    int *array, *sorted;

    printf("How big is your array? ");
    scanf("%d", &size);
    array = (int *) malloc(size * sizeof(int));

    for(i = 0; i < size; i++) {
        printf("Please enter array[%d]: ", i);
        scanf("%d", &array[i]);
    }

    printf("Please wait while I sort your numbers...\n");
    sorted = bubbleSort(array, size);
    printf("Here is your original array:\n");
    printArray(array, size);
    printf("Here is your SORTED array: \n");
    printArray(sorted, size);
    printf("What number are you looking for? ");
    scanf("%d", &key);
    printf("OK, let me see if I can find a \"%d\" in the array...\n", key);
    result = bSearch(sorted, 0, size-1, key);
    if(result != -1)
        printf("Got it! A \"%d\" is at index %d.\n", key, result);
    else
        printf("I'm sorry, \"%d\" cannot be found in the array.\n", key);

	return 0;


}


