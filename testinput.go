package main

import (
	"fmt"
)


func main() {

	var c rune
	if _, err := fmt.Scanf("%c", &c); err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%c",c)
	if _, err := fmt.Scanf("%c", &c); err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%c",c)
	if _, err := fmt.Scanf("%c", &c); err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%c",c)
	if _, err := fmt.Scanf("%c", &c); err != nil {
		fmt.Println(err)
	}

	fmt.Printf("%c",c)

}
