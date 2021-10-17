section .data
    atoi_backup_eax  DD 0
    creaza_nod_backup_eax  DD 0
    create_tree_backup_eax  DD 0

section .bss
    root resd 1

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree

extern malloc
extern strlen
extern strdup

global create_tree
global iocla_atoi
global creaza_nod

creaza_nod:
    push ebp
    mov ebp, esp
    pusha

    mov ecx, 12
    push ecx
    call malloc
    pop ecx
    mov ebx, eax ; ebx contine *nod

    push dword [ebp + 8]
    call strdup  ; eax contine *char
    add esp, 4

    xchg eax, ebx ; se schimba intre ele

    mov [eax], ebx
    mov [eax + 4], dword 0
    mov [eax + 8], dword 0
    ;PRINTF32 `%s\n\0`, [eax]

    mov [creaza_nod_backup_eax], eax
    popa
    mov eax, [creaza_nod_backup_eax]
    leave
    ret

iocla_atoi:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; string_nr

    xor eax, eax ; number
    xor ebx, ebx ; curr
    xor ecx, ecx ; putere 10
    xor esi, esi ; contor
    xor edi, edi ; flag negativ

    push edx
    call strlen
    pop edx
    mov ecx, eax
    dec ecx
    xor eax, eax

    atoi_loop1:
        cmp [edx + esi], byte '-'
            je atoi_e_negativ
        continuare_atoi_loop1:
        movzx ebx, byte [edx + esi]
        sub ebx, 48
        cmp ecx, byte 0
            je atoi_o_cifra_ramasa

        push ecx
        atoi_loop2:
            cmp ecx, byte 0
                je sfarsit_atoi_loop2
            imul ebx, 10
        dec ecx
        jmp atoi_loop2

        sfarsit_atoi_loop2:
        add eax, ebx
        pop ecx
        dec ecx
        inc esi
    jmp atoi_loop1

    atoi_e_negativ:
    mov edi, 1
    dec ecx
    inc esi
    jmp continuare_atoi_loop1

    atoi_o_cifra_ramasa:
    add eax, ebx
    cmp edi, byte 1
        je atoi_rezolvare_negativ
    jmp atoi_exit

    atoi_rezolvare_negativ:
    neg eax
    jmp atoi_exit
    
    atoi_exit:
    mov [atoi_backup_eax], eax
    popa
    mov eax, [atoi_backup_eax]
    leave
    ret

create_tree:
    push ebp
    mov ebp, esp
    pusha

    mov edx, [ebp + 8]

    xor ecx, ecx ; contor
    ; edx = argument

    push edx
    call strlen
    pop edx
    mov ecx, eax
    dec ecx
    xor eax, eax

    loop1:
        cmp [edx + ecx], byte ' '
            je e_spatiu
        cmp ecx, byte 0
            je final_sir
        cmp [edx + ecx], byte '-'
            je e_minus_din_nr
        dec ecx
    jmp loop1

    e_spatiu:
        mov [edx + ecx], byte 0 ; se separa nr curent de restul sirului
        cmp [edx + ecx + 1], byte '+'
            je e_semn
        cmp [edx + ecx + 1], byte '-'
            je e_semn
        cmp [edx + ecx + 1], byte '/'
            je e_semn
        cmp [edx + ecx + 1], byte '*'
            je e_semn
        mov ebx, edx ; se duce pointer
        add ebx, ecx ; la primul char
        inc ebx ; al sirului curent
        push ebx
        call creaza_nod
        pop ebx
        push eax
        ;push ebx
        ;call iocla_atoi
        ;add esp, 4
        ;PRINTF32 `%d\n\0`, eax
        dec ecx
        jmp loop1

    e_minus_din_nr:
        cmp [edx + ecx + 1], byte 0
            je e_semn_minus
        mov [edx + ecx - 1], byte 0 ; se separa nr curent de restul sirului
        mov ebx, edx ; se duce pointer
        add ebx, ecx ; la primul char
        push ebx
        call creaza_nod
        pop ebx
        push eax
        ;push ebx
        ;call iocla_atoi
        ;add esp, 4
        ;PRINTF32 `%d\n\0`, eax
        dec ecx
        jmp loop1

    final_sir:
        cmp [edx], byte '+'
            je e_ultimul_semn
        cmp [edx], byte '-'
            je e_ultimul_semn_minus
        cmp [edx], byte '/'
            je e_ultimul_semn
        cmp [edx], byte '*'    
            je e_ultimul_semn    
        final_sir_sigur:
        push ebx
        call creaza_nod
        pop ebx
        push eax
        ;push edx
        ;call iocla_atoi
        ;add esp, 4
        ;PRINTF32 `%d\n\0`, eax
        jmp exit

    e_semn_minus:
    mov ebx, edx
    add ebx, ecx
    push ebx
    call creaza_nod
    pop ebx

    pop esi
    pop edi
    mov [eax + 4], esi
    mov [eax + 8], edi
    push eax
    ;PRINTF32 `%s\n\0`, ebx
    mov [edx + ecx - 1], byte 0
    sub ecx, 2
    jmp loop1
        
    e_semn:
        mov ebx, edx
        add ebx, ecx
        inc ebx
        push ebx
        call creaza_nod
        pop ebx
        
        pop esi
        pop edi
        mov [eax + 4], esi
        mov [eax + 8], edi
        push eax

        ;PRINTF32 `%s\n\0`, ebx
        dec ecx
        jmp loop1

    e_ultimul_semn_minus:
        cmp [edx + 1], byte 0
            je e_ultimul_semn
        jmp final_sir_sigur

    e_ultimul_semn:
        push edx
        call creaza_nod
        pop edx

        pop esi
        pop edi
        mov [eax + 4], esi
        mov [eax + 8], edi
    
    exit:

    mov [create_tree_backup_eax], eax
    popa
    mov eax, [create_tree_backup_eax]
    leave
    ret
