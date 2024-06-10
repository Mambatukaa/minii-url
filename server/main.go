package main

import (
	"fmt" // Package implementing formatted I/O.
)

func main() {
	// Start the server

	i1 := 12345

	fmt.Println(&i1)

	intP := &i1

	fmt.Println(i1)

	*intP = 54321

	fmt.Println(i1)
}
