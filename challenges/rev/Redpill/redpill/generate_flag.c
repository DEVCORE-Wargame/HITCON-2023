#include <stdlib.h>
#include <stdio.h>

int main(){

    char input[43];
    int ip[4];
    long  a = 0;

    printf("input flag:");
    scanf("%42s", input);

    for(int i = 0 ; i < 42 ; i +=2 )
    {
        printf("%d, %d, ", 3*input[i]-2*input[i+1],4*input[i]+7*input[i+1]);
    } 

    return 0;
}

