package virtualmachine

import (
	"fmt"
	"bytes"
	"encoding/binary"
)

type VirtualMachine struct {
	bytes []byte
	reg []int32
	debug bool
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
	JMR
	LDBI = 104
	LDRI = 105
	STRI = 118
)


//put here for reference mostly
const (
	PC = 20
	SB = 21
	FP = 22
	SP = 23
	SL = 24
)

func NewVirtualMachine(b []byte) (*VirtualMachine) {
	v := &VirtualMachine{}
	v.bytes = b
	v.reg = make([]int32,25)
	return v
}

func (v *VirtualMachine) SetBytes(b []byte) {
	v.bytes = b
}

//Rewrite the different instructions to have the pc copy 4 bits to a ir (slice of 4 bytes) then use the ir for operands and increment pc by 4
func (v *VirtualMachine) Run() error {
	//INIT Stack Pointers
	v.reg[SB] = int32(len(v.bytes) - 5) // 1 to put it at the last location and 4 for size of int
	v.reg[SL] = v.reg[SB] - 4 * 1000 * 1000 // 4MB stack for now
	v.reg[SP] = v.reg[SB]
	v.reg[FP] = 0
	pc := 0
	v.reg[PC] = int32(pc)

	//Execute the bytes
	for  pc < len(v.bytes) {
		if v.debug {
			//fmt.Printf("inst at %d pc now at %d\n",v.reg[PC],v.reg[PC] + 4)
		}
		v.reg[PC] += 4
		switch v.bytes[pc] {
		case AND://0
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if(v.reg[reg1] != 0 && v.reg[reg2] != 0) {
				v.reg[reg1] = 1;
			} else {
				v.reg[reg1] = 0;
			}
		case ADD://1
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

if v.debug {
				fmt.Printf("ADD %d + %d = %d\n",v.reg[reg1],v.reg[reg2],v.reg[reg1] + v.reg[reg2])
				//fmt.Scanln()
			}
			v.reg[reg1] = v.reg[reg1] + v.reg[reg2]
		case ADI://2
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with immediate value %08b in ADI at address %d",v.bytes[pc:pc+2],pc)
			}
			pc += 2

			r := v.reg[reg1] + int32(i)
			if v.debug {
				fmt.Printf("ADI %d + %d = %d\n",v.reg[reg1], i, r)
				//fmt.Scanln()
			}
			v.reg[reg1] = r
		case DIV://3
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("%d / %d = %d\n",v.reg[reg1],v.reg[reg2],v.reg[reg1] / v.reg[reg2])
				//fmt.Scanln()
			}

			v.reg[reg1] = v.reg[reg1] / v.reg[reg2]
		case LDB://4
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDB at address %d",v.bytes[pc:pc+2],pc)
			}
			pc += 2

			r := v.bytes[i]
			v.reg[reg1] = int32(r) //consider actualy placing the byte in a specific location
			if v.debug {
				fmt.Printf("LDB loaded value %d into register %d\n",r,reg1)
				//fmt.Scanln()
			}
		case LDBI://104
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			r := v.reg[reg2]
			v.reg[reg1] = int32(v.bytes[r]) //consider actualy placing the byte in a specific location
			if v.debug {
				fmt.Printf("LDBI loaded value %d into register %d from \n",r,reg1,v.reg[reg2])
				//fmt.Scanln()
			}
		case LDR://5
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d",v.bytes[pc:pc+2],pc)
			}
			pc += 2

			r,ferr := convertBytesToInt32(v.bytes[i:i+4])
			if ferr != nil {
				return fmt.Errorf("Problem retrieving value in LDR at address %d",i)
			}
			v.reg[reg1] = r
			if v.debug {
				fmt.Printf("LDR loaded value %d into register %d\n",r,reg1)
				//fmt.Scanln()
			}
		case LDRI://105
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			i := v.reg[reg2]
			r,ferr := convertBytesToInt32(v.bytes[i:i+4])
			if ferr != nil {
				return fmt.Errorf("Problem retrieving value in LDR at address %d",i)
			}
			v.reg[reg1] = r
			if v.debug {
				// fmt.Printf("i = %d\n",i)
				// fmt.Printf("i 0 %d\n",v.bytes[i])
				// fmt.Printf("i 1 %d\n",v.bytes[i+1])
				// fmt.Printf("i 2 %d\n",v.bytes[i+2])
				// fmt.Printf("i 3 %d\n",v.bytes[i+3])
				fmt.Printf("LDRI loaded value %d into register %d from address %d\n",r,reg1,v.reg[reg2])
				//fmt.Scanln()
			}
		case MUL://6
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("%d * %d = %d\n",v.reg[reg1],v.reg[reg2],v.reg[reg1] * v.reg[reg2])
				//fmt.Scanln()
			}

			v.reg[reg1] = v.reg[reg1] * v.reg[reg2]
		case SUB://7
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2
			if v.debug {
				fmt.Printf("%d - %d = %d\n",v.reg[reg1],v.reg[reg2],v.reg[reg1] - v.reg[reg2])
				//fmt.Scan()
			}

			v.reg[reg1] = v.reg[reg1] - v.reg[reg2]
		case TRP://8
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with immediate value %08b in TRP at address %d",v.bytes[pc:pc+2],pc)
			}
			pc += 3

			switch i {
			case 0://Terminate
				return nil
			case 1://write integer from stdout
				val := v.reg[0]
				fmt.Printf("%d",val)
			case 2://read integer from stdin
				var i int32
				if _, err := fmt.Scanf("%d", &i); err != nil {
					fmt.Println(err)
				}
				v.reg[0] = i
				if v.debug {
					fmt.Printf("Read in %d\n",i)
					//fmt.Scan()
				}
			case 3://write char to stdout
				val := v.reg[0]
				fmt.Printf("%c",val)
			case 4://read char from stdin
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
					fmt.Printf("Read in %c\n",c)
					//fmt.Scan()
				}
			case 10:
			case 11:
			case 99:
				if v.debug {
					v.debug = false
					fmt.Println("Debug off")
				} else {
					v.debug = true
					fmt.Println("Debug on")
				}
			default:
				return fmt.Errorf("Invalid TRP code %d",i)
			}
		//set destination register to zero if destination is equal to source; set destination register to greater than zero if destination is greater than source; set destination register to less than zero if destination is less than source
		case CMP: //9
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			if v.debug {
				fmt.Printf("CMP opperands %d and %d\n",v.reg[reg1],v.reg[reg2])
			}
			if v.reg[reg1] == v.reg[reg2] {
				v.reg[reg1] = 0
			} else if v.reg[reg1] > v.reg[reg2] {
				v.reg[reg1] = 1
			} else {
				v.reg[reg1] = -1
			}
			if v.debug {
				fmt.Printf("CMP result %d\n",v.reg[reg1])
				//fmt.Scanln()
			}
		//branch to label if source register is not zero
		case BNZ: //10
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] != 0 {
				i,err := convertBytesToInt16(v.bytes[pc:pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in LDR at address %d",v.bytes[pc:pc+2],pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BNZ to %d\n",pc)
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
				i,err := convertBytesToInt16(v.bytes[pc:pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in LDR at address %d",v.bytes[pc:pc+2],pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BRZ to %d\n",pc)
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
				fmt.Printf("MOV reg %d now has value %d\n",reg1,v.reg[reg2])
				//fmt.Scanln()
			}
		//branch to label
		case JMP: //13
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d",v.bytes[pc:pc+2],pc)
			}
			pc = int(i)
			v.reg[PC] = int32(pc)
			if v.debug {
				fmt.Printf("JMP to %d\n",pc)
				//fmt.Scanln()
			}
		case LDA://14
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,err := convertBytesToInt16(v.bytes[pc:pc+2])
			if err != nil {
				return fmt.Errorf("Problem with address value %08b in LDR at address %d",v.bytes[pc:pc+2],pc)
			}
			pc += 2

			v.reg[reg1] = int32(i)
			if v.debug {
				fmt.Printf("LDA loaded value %d into register %d\n",i,reg1)
				//fmt.Scanln()
			}
		case STB://15
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,erra := convertBytesToInt16(v.bytes[pc:pc+2])
			if erra != nil {
				return fmt.Errorf("Problem with address value %08b in STB at address %d",v.bytes[pc:pc+2],pc)
			}

			b,err := convertInt32ToByte(v.reg[reg1])
			if err != nil {
				return fmt.Errorf("Problem with register value %d in STB at address %d",b,pc)
			}
			pc += 2

			v.bytes[i] = b
			if v.debug {
				fmt.Printf("STB loaded value %d into register %d\n",i,reg1)
				//fmt.Scanln()
			}
		//branch to label if source greater then zero
		case BGT: //16
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			if v.reg[reg1] > 0 {
				i,err := convertBytesToInt16(v.bytes[pc:pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in BGT at address %d",v.bytes[pc:pc+2],pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BGT to %d\n",pc)
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
				i,err := convertBytesToInt16(v.bytes[pc:pc+2])
				if err != nil {
					return fmt.Errorf("Problem with address value %08b in BLT at address %d",v.bytes[pc:pc+2],pc)
				}
				pc = int(i)
				v.reg[PC] = int32(pc)
				if v.debug {
					fmt.Printf("BLT to %d\n",pc)
					//fmt.Scanln()
				}
			} else {
				pc += 2
			}
		case STR://18
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			i,erra := convertBytesToInt16(v.bytes[pc:pc+2])
			if erra != nil {
				return fmt.Errorf("Problem with address value %08b in STR at address %d",v.bytes[pc:pc+2],pc)
			}

			b,err := convertInt32ToBytes(v.reg[reg1])
			if err != nil {
				return fmt.Errorf("Problem with register value %d in STR at address %d",b,pc)
			}
			pc += 2

			v.bytes[i] = b[0]
			v.bytes[i+1] = b[1]
			v.bytes[i+2] = b[2]
			v.bytes[i+3] = b[3]
			if v.debug {
				fmt.Printf("STR loaded value %d into register %d\n",i,reg1)
				//fmt.Scanln()
			}
		//branch to register address
		case JMR: //19
			pc += 1
			reg1 := v.bytes[pc]
			
			pc = int(v.reg[reg1])
			v.reg[PC] = int32(pc)
			if v.debug {
				fmt.Printf("JMR to %d\n",pc)
				//fmt.Scanln()
			}
		case STRI: //118
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			loc := v.reg[reg2]
			i,ierr := convertInt32ToBytes(v.reg[reg1])
			if ierr != nil {
				return fmt.Errorf("Problem converting value fo STR at register %d",reg1)
			}
			v.bytes[loc] = i[0]
			v.bytes[loc + 1] = i[1]
			v.bytes[loc + 2] = i[2]
			v.bytes[loc + 3] = i[3]
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
				fmt.Printf("STRI stored value %d from register %d to address %d\n",i,reg1,v.reg[reg2])
				//fmt.Scanln()
			}
		default:
			return fmt.Errorf("Unknown instruction %08b at %d", v.bytes[pc],pc + 1)
		}
	}
	return nil
}

func convertInt32ToByte(i int32) (byte,error) {
	var b [2]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b[0],fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_,err = buf.Read(b[:])
	return b[0],err
}

func convertInt32ToBytes(i int32) ([]byte,error) {
	var b [4]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b[:],fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_,err = buf.Read(b[:])
	return b[:],err
}

func convertBytesToInt16(b []byte) (int16,error) {
	var i int16
	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.LittleEndian,&i)
	return i,err
}

func convertBytesToInt32(b []byte) (int32,error) {
	var i int32
	buf := bytes.NewBuffer(b)
	err := binary.Read(buf, binary.LittleEndian,&i)
	return i,err
}
