#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(void) {
	// Import puzzle data and add to array
	FILE *fptr;
	fptr = fopen("puzzle1.txt","r");

	int numberArray[100];
	int i;
	for (i = 0; i < 100; i++) {
		fscanf(fptr, "%d", &numberArray[i]);
	}
	fclose(fptr); 

	// To find the fuel required for a module, take its mass, divide by three,
	// round down, and subtract 2.
	int sum = 0;
	for (i = 0; i < 100; i++){
		sum += floor(numberArray[i] / 3) - 2;
	}

	printf("Fuel is: %d\n", sum);
}