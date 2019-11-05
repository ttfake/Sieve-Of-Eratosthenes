[extern scanf]
[extern printf]
[SECTION .data]
    fmt     db "%u",10,0
    nmbfmt  db "%u"
    sizeOfInt      equ        4
[SECTION .bss]
    number         resb       4096
    numbers        resd       10000
    offset         equ        2
[SECTION .text]
;[SECTION .rodata]


global main

main:

            push      rbp
            mov       rbp,rsp
            push      rbx
            push      rsi
            push      rdi
;--------------------------------------------

            mov       r12,2
            xor       rax,rax                                   ; Clear rax
            lea       rdi,[rel + nmbfmt]                        ; Copy nmbfmt to rdi as format for scanf string
            lea       rsi,[rel + number]                        ; Copy number address to rsi for scanf
            call      scanf                                     ; Call scanf
            
            mov       r13,0                                     ; r13 is used as an index for the array numbers
            mov       rcx,[number]                              ; load the decrements value in the number variable into rcx 
            dec       rcx                                       ; decrement rcx to compensate for the index starting at 0 
            mov       [number],rcx                              ; copy decremented rcx to number in preparation for loadNumbers loop
            mov       r9,[number]

loadNumbers:

            mov       rcx,[number]                              ; Move number to rcx for decrement
            dec       rcx                                       ; Decrement rcx
            mov       [number],rcx

            mov       [numbers + r13 * sizeOfInt], r12          ; load the value contained in r12 into the array

            inc       r13                                       ; increment the index
            inc       r12                                       ; increment the number to load

            cmp       rcx,0                                     ; Compare rcx with 0 to determine if the loop should continue
            
            jne       loadNumbers                               ; If the above cmp isn't equal jump to the start of the loop for the next iteration
            mov       rcx,r9
            mov       [number],rcx                              ; Reset number
            mov       r13,0                                     ; Reset the index

            mov       r15,offset
            mov       r11,0
            mov       r14,0
            je        markPrimesOuterLoop                       ; Print the primes

markPrimesOuterLoop:
            mov       rcx,[number]
            cmp       r9,r15
            jne       markPrimesInnerLoop
            mov       r13,0
            je        printPrimes

markPrimesInnerLoop:
            add       r13,r15
            mov       QWORD [numbers + r13 * sizeOfInt],r11
            sub       rcx,r15
            cmp       rcx,0
            jg        markPrimesInnerLoop
            inc       r15
            inc       r14
            mov       r13,r14
            jmp       markPrimesOuterLoop

printPrimes:
            mov       rcx,[number]                              ; Setup new read loop
            dec       rcx
            mov       [number],rcx
            mov       rsi,[numbers + r13 * sizeOfInt]           ; Move number to rsi for printf
;            cmp       rsi,0
;            jnz       clean
;            cmp       rsi,0
;            je        compareIndex
             jmp       clean

compareIndex:
            cmp       rcx,0
            je        end
            jnz       printPrimes

clean:
            mov       rdi, fmt                                  ; Move fmt format for printf
            mov       rax, 0     ; no f.p. args                 ; No arguments to pass to printf
            call      printf                                    ; Call printf
            mov       rcx,[number]
            inc       r13
            cmp       rcx,0
            jne       printPrimes
            je        end
 
;--------------------------------------------
end:
            pop       rbx
            pop       rsi
            pop       rdi
            mov       rsp,rbp
            pop       rbp
            mov       rax,1       ; Code for Exit Syscall
            mov       rbx,0       ; Return a code of zero
            int       80H         ; Make kernel call

;           nop

;section .bss
