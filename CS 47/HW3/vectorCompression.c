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
    
    int k=0;
    int a[size];
    for(int i =0; i<2*size;i=i+2){
        int temp = 0;
        scanf("%d", &temp);
        if(temp!=0){
            a[k] = temp;
            a[k+1] = i/2;
            k += 2;
        }
    }
    
    printf("k %d\n", k);
    
    printf("non-zero element:\n");
    for(int i =0; i<k; i=i+2){
        printf("%d\n", a[i]);
        
    }
    
    printf("index non-zero element:\n");
    for(int i =1; i<=k; i+=2){
        printf("%d\n", a[i]);
    }
}
