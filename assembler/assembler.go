package assembler

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Assembler struct {
	file    []string
	symbols map[string]int
	bytes   []byte
}

func NewAssembler() *Assembler {
	a := Assembler{}
	a.symbols = make(map[string]int)
	a.bytes = make([]byte, 5*1000*1000) //5MB of memory
	return &a
}

//Puts the contents of file in to the file string slice
//stolen and modified from http://stackoverflow.com/a/18479916/706882
func (a *Assembler) ReadFile(f string) error {
	file, err := os.Open(f)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		a.file = append(a.file, scanner.Text())
	}
	return scanner.Err()
}

func (a *Assembler) ReadStrings(strs []string) {
	a.file = strs
}

func (a *Assembler) FirstPass() error {
	address := 0
	for linenum, line := range a.file {
		defer func() {
			if r := recover(); r != nil {
				fmt.Printf("Recovered from unhandled error on line number %d  => %s\nExiting...\n", linenum+1, r)
				os.Exit(-1)
			}
		}()
		parts := strings.Fields(line)
		if len(parts) < 1 || parts[0][0] == ';' {
			continue
		}

		if parts[0][len(parts[0])-1] == ':' {
			a.symbols[parts[0]] = address
			parts = parts[1:]
		}

		for i, v := range parts {
			if v[0] == ';' {
				parts = parts[:i]
				break
			}
		}

		switch parts[0] {
		case "AND", "ADD", "DIV", "MUL", "SUB", "CMP", "MOV":
			address += 4
			if err := a.verifyTwoRegisters(parts, parts[0], linenum+1); err != nil {
				return err
			}
		case "ADI":
			address += 4
			if len(parts) != 3 {
				return fmt.Errorf("ADI should only have 2 opperands line number %d", linenum+1)
			}
			if parts[1][0] != 'R' {
				return fmt.Errorf("ADI opperand 1 must be a register line number %d", linenum+1)
			}
			if parts[2][0] != '#' {
				return fmt.Errorf("ADI opperand 2 must be an immediate value line number %d", linenum+1)
			}
		case "LDB", "LDR", "BNZ", "BRZ", "LDA", "STB", "BGT", "BLT", "STR", "RUN":
			address += 4
			if err := a.verifyRegLabel(parts, parts[0], linenum+1); err != nil {
				return err
			}
		case "JMP", "LCK", "ULK":
			address += 4
			if len(parts) != 2 {
				return fmt.Errorf("%s should only have 1 opperand line number %d", parts[0], linenum+1)
			}
		case "JMR":
			address += 4
			if err := a.verifyRegister(parts, parts[0], linenum+1); err != nil {
				return err
			}
		case "TRP":
			address += 4
			if len(parts) != 2 {
				return fmt.Errorf("TRP should only have 1 opperand line number %d", linenum+1)
			}
			if parts[1][0] != '#' {
				return fmt.Errorf("TRP opperand 1 must be an immediate value line number %d", linenum+1)
			}
		case "BLK", "END":
			address += 4
			if len(parts) != 1 {
				return fmt.Errorf("%s should only have 0 opperands line number %d", parts[0], linenum+1)
			}
		case ".BYT":
			address += 1
			if len(parts) != 2 {
				return fmt.Errorf(".BYT should only have 1 opperands line number %d", linenum+1)
			}
		case ".INT":
			address += 4
			if len(parts) != 2 {
				return fmt.Errorf(".INT should only have 1 opperands line number %d", linenum+1)
			}
		default:
			return fmt.Errorf("Unknown instruction %s at %d", parts[0], linenum+1)
		}

		//fmt.Printf("%+v\n",parts)
	}
	return nil
}

func (a *Assembler) verifyTwoRegisters(parts []string, opp string, ln int) error {
	if len(parts) != 3 {
		return fmt.Errorf("%s should only have 2 opperands line number %d", opp, ln)
	}
	if parts[1][0] != 'R' {
		return fmt.Errorf("%s opperand 1 must be a register line number %d", opp, ln)
	}
	if parts[2][0] != 'R' {
		return fmt.Errorf("%s opperand 2 must be a register line number %d", opp, ln)
	}
	return nil
}

func (a *Assembler) verifyRegister(parts []string, opp string, ln int) error {
	if len(parts) != 2 {
		return fmt.Errorf("%s should only have 1 opperands line number %d", opp, ln)
	}
	if parts[1][0] != 'R' {
		return fmt.Errorf("%s opperand 1 must be a register line number %d", opp, ln)
	}
	return nil
}

func (a *Assembler) verifyRegLabel(parts []string, opp string, ln int) error {
	if len(parts) != 3 {
		return fmt.Errorf("%s should only have 2 opperands line number %d", opp, ln)
	}
	if parts[1][0] != 'R' {
		return fmt.Errorf("%s opperand 1 must be a register line number %d", opp, ln)
	}
	return nil
}

func (a *Assembler) SecondPass() error {
	address := 0
	for linenum, line := range a.file {
		parts := strings.Fields(line)
		if len(parts) < 1 || parts[0][0] == ';' {
			continue
		}

		if parts[0][len(parts[0])-1] == ':' {
			parts = parts[1:]
		}

		for i, v := range parts {
			if v[0] == ';' {
				parts = parts[:i]
				break
			}
		}

		switch parts[0] {
		case "AND": //0
			a.bytes[address] = 0
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "OR": //25
			a.bytes[address] = 25
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "ADD": //1
			a.bytes[address] = 1
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "ADI": //2
			a.bytes[address] = 2
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			b, err2 := a.getImmediate(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = b[0]
			address += 1
			a.bytes[address] = b[1]

			//position for next line
			address += 1
		case "DIV": //3
			a.bytes[address] = 3
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "LDB": //4 or 104
			if parts[2][0] == '(' {
				a.bytes[address] = 104
			} else {
				a.bytes[address] = 4
			}
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			if parts[2][0] == '(' {
				reg2, err2 := a.getRegister(parts[2][1 : len(parts[2])-1])
				if err2 != nil {
					return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
				}
				a.bytes[address] = reg2
				address += 1
			} else {
				//get label address
				addr, ok := a.symbols[parts[2]]
				if !ok {
					return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
				}
				bytes, err := a.convertInt16ToBytes(int16(addr))
				if err != nil {
					return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
				}

				a.bytes[address] = bytes[0]
				address += 1

				a.bytes[address] = bytes[1]
			}

			//position for next line
			address += 1
		case "LDR": //5 or 105 for indirect
			if parts[2][0] == '(' {
				a.bytes[address] = 105
			} else {
				a.bytes[address] = 5
			}
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			if parts[2][0] == '(' {
				reg2, err2 := a.getRegister(parts[2][1 : len(parts[2])-1])
				if err2 != nil {
					return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
				}
				a.bytes[address] = reg2
				address += 1
			} else {
				//get label address
				addr, ok := a.symbols[parts[2]]
				if !ok {
					return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
				}
				bytes, err := a.convertInt16ToBytes(int16(addr))
				if err != nil {
					return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
				}

				a.bytes[address] = bytes[0]
				address += 1

				a.bytes[address] = bytes[1]
			}

			//position for next line
			address += 1
		case "MUL": //6
			a.bytes[address] = 6
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "SUB": //7
			a.bytes[address] = 7
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "TRP": //8
			a.bytes[address] = 8
			address += 1

			trpVal, err := a.convertStringToInt16(parts[1][1:])
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			bytes, berr := a.convertInt16ToBytes(trpVal)
			if berr != nil {
				return fmt.Errorf("%s line number %d", berr.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]
			address += 1

			//padding at end to be 4 bytes
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "CMP": //9
			a.bytes[address] = 9
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "BNZ": //10
			a.bytes[address] = 10
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "BRZ": //11
			a.bytes[address] = 11
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "MOV": //12
			a.bytes[address] = 12
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			reg2, err2 := a.getRegister(parts[2])
			if err2 != nil {
				return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
			}
			a.bytes[address] = reg2

			//padding at end to be 4 bytes
			address += 1
			a.bytes[address] = 0

			//position for next line
			address += 1
		case "JMP": //13
			a.bytes[address] = 13
			address += 1

			//get label address
			addr, ok := a.symbols[parts[1]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[1], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]
			address += 1 // padding

			//position for next line
			address += 1
		case "LDA": //14
			a.bytes[address] = 14
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "STB": //15 or 150 for indirect
			if parts[2][0] == '(' {
				a.bytes[address] = 150
			} else {
				a.bytes[address] = 15
			}
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			if parts[2][0] == '(' {
				reg2, err2 := a.getRegister(parts[2][1 : len(parts[2])-1])
				if err2 != nil {
					return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
				}
				a.bytes[address] = reg2
				address += 1
			} else {
				//get label address
				addr, ok := a.symbols[parts[2]]
				if !ok {
					return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
				}
				bytes, err := a.convertInt16ToBytes(int16(addr))
				if err != nil {
					return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
				}
				
				a.bytes[address] = bytes[0]
				address += 1
				
				a.bytes[address] = bytes[1]
			}
			//position for next line
			address += 1
		case "BGT": //16
			a.bytes[address] = 16
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "BLT": //17
			a.bytes[address] = 17
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "STR": //18 or 118 for indirect
			if parts[2][0] == '(' {
				a.bytes[address] = 118
			} else {
				a.bytes[address] = 18
			}
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1
			if parts[2][0] == '(' {
				reg2, err2 := a.getRegister(parts[2][1 : len(parts[2])-1])
				if err2 != nil {
					return fmt.Errorf("%s line number %d", err2.Error(), linenum+1)
				}
				a.bytes[address] = reg2
				address += 1
			} else {
				//get label address
				addr, ok := a.symbols[parts[2]]
				if !ok {
					return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
				}
				bytes, err := a.convertInt16ToBytes(int16(addr))
				if err != nil {
					return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
				}

				a.bytes[address] = bytes[0]
				address += 1

				a.bytes[address] = bytes[1]
			}

			//position for next line
			address += 1
		case "JMR": //19
			a.bytes[address] = 19
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1
			address += 2

			//position for next line
			address += 1
		case "RUN": //20
			a.bytes[address] = 20
			address += 1

			reg1, err1 := a.getRegister(parts[1])
			if err1 != nil {
				return fmt.Errorf("%s line number %d", err1.Error(), linenum+1)
			}
			a.bytes[address] = reg1

			address += 1

			//get label address
			addr, ok := a.symbols[parts[2]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]

			//position for next line
			address += 1
		case "LCK": //21
			a.bytes[address] = 21
			address += 1

			//get label address
			addr, ok := a.symbols[parts[1]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]
			address += 1

			//position for next line
			address += 1
		case "ULK": //22
			a.bytes[address] = 22
			address += 1

			//get label address
			addr, ok := a.symbols[parts[1]]
			if !ok {
				return fmt.Errorf("Could not find symbol %s on line %d", parts[2], linenum+1)
			}
			bytes, err := a.convertInt16ToBytes(int16(addr))
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}

			a.bytes[address] = bytes[0]
			address += 1

			a.bytes[address] = bytes[1]
			address += 1

			//position for next line
			address += 1
		case "BLK": //23
			a.bytes[address] = 23
			address += 4
		case "END": //24
			a.bytes[address] = 24
			address += 4

		case ".BYT":
			v := parts[1]
			//fmt.Println(v)
			if v[0] == '\'' {
				b, berr := strconv.Unquote(v)
				//fmt.Printf("%s, %+v, %d, %08b\n",b,serr,int8(b[0]),byte(b[0]))
				if berr != nil {
					return fmt.Errorf("%s line number %d", berr.Error(), linenum+1)
				}
				a.bytes[address] = byte(b[0])
			} else {
				b, berr := a.convertStringToInt8(v)
				if berr != nil {
					return fmt.Errorf("%s line number %d", berr.Error(), linenum+1)
				}
				//fmt.Printf("%08b",byte(b))
				a.bytes[address] = byte(b)
			}

			//position for next line
			address += 1
		case ".INT":
			i, err := a.convertStringToInt32(parts[1])
			if err != nil {
				return fmt.Errorf("%s line number %d", err.Error(), linenum+1)
			}
			b, berr := a.convertInt32ToBytes(i)
			if berr != nil {
				return fmt.Errorf("%s line number %d", berr.Error(), linenum+1)
			}
			a.bytes[address] = b[0]
			address += 1
			a.bytes[address] = b[1]
			address += 1
			a.bytes[address] = b[2]
			address += 1
			a.bytes[address] = b[3]

			//position for the next line
			address += 1
		default:
			return fmt.Errorf("Unknown instruction %s at %d", parts[0], linenum+1)
		}

		//fmt.Printf("%+v\n",parts)
	}
	return nil
}

func (a *Assembler) GetSymbols() map[string]int {
	return a.symbols
}

func (a *Assembler) GetBytes() []byte {
	return a.bytes
}

//Private used functions
func (a *Assembler) getRegister(s string) (byte, error) {
	reg := []rune(s)
	switch string(reg[1:]) {
	case "PC":
		return 20, nil
	case "SB":
		return 21, nil
	case "FP":
		return 22, nil
	case "SP":
		return 23, nil
	case "SL":
		return 24, nil
	default:
		r, err := strconv.ParseInt(string(reg[1:]), 10, 32)
		if err != nil {
			return 0, err
		}
		if r > 20 {
			return 0, fmt.Errorf("Invalid Register %d", r)
		}
		return byte(r), nil
	}
}

func (a *Assembler) getImmediate(s string) ([2]byte, error) {
	var b [2]byte
	imm := []rune(s)
	i, err := strconv.ParseInt(string(imm[1:]), 10, 32)
	if i > 16384 || i < -16385 {
		return b, fmt.Errorf("Immediate value %d out of range", i)
	}
	if err != nil {
		return b, err
	}
	return a.convertInt16ToBytes(int16(i))
}

func (a *Assembler) convertStringToInt8(s string) (int8, error) {
	i, err := strconv.ParseInt(s, 10, 8)
	return int8(i), err
}

func (a *Assembler) convertStringToInt16(s string) (int16, error) {
	i, err := strconv.ParseInt(s, 10, 16)
	return int16(i), err
}

func (a *Assembler) convertStringToInt32(s string) (int32, error) {
	i, err := strconv.ParseInt(s, 10, 32)
	return int32(i), err
}

func (a *Assembler) convertInt16ToBytes(i int16) ([2]byte, error) {
	var b [2]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b, fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_, err = buf.Read(b[:])
	return b, err
}

func (a *Assembler) convertInt32ToBytes(i int32) ([4]byte, error) {
	var b [4]byte
	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.LittleEndian, i)
	if err != nil {
		return b, fmt.Errorf("Conversion to byte failed %s.", err)
	}
	_, err = buf.Read(b[:])
	return b, err
}
