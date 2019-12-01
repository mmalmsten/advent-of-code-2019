#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// The sum of the fuel requirements for a module on the spacecraft, also 
// taking into account the mass of the added fuel.
int required_fuel(int number){
	int n = floor(number / 3) - 2;
	if(n > 0)
		return n + required_fuel(n);
	return 0;
}

int main(void)
{
	// Import puzzle data and add to array
	FILE *fptr;
	fptr = fopen(
		"/Users/madde/Sites/advent-of-code-2019/input/puzzle1.txt","r"
	);

	int numberArray[100];
    int i;
    for (i = 0; i < 100; i++) {
        fscanf(fptr, "%d", &numberArray[i]);
    }
	fclose(fptr); 

	// Find the fuel required for all modules
	int sum = 0;
	int fuel = 0;
    for (i = 0; i < 100; i++){
    	sum += required_fuel(numberArray[i]);
    }

    printf("Fuel is: %d\n", sum);
}