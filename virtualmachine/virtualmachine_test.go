package virtualmachine

import (
	"testing"
	asm "../assembler"
)

var a *asm.Assembler
var by []byte
var v *VirtualMachine

func setup() {
	by = make([]byte,5*1000*1000)

	a = asm.NewAssembler()
	err := a.ReadFile("../proj1.asm")
	if err != nil {
		println(err.Error())
	}

	a.FirstPass()
	a.SecondPass()

	by = a.GetBytes()

	v = NewVirtualMachine(by)
}

//func TestParseADI(t *testing.T) {
//	setup()
//}





func BenchmarkParseADD(b *testing.B) {
	setup()
	b.ResetTimer()
	for i:=0; i < b.N; i++ {
		v.Run()
	}
}
