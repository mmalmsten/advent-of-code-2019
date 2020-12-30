package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

// Import and format frequences to a slice of positive and negative ints
func importfrequences() []int {
	var frequences []int
	var value int

	file, _ := os.Open("puzzle1.txt")
	defer file.Close()
	
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		input := scanner.Text()
		i, _ := strconv.Atoi(input[1:])
		if input[0:1] == "+" { 
			value = i
		} else if input[0:1] == "-" {
			value = 0 - i
		}
		frequences = append(frequences, value)
	}
	
	return frequences
}

func memberOfSlice(a int, list []int) bool {
    for _, b := range list {
        if b == a {
            return true
        }
    }
    return false
}

func main() {
	frequences := importfrequences()

	frequency := 0
	var old_frequences []int

	n := 0
	for true {
		// Reset counter if the end of frequences is reached
		if(n == len(frequences)){ n = 0 }

		// Break if frequency exists in old_frequences
		if(memberOfSlice(frequency, old_frequences)){ break }
		
		// Add frequence to a slice of old frequences
		old_frequences = append(old_frequences, frequency)
		
		// Update with a new frequence
		frequency += frequences[n]
		n += 1
	}

	fmt.Println(strconv.Itoa(frequency))

}