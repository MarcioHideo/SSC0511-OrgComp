; GRUPO:
; Adrian Pereira da Silva 11816171
; João Vitor Diógenes 11816122
; Julio Igor Casemiro Oliveira 11816139
; Marcio Hideo Ishikawa 11832902

; string que fica na tela inicial
cyber: string "cyber"
punk: string "punk"
L1077: string "1077"

loadn r1, #'O' ;obstaculo
loadn r2, #'X' ;personagem

pontuacao: var #1
loadn r0, #0
store pontuacao, r0

score: string "score:"

posPersonagem: var #1
posAnterior: var #1
loadn r0, #1180
store posPersonagem, r0

posObstaculo: var #1
loadn r0, #20
store posObstaculo, r0

posObstaculo_2: var #1
loadn r0, #56
store posObstaculo_2, r0

posObstaculo_3: var #1
; posicao do obstaculo 3 = sempre em cima do personagem
; mas comecando na linha 1 ao invés da 0, para que ande 
; de 80 em 80 e colida com o personagem
push r1
load r0, posPersonagem
loadn r1, #40
mod r0, r0, r1
store posObstaculo_3, r0
pop r1

morte: string "Game over"
continuar: string "Press space to continue"

main:
	;imprimindo a tela principal do jogo	
	push r0
	push r1;
	push r2;
	loadn r0, #572		;posicao que vai aparecer na tela
	loadn r1, #cyber	;string que vai aparecer
	loadn r2, #256		;cor da string
	call ImprimeStr		;imprimindo "game over"
	loadn r0, #577		;posicao que vai aparecer na tela
	loadn r1, #punk		;string que vai aparecer
	loadn r2, #0		;cor da string
	call ImprimeStr		;imprimindo "game over"
	loadn r0, #582		;posicao que vai aparecer na tela
	loadn r1, #L1077	;string que vai aparecer
	loadn r2, #2816		;cor da string
	call ImprimeStr		;imprimindo "game over"
	loadn r0, #1168			;posicao que vai aparecer na tela
	loadn r1, #continuar	;string que vai aparecer
	loadn r2, #0			;cor da string
	call ImprimeStr
	pop r2
	
	menu:
		;pressionar 'espaco' para iniciar o jogo 
		inchar r0
		loadn r1, #' '
		cmp r0, r1
		jne menu
	pop r1	
	pop r0
	
	push r1;
	push r2;
	call ApagaTela
	loadn R1, #tela1Linha0		; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #1536  			; cor verde!
	call ImprimeTela2   		; Rotina de Impresao de Cenario na Tela Inteira
	
	
	loadn r0, #40		;posicao que vai aparecer na tela
	loadn r1, #score	;string que vai aparecer
	loadn r2, #0		;cor da string
	call ImprimeStr		;imprimindo "score"
	;para que o personagem nasca na posicao inicial (1180) apos a sua morte
	loadn r1, #1180
	store posPersonagem, r1
	dec r1
	store posAnterior, r1
	pop r2
	pop r1
	
	loop:
		call DesenhaPersonagem
		call MovePersonagem
		call ApagaPersonagem
		call obstaculo	 ; chamando a posicao do obstaculo
		call obstaculo_2 ; chamando a posicao do obstaculo 2 
		call obstaculo_3 ; chamando a posicao do obstaculo 3 
		call deleyObstaculo
		jmp loop	
	
DesenhaPersonagem:
	load r0, posPersonagem
	outchar r2, r0
	rts
	
ApagaPersonagem:
	load r0, posAnterior
	loadn r3, #' '
	outchar r3, r0
	
MovePersonagem:
	push r0
	push r1
	push r2
	inchar r1
	
	load r0, posPersonagem
	
	; se precionar 'a' chama o label funcao recalculaPosPersonagem_A
	loadn r2, #'a'
	cmp r1, r2
	jeq recalculaPosPersonagem_A
	
	; se precionar 'd' chama o label recalculaPosPersonagem_D
	loadn r2, #'d'
	cmp r1, r2
	jeq recalculaPosPersonagem_D
	
	MovePersonagemFim:
		store posPersonagem, r0
		pop r2
		pop r1
		pop r0
		rts
	
;move o personagem para a esquerda	
recalculaPosPersonagem_A:
	loadn r1, #1169
	load r2, posPersonagem 
	cmp r1, r2
	jeq MovePersonagemFim
	store posAnterior, r0
	dec r0	; pos = pos -1
	jmp MovePersonagemFim
	
;move o personagem para a direita
recalculaPosPersonagem_D:
	loadn r1, #1190
	load r2, posPersonagem 
	cmp r1, r2
	cmp r1, r2
	jeq MovePersonagemFim
	store posAnterior, r0
	inc r0	; pos = pos -1
	jmp MovePersonagemFim

;---------------------------------------------

;
obstaculo:
	call apagaTiro
	call recalculaTiro
	call mudaCor
	call desenhaTiro
	rts 

apagaTiro:
	push r2  
	loadn r2, #' '
	load r0, posObstaculo
	outchar r2, r0 ; r0 = posicao da nave
	pop r2
	rts

recalculaTiro:
	push r2
	push r3
	push r4
	loadn r3, #40
	load r0, posObstaculo
	add r0, r0, r3
	;testa se atingiu o pensonagem
	load r4, posPersonagem
	cmp r0, r4
	jeq gameOver
	;testa se ja cheou no fim da tela
	loadn r2, #1160
	cmp r0, r2
	jle recNave_fim ;faz o jump se for menor (testa se chegou no fim da tela)
	call soma_ponto
	load r2, posPersonagem
	; calculando nova posicao do obstaculo com operacoes matematicas "aleatorias" (sim, totalmente sem logica,
	; fica tranquilo(a) se nao entender) com a posPersonagem (forma de ficar "aleatorio" mas sempre caindo perto do
	; personagem e dentro do cenario jogavel)
	add r0, r4, r2
	and r0, r4, r0
	loadn r3, #22
	mod r0, r0, r3 ;faz mod com posObstaculo e 22 para que a distacia da variacao do eixo x dos objetos caindo fique 
				   ;igual a variacao da distancia do cenario jogavel
	loadn r3, #9 ;soma 9 para deslocar esse eixo x para dentro do cenario jogavel
	add r0, r0, r3
	recNave_fim:
	store posObstaculo, r0
	pop r4
	pop r3
	pop r2
	rts

mudaCor:
	push r2
	push r3
	loadn r2, #256
	loadn r3, #3840
	add r1, r1, r2
	cmp r1, r3
	jle fim
	loadn r1, #'O'
	fim:
	pop r3
	pop r2
	rts

desenhaTiro:
	load r0, posObstaculo
	outchar r1, r0
	rts
	
;===========================================
;			OBSTACULO_2
;===========================================

obstaculo_2:
	call apagaTiro_2
	call recalculaTiro_2
	;call mudaCor_2 ;nao precida pq esta usando a mesma letra (r1) do obstaculo_2
	call desenhaTiro_2
	;call deley
	rts 

apagaTiro_2:
	push r2  
	loadn r2, #' '
	load r0, posObstaculo_2
	outchar r2, r0 ; r0 = posicao da nave
	pop r2
	rts

recalculaTiro_2:
	push r2
	push r3
	push r4
	push r5
	loadn r3, #80
	load r0, posObstaculo_2
	add r0, r0, r3
	;verificando se colidiu com o personagem
	load r4, posPersonagem
	loadn r5, #40 ;corrigir a colisao do obstaculo (como ele pula de 80 no eixo y, entao ele nao iria colidir com  o personagem)
	add r4, r4, r5
	cmp r0, r4
	jeq gameOver
	sub r4, r4, r5
	;testa se ja cheou no fim da tela
	loadn r2, #1160
	cmp r0, r2
	jle recNave_fim_2 ;faz o jump se for menor
	load r2, posPersonagem
	; calculando nova posicao do obstaculo com operacoes matematicas "aleatorias" (sim, totalmente sem logica,
	; fica tranquilo(a) se nao entender) com a posPersonagem (forma de ficar "aleatorio" mas sempre caindo perto do
	; personagem e dentro do cenario jogavel)
	sub r0, r4, r2
	xor r0, r4, r0
	loadn r3, #22
	mod r0, r0, r3	;faz mod com posObstaculo_2 e 22 para que a distacia da variacao do eixo x dos objetos caindo fique 
				   	;igual a variacao da distancia do cenario jogavel
	loadn r3, #9   	;soma 9 para deslocar esse eixo x para dentro do cenario jogavel
	add r0, r0, r3
	recNave_fim_2:
	store posObstaculo_2, r0
	pop r5
	pop r4
	pop r3
	pop r2
	rts

desenhaTiro_2:
	load r0, posObstaculo_2
	outchar r1, r0
	rts
	
;===========================================
;			OBSTACULO_3
;===========================================

obstaculo_3:
	call apagaTiro_3
	call recalculaTiro_3
	call desenhaTiro_3
	rts 

apagaTiro_3:
	push r2  
	loadn r2, #' '
	load r0, posObstaculo_3
	outchar r2, r0 ; r0 = posicao da nave
	pop r2
	rts

recalculaTiro_3:
	push r2
	push r3
	push r4
	loadn r3, #40
	load r0, posObstaculo_3
	add r0, r0, r3
	;verificando se colidiu com o personagem
	load r4, posPersonagem
	cmp r0, r4
	jeq gameOver
	;testa se ja cheou no fim da tela
	loadn r2, #1160
	cmp r0, r2
	jle recNave_fim_3 ;faz o jump se for menor
	; posicao do obstaculo 3 = sempre a posicao do personagem
	loadn r3, #40
	mod r0, r4, r3
	recNave_fim_3:
	store posObstaculo_3, r0
	pop r4
	pop r3
	pop r2
	rts

desenhaTiro_3:
	load r0, posObstaculo_3
	outchar r1, r0
	rts
	

;-----------------------------------------------------------
;adiciona um ponto no placar	
soma_ponto:
	push r0
	push r5
	push r6
	load r5, pontuacao
	inc r5
	store pontuacao, r5 ;registrador que contem o numeros de pontos
	loadn r6, #46 		;posicao que vai ser atualizado os pontos
	call PrintaNumero	;imprimindo os pontos na tela
	pop r6
	pop r5
	pop r0
	rts
	
;========================================================
;                    PrintaNumero
;========================================================
PrintaNumero:	; R5 contem um numero de ate 2 digitos e R6 a posicao onde vai imprimir na tela

	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #10
	loadn r2, #48
	
	div r1, r5, r0	; Divide o numero por 10 para imprimir a dezena
	
	add r3, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r3, r6
	
	inc r6			; Incrementa a posicao na tela
	
	mul r1, r1, r0	; Multiplica a dezena por 10
	sub r1, r5, r1	; Pra subtrair do numero e pegar o resto
	
	add r1, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r1, r6
	
	pop r3
	pop r2
	pop r1
	pop r0

	rts
	
;=======================================
deleyObstaculo:
	push r0
	push r1
	
	loadn r1, #5
	deley_volta2:
	loadn r0, #30000
	deley_volta:
	dec r0
	jnz deley_volta
	dec r1
	jnz deley_volta2
	
	pop r1
	pop r0
	
	rts
	
;=========================================

gameOver:
	push r1
	push r2
	inc r0 ;posicao do objeto que atingiu o personagem, eh incrementado para sair de cima do personagem e poder continuar o jogo
	store posObstaculo, r0
	store posObstaculo_2, r0
	store posObstaculo_3, r0	
	call ApagaTela
	;zerando a pontuacao
	loadn r1, #0
	store pontuacao, r1
	
	loadn r0, #575		;posicao que vai aparecer na tela
	loadn r1, #morte	;string que vai aparecer
	loadn r2, #256		;cor da string
	call ImprimeStr		;imprimindo "game over"
	loadn r0, #1168			;posicao que vai aparecer na tela
	loadn r1, #continuar	;string que vai aparecer
	loadn r2, #0			;cor da string
	call ImprimeStr
	;fica em loop ate que pressione "espaco"
	loopGameOver:
		inchar r0
		loadn r1, #' '
		cmp r0, r1
		jeq voltaMain
		jmp loopGameOver
	
	voltaMain:
		pop r2
		pop r1
		call ApagaTela
		jmp main
		
;==========================================
;			IMPRIME STRING 
;==========================================
		
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts	
;========================================================
;                       IMPRIME TELA2
;========================================================	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;===============================================================================
;                   IMPRIME STRING2 (usada para imprimir a tela)
;===============================================================================
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;========================================================
;                       APAGA TELA (INTEIRA)
;========================================================
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	
	
;------------------------	
; Declara uma tela vazia para ser preenchida em tempo de execussao:

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string "                                        "
tela1Linha1  : string "oooooooo|                      |oooooooo"
tela1Linha2  : string "oooooooo|                      |oooooooo"
tela1Linha3  : string "oooooooo|                      |oooooooo"
tela1Linha4  : string "oooooooo|                      |oooooooo"
tela1Linha5  : string "oooooooo|                      |oooooooo"
tela1Linha6  : string "oooooooo|                      |oooooooo"
tela1Linha7  : string "oooooooo|                      |oooooooo"
tela1Linha8  : string "oooooooo|                      |oooooooo"
tela1Linha9  : string "oooooooo|                      |oooooooo"
tela1Linha10 : string "oooooooo|                      |oooooooo"
tela1Linha11 : string "oooooooo|                      |oooooooo"
tela1Linha12 : string "oooooooo|                      |oooooooo"
tela1Linha13 : string "oooooooo|                      |oooooooo"
tela1Linha14 : string "oooooooo|                      |oooooooo"
tela1Linha15 : string "oooooooo|                      |oooooooo"
tela1Linha16 : string "oooooooo|                      |oooooooo"
tela1Linha17 : string "oooooooo|                      |oooooooo"
tela1Linha18 : string "oooooooo|                      |oooooooo"
tela1Linha19 : string "oooooooo|                      |oooooooo"
tela1Linha20 : string "oooooooo|                      |oooooooo"
tela1Linha21 : string "oooooooo|                      |oooooooo"
tela1Linha22 : string "oooooooo|                      |oooooooo"
tela1Linha23 : string "oooooooo|                      |oooooooo"
tela1Linha24 : string "oooooooo|                      |oooooooo"
tela1Linha25 : string "oooooooo|                      |oooooooo"
tela1Linha26 : string "oooooooo|                      |oooooooo"
tela1Linha27 : string "oooooooo|                      |oooooooo"
tela1Linha28 : string "oooooooo|                      |oooooooo"
tela1Linha29 : string "oooooooo|                      |oooooooo"