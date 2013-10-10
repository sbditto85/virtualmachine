package main

import (
	//"github.com/sbditto85/virtualmachine/assembler"
	amb "./assembler"
	vm "./virtualmachine"
	"flag"
	"fmt"
)

func main() {
	filename := flag.String("f", "", "the name of the .asm file to parse and run")
	flag.Parse()

	a := amb.NewAssembler()

	a.ReadFile(*filename)
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

	//fmt.Printf("%+v\n",a.GetSymbols())
	//fmt.Printf("%x\n", a.GetBytes())
	/*var i int
	for _,b := range a.GetBytes(){
		//if b != 0 {
		if i < 828 {
			//fmt.Printf("%x ",b)
			fmt.Printf("%d ",b)
			i++
			if i % 4 == 0 {
				fmt.Println()
			}
		}
	}*/
	//fmt.Println(i)

	v := vm.NewVirtualMachine(a.GetBytes())
	verr := v.Run()
	if verr != nil {
		fmt.Printf("%s\n",verr.Error())
	}
}
