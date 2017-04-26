//
//  hw4_q2.c
//  
//
//  Created by Jennifer Nghi Nguyen on 4/19/17.
//
//

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#define DEFAULT_SIZE 5

void rot13(char *);//prototype
char * getString(FILE* fp, size_t size);//prototype
int main(void){
    char *str;
    
    printf("%s\n", "Enter a string of letters: ");
    //getString from stdin
    str=getString(stdin, DEFAULT_SIZE);
    
    printf("%s: %s\n","Original", str);
    rot13(str);//call rot 13
    printf("%s: %s\n","After ROT13", str);
    free(str);
    
}
/**
 rot13 funtion
 ABCDEFGHIJKLM
 |||||||||||||
 NOPQRSTUVWXYZ
*/
void rot13(char * str){
    while(*str!= '\0'){
        
        if((*str>= 'A' && *str<='M') || (*str>= 'a' && *str<='m' )){
            *str += 13;
        }else if((*str>= 'N' && *str<='Z') || (*str>= 'n' && *str<='z')){
            *str -= 13;
        }
        
        ++str;
        
    }
}
/*
 * input string with arbitrary length using dynamic allocation in memory
 */
char * getString(FILE* fp, size_t size){
    char *arrayDest;
    char c;
    size_t stringLength = 0;
    arrayDest = (char *) malloc(sizeof(char)*size); // reserve (size) byte for arrayDest
    
    while(EOF!=(c=fgetc(fp)) && c!= '\n'){
        arrayDest[stringLength]=c;
        ++stringLength;
        
        //double the size when stringLength = size and reallocate arrayDest with new size
        if(stringLength==size){
            arrayDest = realloc(arrayDest, sizeof(char)*(size*=2));
        }
    }
    //append '\0' when input end
    arrayDest[stringLength]='\0';
    
    //shrink the size of arrayDest to stringLength
    return realloc(arrayDest,sizeof(char)*stringLength);
}
