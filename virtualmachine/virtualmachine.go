package virtualmachine

import (
	"bytes"
	"encoding/binary"
	"fmt"
	//"strconv"
	//"os"
	//"bufio"
)

type VirtualMachine struct {
	bytes     []byte
	reg       []int32
	debug     bool
	threads   []int32
	running   []bool
	curThread int
}

const (
	AND = iota
	ADD
	ADI
	DIV
	LDB
	LDR
	MUL
	SUB
	TRP
	CMP
	BNZ
	BRZ
	MOV
	JMP
	LDA
	STB
	BGT
	BLT
	STR
	JMR //19
	RUN
	LCK
	ULK
	BLK
	END
	OR   //25
	LDBI = 104
	LDRI = 105
	STRI = 118
	STBI = 150
)

//put here for reference mostly
const (
	PC          = 20
	SB          = 21
	FP          = 22
	SP          = 23
	SL          = 24
	NUM_THREADS = 1 //first thread is taken by main
	NUM_REG     = 25
)

func NewVirtualMachine(b []byte) *VirtualMachine {
	v := &VirtualMachine{}
	v.bytes = b
	v.reg = make([]int32, NUM_REG)
	v.threads = make([]int32, NUM_THREADS)
	v.running = make([]bool, NUM_THREADS)
	return v
}

func (v *VirtualMachine) SetBytes(b []byte) {
	v.bytes = b
}

func (v *VirtualMachine) initStack() int {
	//set main to always be running
	v.running[0] = true

	var mainFP, mainPC, totSL, threadSL, thdSL int32

	totSL = 5 * 1000 * 1000 // 4MB stack for now
	threadSL = totSL / NUM_THREADS
	//INIT Stack Pointers
	mainSB := int32(len(v.bytes) - (5 + NUM_REG*4)) // 1 to put it at the last location and 4 for size of int NUM_REG * 4 for the thread state
	mainSL := mainSB - threadSL
	mainSP := mainSB
	mainFP = mainSB
	mainPC = 0

	//TODO: make a complete stack reg to compare against heap pointer for compiling multi threaded

	v.reg[SB] = mainSB
	v.reg[SL] = mainSL
	v.reg[SP] = mainSP
	v.reg[FP] = mainFP
	v.reg[PC] = mainPC

	v.threads[0] = int32(len(v.bytes) - 5) //-4 for int size then -1 so pointing at spot

	v.copyStateIn(int32(len(v.bytes) - 5))

	thdSL = mainSL
	var thdSB, thdTB, thdSP int32
	for i := 1; i < NUM_THREADS; i++ {
		thdTB = thdSL - 5

		//fmt.Printf("%v %v \n",mainSL,thdTB)
		thdSB = thdTB - (NUM_REG * 4)
		thdSL = thdSB - threadSL
		thdSP = thdSB

		v.reg[SB] = thdSB
		v.reg[SL] = thdSL
		v.reg[SP] = thdSP
		v.reg[FP] = thdSB
		v.reg[PC] = 0

		//fmt.Printf("%d ::: %v\n",i,v.reg)
		//fmt.Printf("%v %v %v\n",thdTB,thdSB,thdSL)
		v.threads[i] = thdTB

		v.copyStateIn(thdTB)
	}

	v.takeStateOut(v.threads[0])
	//fmt.Printf("0 ::: %v\n",v.reg)
	//os.Exit(-1)
	return int(mainPC)
}

func (v *VirtualMachine) takeStateOut(threadBottom int32) error {
	b := make([]byte, NUM_REG*4)

	//fmt.Printf("%d : Old Reg %v\n",v.curThread,v.reg)

	threadStateB := threadBottom + 5 // one past the end
	threadStateF := threadStateB - (NUM_REG * 4)
	for i, j := threadStateF, 0; i < threadStateB && j < len(b); i, j = i+1, j+1 {
		//fmt.Printf("j:%d => b[j]: %v  ",i,v.bytes[i])
		//fmt.Printf("%v\n",i)
		b[j] = v.bytes[i]
	}

	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.LittleEndian, &v.reg)

	//fmt.Printf("New Reg %v\n",v.reg)

	return err
}

func (v *VirtualMachine) copyStateIn(threadBottom int32) error {
	b := make([]byte, NUM_REG*4)
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, v.reg)
	if err != nil {
		return fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_, err = buf.Read(b[:])
	if err != nil {
		return fmt.Errorf("Convertion to byte faild %s.", err)
	}
	threadStateB := threadBottom + 5 // one past the end
	threadStateF := threadStateB - (NUM_REG * 4)
	for i, j := threadStateF, 0; i < threadStateB && j < len(b); i, j = i+1, j+1 {
		//fmt.Printf("j:%d => b[j]: %v  ",j,b[j])
		//fmt.Printf("%v\n",i)
		v.bytes[i] = b[j]
	}
	return nil
}

func (v *VirtualMachine) contextSwitch() {
	//fmt.Println("Trying to switch ...")
	switched := false
	for i := v.curThread; i < len(v.threads); i++ {
		if v.running[i] && i != v.curThread {
			//fmt.Printf("switching from %d to %d\n",v.curThread,i)
			v.copyStateIn(v.threads[v.curThread])
			v.takeStateOut(v.threads[i])
			v.curThread = i
			switched = true
			break
		}
	}
	if !switched {
		for i := 0; i < v.curThread; i++ {
			if v.running[i] && i != v.curThread {
				//fmt.Printf("switching from %d to %d\n",v.curThread,i)
				v.copyStateIn(v.threads[v.curThread])
				v.takeStateOut(v.threads[i])
				v.curThread = i
				switched = true
				break
			}
		}
	}
	//fmt.Printf("%d %v\n",v.curThread, v.reg)
}

//Rewrite the different instructions to have the pc copy 4 bits to a ir (slice of 4 bytes) then use the ir for operands and increment pc by 4
func (v *VirtualMachine) Run() error {
	numWait := 0
	pc := v.initStack()
	//Execute the bytes
	for pc < len(v.bytes) {
		if numWait == 0 {
			v.contextSwitch() //switch every time
			numWait = 3
		}
		if v.debug {
			fmt.Printf("thread: %d at %d pc now at %d\n", v.curThread, v.reg[PC], v.reg[PC]+4)
		}
		pc = int(v.reg[PC])
		
		v.reg[PC] += 4
		switch v.bytes[pc] {
		case AND: //0
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.reg[reg1] != 0 && v.reg[reg2] != 0 {
				v.reg[reg1] = 1
			} else {
				v.reg[reg1] = 0
			}
		case OR: //25
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.reg[reg1] != 0 || v.reg[reg2] != 0 {
				v.reg[reg1] = 1
			} else {
				v.reg[reg1] = 0
			}
		case ADD: //1
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("ADD %d + %d = %d\n", v.reg[reg1], v.reg[reg2], v.reg[reg1]+v.reg[reg2])
				//fmt.Scanln()
			}
			v.reg[reg1] = v.reg[reg1] + v.reg[reg2]
		case ADI: //2
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with immediate value %08b in ADI at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 2

			r := v.reg[reg1] + int32(i)
			if v.debug {
				fmt.Printf("ADI %d + %d = %d\n", v.reg[reg1], i, r)
				//fmt.Scanln()
			}
			v.reg[reg1] = r
		case DIV: //3
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("%d / %d = %d\n", v.reg[reg1], v.reg[reg2], v.reg[reg1]/v.reg[reg2])
				//fmt.Scanln()
			}

			v.reg[reg1] = v.reg[reg1] / v.reg[reg2]
		case LDB: //4
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDB at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 2

			r := v.bytes[i]
			v.reg[reg1] = int32(r) //consider actualy placing the byte in a specific location
			if v.debug {
				fmt.Printf("LDB loaded value %d into register %d\n", r, reg1)
				//fmt.Scanln()
			}
		case LDBI: //104
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			r := v.reg[reg2]
			v.reg[reg1] = int32(v.bytes[r]) //consider actualy placing the byte in a specific location
			if v.debug {
				fmt.Printf("LDBI loaded value %d into register %d from \n", r, reg1, v.reg[reg2])
				//fmt.Scanln()
			}
		case LDR: //5
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 2

			r, ferr := convertBytesToInt32(v.bytes[i : i+4])
			if ferr != nil {
				return fmt.Errorf("Problem retrieving value in LDR at address %d", i)
			}
			v.reg[reg1] = r
			if v.debug {
				fmt.Printf("LDR loaded value %d into register %d\n", r, reg1)
				//fmt.Scanln()
			}
		case LDRI: //105
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			i := v.reg[reg2]
			r, ferr := convertBytesToInt32(v.bytes[i : i+4])
			if ferr != nil {
				return fmt.Errorf("Problem retrieving value in LDR at address %d", i)
			}
			v.reg[reg1] = r
			if v.debug {
				// fmt.Printf("i = %d\n",i)
				// fmt.Printf("i 0 %d\n",v.bytes[i])
				// fmt.Printf("i 1 %d\n",v.bytes[i+1])
				// fmt.Printf("i 2 %d\n",v.bytes[i+2])
				// fmt.Printf("i 3 %d\n",v.bytes[i+3])
				fmt.Printf("LDRI loaded value %d into register %d from address %d\n", r, reg1, v.reg[reg2])
				//fmt.Scanln()
			}
		case MUL: //6
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("%d * %d = %d\n", v.reg[reg1], v.reg[reg2], v.reg[reg1]*v.reg[reg2])
				//fmt.Scanln()
			}

			v.reg[reg1] = v.reg[reg1] * v.reg[reg2]
		case SUB: //7
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2
			if v.debug {
				fmt.Printf("%d - %d = %d\n", v.reg[reg1], v.reg[reg2], v.reg[reg1]-v.reg[reg2])
				//fmt.Scan()
			}

			v.reg[reg1] = v.reg[reg1] - v.reg[reg2]
		case TRP: //8
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with immediate value %08b in TRP at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 3

			switch i {
			case 0: //Terminate
				return nil
			case 1: //write integer from stdout
				val := v.reg[0]
				fmt.Printf("%d", val)
			case 2: //read integer from stdin
				var i int32
				_, err := fmt.Scanf("%d", &i)
				for err != nil && err.Error() == "unexpected newline" {
					_, err = fmt.Scanf("%d", &i)
				}
				if err != nil {
					fmt.Printf("Error Reading Integer: %s\n", err)
				}
				v.reg[0] = i
				if v.debug {
					fmt.Printf("Read in %d\n", i)
					//fmt.Scan()
				}
			case 3: //write char to stdout
				val := v.reg[0]
				fmt.Printf("%c", val)
			case 4: //read char from stdin
				var c rune
				if _, err := fmt.Scanf("%c", &c); err != nil {
					fmt.Println(err)
				}
				if c == '\r' {
					if _, err := fmt.Scanf("%c", &c); err != nil {
						fmt.Println(err)
					}
				}
				v.reg[0] = int32(c)
				if v.debug {
					fmt.Printf("Read in %c\n", c)
					//fmt.Scan()
				}
			case 10: //char to int
			case 11: //int to char
			case 99:
				if v.debug {
					v.debug = false
					fmt.Println("Debug off")
				} else {
					v.debug = true
					fmt.Println("Debug on")
				}
			default:
				return fmt.Errorf("Invalid TRP code %d", i)
			}
		//set destination register to zero if destination is equal to source; set destination register to greater than zero if destination is greater than source; set destination register to less than zero if destination is less than source
		case CMP: //9
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("CMP opperands %d and %d\n", v.reg[reg1], v.reg[reg2])
			}
			if v.reg[reg1] == v.reg[reg2] {
				v.reg[reg1] = 0
			} else if v.reg[reg1] > v.reg[reg2] {
				v.reg[reg1] = 1
			} else {
				v.reg[reg1] = -1
			}
			if v.debug {
				fmt.Printf("CMP result %d\n", v.reg[reg1])
				//fmt.Scanln()
			}
		//branch to label if source register is not zero
		case BNZ: //10
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] != 0 {
				i, err := convertBytesToInt16(v.bytes[pc : pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in LDR at address %d", v.bytes[pc:pc+2], pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BNZ to %d\n", pc)
					//fmt.Scanln()
				}
			} else {
				pc += 2
			}
		//branch to label if source register is zero
		case BRZ: //11
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] == 0 {
				i, err := convertBytesToInt16(v.bytes[pc : pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in LDR at address %d", v.bytes[pc:pc+2], pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BRZ to %d\n", pc)
					//fmt.Scanln()
				}
			} else {
				pc += 2
			}
		//move data from source register to destination register
		case MOV: //12
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			v.reg[reg1] = v.reg[reg2]
			if v.debug {
				fmt.Printf("MOV reg %d now has value %d\n", reg1, v.reg[reg2])
				//fmt.Scanln()
			}
		//branch to label
		case JMP: //13
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d", v.bytes[pc:pc+2], pc)
			}
			pc = int(i)
			v.reg[PC] = int32(pc)
			if v.debug {
				fmt.Printf("JMP to %d\n", pc)
				//fmt.Scanln()
			}
		case LDA: //14
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 2

			v.reg[reg1] = int32(i)
			if v.debug {
				fmt.Printf("LDA loaded value %d into register %d\n", i, reg1)
				//fmt.Scanln()
			}
		case STB: //15
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, erra := convertBytesToInt16(v.bytes[pc : pc+2])
			if erra != nil {
				return fmt.Errorf("Problem with address value %08b in STB at address %d", v.bytes[pc:pc+2], pc)
			}

			b, err := convertInt32ToByte(v.reg[reg1])
			if err != nil {
				return fmt.Errorf("Problem with register value %d in STB at address %d", b, pc)
			}
			pc += 2

			v.bytes[i] = b
			if v.debug {
				fmt.Printf("STB loaded value %d into register %d\n", i, reg1)
				//fmt.Scanln()
			}
		//branch to label if source greater then zero
		case BGT: //16
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] > 0 {
				i, err := convertBytesToInt16(v.bytes[pc : pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in BGT at address %d", v.bytes[pc:pc+2], pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BGT to %d\n", pc)
					//fmt.Scanln()
				}
			} else {
				pc += 2
				if v.debug {
					fmt.Printf("BGT NOT branching\n")
					//fmt.Scanln()
				}
			}
		//branch to label if source less then zero
		case BLT: //17
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] < 0 {
				i, err := convertBytesToInt16(v.bytes[pc : pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in BLT at address %d", v.bytes[pc:pc+2], pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BLT to %d\n", pc)
					//fmt.Scanln()
				}
			} else {
				pc += 2
			}
		case STR: //18
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i, erra := convertBytesToInt16(v.bytes[pc : pc+2])
			if erra != nil {
				return fmt.Errorf("Problem with address value %08b in STR at address %d", v.bytes[pc:pc+2], pc)
			}

			b, err := convertInt32ToBytes(v.reg[reg1])
			if err != nil {
				return fmt.Errorf("Problem with register value %d in STR at address %d", b, pc)
			}
			pc += 2

			v.bytes[i] = b[0]
			v.bytes[i+1] = b[1]
			v.bytes[i+2] = b[2]
			v.bytes[i+3] = b[3]
			if v.debug {
				fmt.Printf("STR loaded value %d into register %d\n", i, reg1)
				//fmt.Scanln()
			}
		//branch to register address
		case JMR: //19
			pc += 1
			reg1 := v.bytes[pc]

			pc = int(v.reg[reg1])
			v.reg[PC] = int32(pc)
			if v.debug {
				fmt.Printf("JMR to %d\n", pc)
				//fmt.Scanln()
			}
		case STRI: //118
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			loc := v.reg[reg2]
			i, ierr := convertInt32ToBytes(v.reg[reg1])
			if ierr != nil {
				return fmt.Errorf("Problem converting value fo STR at register %d", reg1)
			}
			v.bytes[loc] = i[0]
			v.bytes[loc+1] = i[1]
			v.bytes[loc+2] = i[2]
			v.bytes[loc+3] = i[3]
			if v.debug {
				// fmt.Printf("i = %d\n",i)
				// fmt.Printf("i 0 %d\n",i[0])
				// fmt.Printf("i 1 %d\n",i[1])
				// fmt.Printf("i 2 %d\n",i[2])
				// fmt.Printf("i 3 %d\n",i[3])
				// fmt.Printf("bytes 0 %d\n",v.bytes[loc + 0])
				// fmt.Printf("bytes 1 %d\n",v.bytes[loc + 1])
				// fmt.Printf("bytes 2 %d\n",v.bytes[loc + 2])
				// fmt.Printf("bytes 3 %d\n",v.bytes[loc + 3])
				fmt.Printf("STRI stored value %d from register %d to address %d\n", i, reg1, v.reg[reg2])
				//fmt.Scanln()
			}
		case STBI: //150
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			loc := v.reg[reg2]
			i, ierr := convertInt32ToBytes(v.reg[reg1])
			if ierr != nil {
				return fmt.Errorf("Problem converting value fo STR at register %d", reg1)
			}
			v.bytes[loc] = i[0]
			if v.debug {
				fmt.Printf("STBI stored value %d from register %d to address %d\n", i, reg1, v.reg[reg2])
			}
		case RUN:
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			newpc, erra := convertBytesToInt16(v.bytes[pc : pc+2])
			if erra != nil {
				return fmt.Errorf("Problem with address value %08b in RUN at address %d", v.bytes[pc:pc+2], pc)
			}
			pc += 2

			//get old thread id
			oldId := v.curThread

			var threaderr error
			v.reg[reg1], threaderr = v.getNewThreadId()
			if threaderr != nil {
				return fmt.Errorf("Problem creating thread: %s", threaderr)
			}
			newId := v.reg[reg1]

			//copy old state in (now with updated thread id register)
			v.copyStateIn(v.threads[oldId])

			tmpReg := make([]int32, len(v.reg))
			copy(tmpReg, v.reg)

			//get the threads state
			v.takeStateOut(v.threads[newId])

			//update the PC
			v.reg[PC] = int32(newpc)
			copy(v.reg[:20], tmpReg[:20])

			//copy new state in (now with update PC)
			v.copyStateIn(v.threads[newId])
			//v.curThread = int(newId)
			//numWait = 3

			//get the old state out as we haven't switched to the new context
			v.takeStateOut(v.threads[oldId])
		case LCK:
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LCK at address %d", v.bytes[pc:pc+2], pc)
			}
			lockID, cerr := convertBytesToInt32(v.bytes[i : i+4])
			if cerr != nil {
				return fmt.Errorf("Invalid thread id for lock\n")
			}

			if lockID != -1 && lockID != int32(v.curThread) {
				pc -= 1
				if v.debug {
					fmt.Printf("Could not get lock at %d on thread %d\n", i, v.curThread)
				}
			} else {
				pc += 3
				b, berr := convertInt32ToBytes(int32(v.curThread))
				if berr != nil {
					return fmt.Errorf("Couldn't lock on thread id")
				}
				v.bytes[i] = b[0]
				v.bytes[i+1] = b[1]
				v.bytes[i+2] = b[2]
				v.bytes[i+3] = b[3]
				if v.debug {
					fmt.Printf("Locking at %d on thread %d\n", i, v.curThread)
				}
			}
		case ULK:
			pc += 1
			i, err := convertBytesToInt16(v.bytes[pc : pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LCK at address %d", v.bytes[pc:pc+2], pc)
			}
			lockID, cerr := convertBytesToInt32(v.bytes[i : i+4])
			if cerr != nil {
				return fmt.Errorf("Invalid thread id for lock\n")
			}

			if lockID != -1 && lockID != int32(v.curThread) {
				pc -= 1
			} else {
				pc += 3
				b, berr := convertInt32ToBytes(-1)
				if berr != nil {
					return fmt.Errorf("Couldn't lock on thread id")
				}
				v.bytes[i] = b[0]
				v.bytes[i+1] = b[1]
				v.bytes[i+2] = b[2]
				v.bytes[i+3] = b[3]
				if v.debug {
					fmt.Printf("Unlocking at %d on thread %d\n", i, v.curThread)
				}
			}
		case BLK:
			if v.curThread == 0 {
				otherThreads := false
				for i := 1; i < len(v.running); i++ {
					if v.running[i] {
						otherThreads = true
					}
				}
				if otherThreads {
					v.reg[PC] = int32(pc)
					v.contextSwitch()
					if v.debug {
						fmt.Printf("BLKING pc now back to %d\n", pc)
						fmt.Scanln()
					}
					continue
				} else {
					pc += 4
				}
			} else {
				pc += 4
			}
		case END:
			pc += 4

			if v.curThread != 0 {
				if v.debug {
					fmt.Printf("Ending thread %d\n", v.curThread)
					fmt.Printf("Currently Running %v\n", v.running)
				}
				v.running[v.curThread] = false
				v.contextSwitch()
				if v.debug {
					fmt.Printf("After Ending thread now %d\n", v.curThread)
					fmt.Printf("Currently Running %v\n", v.running)
				}
				continue
			}
		default:
			return fmt.Errorf("Unknown instruction %08b at %d", v.bytes[pc], pc+1)
		}
		v.reg[PC] = int32(pc)
		numWait--
	}
	return nil
}

func (v *VirtualMachine) getNewThreadId() (int32, error) {
	gotOne := false
	newId := 0
	for i := 1; i < len(v.running); i++ {
		if !v.running[i] {
			v.running[i] = true
			gotOne = true
			newId = i
			break
		}
	}
	if gotOne {
		return int32(newId), nil
	}
	return 0, fmt.Errorf("No more threads to give\n")
}

func convertInt32ToByte(i int32) (byte, error) {
	var b [2]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b[0], fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_, err = buf.Read(b[:])
	return b[0], err
}

func convertInt32ToBytes(i int32) ([]byte, error) {
	var b [4]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b[:], fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_, err = buf.Read(b[:])
	return b[:], err
}

func convertBytesToInt16(b []byte) (int16, error) {
	var i int16
	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.LittleEndian, &i)
	return i, err
}

func convertBytesToInt32(b []byte) (int32, error) {
	var i int32
	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.LittleEndian, &i)
	return i, err
}
