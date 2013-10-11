package main

import (
	//"github.com/sbditto85/virtualmachine/assembler"
	amb "./assembler"
	vm "./virtualmachine"
	"flag"
	"fmt"
	"time"
)

func main() {
	start := time.Now()
	s := time.Now()
	filename := flag.String("f", "", "the name of the .asm file to parse and run")
	flag.Parse()
	e := time.Now()
	fmt.Printf("Flags: %v\n",e.Sub(s))

	s = time.Now()
	a := amb.NewAssembler()
	e = time.Now()
	fmt.Printf("NewAssembler: %v\n",e.Sub(s))

	s = time.Now()
	a.ReadFile(*filename)
	e = time.Now()
	fmt.Printf("ReadFile: %v\n",e.Sub(s))

	s = time.Now()
	fperr := a.FirstPass()
	e = time.Now()
	fmt.Printf("FirstPass: %v\n",e.Sub(s))
	if fperr == nil {

		s = time.Now()
		sperr := a.SecondPass()
		e = time.Now()
		fmt.Printf("SecondPass: %v\n",e.Sub(s))

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

	s = time.Now()
	v := vm.NewVirtualMachine(a.GetBytes())
	e = time.Now()
	fmt.Printf("NewVirtualMachine: %v\n",e.Sub(s))

	s = time.Now()
	verr := v.Run()
	e = time.Now()
	fmt.Printf("Run: %v\n",e.Sub(s))
	if verr != nil {
		fmt.Printf("%s\n",verr.Error())
	}

	end := time.Now()
	fmt.Printf("Total: %v\n",end.Sub(start))
}
