//
//  maximum.c
//  
//
//  Created by Jennifer Nghi Nguyen on 3/16/17.
//
//

#include <stdio.h>
int main(void){
    int a[3];
    printf("Enter first number: ");
    scanf("%d", &a[0]);
    
    printf("Enter second number: ");
    scanf("%d", &a[1]);

    
    printf("Enter third number: ");
    scanf("%d", &a[2]);
  
    int max = a[0];
    
    for(int i =0; i<3; i++){
        if(a[i]>max){
            max=a[i];
        }
    }
    
    printf("The largest number: %d", max);
}
