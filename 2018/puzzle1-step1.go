package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	frequency := 0

	file, _ := os.Open("puzzle1.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		input := scanner.Text()
		i, _ := strconv.Atoi(input[1:])
		if input[0:1] == "+" {
			frequency += i
		} else if input[0:1] == "-" {
			frequency -= i
		}
	}
	
	fmt.Println(strconv.Itoa(frequency))
}