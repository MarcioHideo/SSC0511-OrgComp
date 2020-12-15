loadn r0, #7
loadn r1, #5
NAND r0, r0, r1
loadn r2, #'B'
add r0, r2, r0 
loadn r3, #10
outchar r0, r3
;r0 esta com 2

halt