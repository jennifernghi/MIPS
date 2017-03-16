//
//  vectorCompression.c
//  
//
//  Created by Jennifer Nghi Nguyen on 3/11/17.
//
//

#include <stdio.h>
int main(void){
    int size =0;
    printf("size = ");
    scanf("%d", &size);
    
    int a[size];
    for(int i =0; i<size;i++){
        int temp = 0;
        scanf("%d", &temp);
        if(temp!=0){
            a[i] = temp;
        }
    }
    
    
    printf("non-zero element:\n");
    for(int i =0; i<size; i++){
        if(a[i]!=0)
            printf("%d\n", a[i]);
        
    }
    
    printf("index non-zero element:\n");
    for(int i =0; i<size; i++){
        if (a[i]!=0)
            printf("%d\n", i);
    }
}
