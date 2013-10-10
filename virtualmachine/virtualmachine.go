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
)

func NewVirtualMachine(b []byte) (*VirtualMachine) {
	v := &VirtualMachine{}
	v.bytes = b
	v.reg = make([]int32,20)
	return v
}

func (v *VirtualMachine) SetBytes(b []byte) {
	v.bytes = b
}

func (v *VirtualMachine) Run() error {
	pc := 0
	for  pc < len(v.bytes) {
		switch v.bytes[pc] {
		case AND://0
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			v.reg[reg1] = v.reg[reg1] & v.reg[reg2]
		case ADD://1
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

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

			r := int16(v.reg[reg1]) + i
			v.reg[reg1] = int32(r)
		case DIV://3
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

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
			v.reg[reg1] = int32(r)
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
		case MUL://6
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

			v.reg[reg1] = v.reg[reg1] * v.reg[reg2]
		case SUB://7
			pc += 1
			reg1 := v.bytes[pc]
			pc += 1
			reg2 := v.bytes[pc]
			pc += 2

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
			case 3://write char to stdout
				val := v.reg[0]
				fmt.Printf("%c",val)
			case 4://read char from stdin
			case 10:
			case 11:
			case 99:
				if v.debug {
					v.debug = false
				} else {
					v.debug = true
				}
			default:
				return fmt.Errorf("Invalid TRP code %d",i)
			}
		default:
			return fmt.Errorf("Unknown instruction %08b at %d", v.bytes[pc],pc + 1)
		}
	}
	return nil
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
