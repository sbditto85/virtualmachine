package main

import (
	amb "github.com/sbditto85/virtualmachine/assembler"
	vm "github.com/sbditto85/virtualmachine/virtualmachine"
	"fmt"
	"os"
)

func main() {
	args := os.Args

	if len(args) != 2 {
		fmt.Printf("Please run program %s <filename>.\n",args[0])
		os.Exit(-1)
	}

	filename := args[1]

	a := amb.NewAssembler()
	a.ReadFile(filename)

	fperr := a.FirstPass()
	if fperr == nil {
		sperr := a.SecondPass()
		if sperr == nil {
			sperr = sperr
		} else {
			fmt.Println(sperr)
		}
	} else {
		fmt.Println(fperr)
	}

/*
	for i,b := range a.GetBytes() {
		if i < 504 {
			continue
		}
		if i > 507 && b == 0 {
			break;
		}
		fmt.Printf("%d = %d\n",i,b)
	}
	fmt.Scanln()
*/

	v := vm.NewVirtualMachine(a.GetBytes())
	verr := v.Run()
	if verr != nil {
		fmt.Printf("%s\n",verr.Error())
	}

/*
	for i,b := range a.GetBytes() {
		if i < 504 {
			continue
		}
		if i > 507 && b == 0 {
			break;
		}
		fmt.Printf("%d = %d\n",i,b)
	}
	fmt.Scanln()
*/
}
