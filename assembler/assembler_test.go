package assembler

import (
	"testing"
)

var a *Assembler

func setup(){
	a = NewAssembler()
}

func proj1_setup() {
	a = NewAssembler()

	err := a.ReadFile("../proj1.asm")
	if err != nil {
		println(err.Error())
	}
}

func ErrWhenShouldNot(err error, t *testing.T) {
	if err != nil {
		t.Errorf("Assembler reported error %s, when no error should have been reported",err)
	}
}

func TestParseADD(t *testing.T) {
	setup()
	line := "LBL: ADD R0 R1 ;comment"
	a.file = append(a.file, line)
	err := a.FirstPass()
	ErrWhenShouldNot(err,t)
	if v,ok := a.symbols["LBL:"]; v != 0 || !ok {
		t.Errorf("Didn't find LBL symbol address correctly")
	}
	err = a.SecondPass()
	ErrWhenShouldNot(err,t)
	if a.bytes[0] != 1 {
		t.Errorf("Incorrect opt code for ADD got %d, should be 1",a.bytes[0])
	}
	if a.bytes[1] != 0 {
		t.Errorf("1st reg opperand incorrectly interpreted got %d, should be 0",a.bytes[1])
	}
	if a.bytes[2] != 1 {
		t.Errorf("2nd reg opperand incorrectly interpreted got %d, should be 1",a.bytes[2])
	}
}

func TestParseADI(t *testing.T) {
	setup()
	line := "LBL: ADI R0 #4 ;comment"
	a.file = append(a.file,line)
	err := a.FirstPass()
	ErrWhenShouldNot(err,t)
	if v,ok := a.symbols["LBL:"]; v != 0 || !ok {
		t.Errorf("Didn't find LBL symbol address correctly")
	}
}





func BenchmarkParseADD(b *testing.B) {
	setup()
	line := "LBL: ADD R0 R1 ;comment"
	a.file = append(a.file, line)
	b.ResetTimer()
	for i:=0; i < b.N; i++ {
		a.FirstPass()
	}
}

func BenchmarkAssembProj1(b *testing.B) {
	proj1_setup()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		err := a.FirstPass()
		if err == nil {
			a.SecondPass()
		} else {
			b.Errorf("%s",err)
		}
	}
}
