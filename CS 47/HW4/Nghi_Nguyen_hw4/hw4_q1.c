//
//  hw4_q1.c
//  
//
//  Created by Jennifer Nghi Nguyen on 4/18/17.
//
//

#include <stdio.h>
#include <stdlib.h>
double mean(int const * const array, int const size);//prototype
int maximum(int const * const array, int const size);//prototype
int minimum(int const * const array, int const size);//prototype
void printArray(int const * const array, int const size);//prototype
int main(void){
    unsigned int size;//size of the array
    
    printf("%s", "Enter the size of the array: ");
    scanf("%u", &size); //get the value user enter
    
    int *  array = (int *) malloc(size * sizeof(int));// dynamically create array with size
    printf("%s %d %s\n", "Enter", size, "integer one by one: ");
    
    for(size_t i =0; i<size; i++){
        
        int number;
        scanf("%d", &number);
        *(array + i) = number; // add entered number to the array
    }
    
    printf("%s", "Array: ");
    printArray(array, size); //print whole array
    puts("");//newline
    printf("%s: %.2f\n", "Mean", mean(array, size)); //print out mean
    printf("%s: %d\n", "Maximum", maximum(array, size));//print out maximum value
    printf("%s: %d\n", "Minimum", minimum(array, size));//print out minimum value
    
    free(array); // free array allocated using malloc
}


/*
 * print whole array
*/
void printArray(int const * const array, int const size){
    for(size_t i =0; i<size; i++){
        
        printf("%d ", *(array + i));
    }
}


/**
* find the mean of the array
*/
double mean (int const * const array, int const size){
    int total =0;
    
    for(size_t i=0; i<size; i++){
        total += *(array + i); //get sum of the array
    }
    
    return (double)total/size; //mean
}

/**
 * get maximum of the array
 */
int maximum(int const * const array, int const size){
    int max= * array; // max = array[0]
    for(size_t i=1; i<size; i++){
        if(*(array + i)>max){ // array[i] > max
            max= *(array + i); //max = array[i]
        }
    }
    
    return max;
}


/**
 * get minimum of the array
 */
int minimum(int const * const array, int const size){
    int min= * array; // min = array[0]
    for(size_t i=1; i<size; i++){
        if(*(array + i)<min){
            min= *(array + i);
        }
    }
    
    return min;
}
