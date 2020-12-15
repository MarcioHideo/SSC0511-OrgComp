; Teste do And
	loadn r1, #0
	loadn r2, #0
	nand r3, r1, r2
    loadn r4, #'A'
    add r3, r4, r3
	loadn r0, #20
	outchar r3, r0		; Printa C na linha 20
    jmp Fim


Fim:	
	halt