
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt



org 100h

; Sistema de Inventario (5 productos max)

product_count db 0  


codigos db 5 dup(?) 
cantidades db 5 dup (?)
precios db 5 dup(?)


;Menu

menu_msg db 13,10,"MENU INVENTARIO",13,10,"1. Agregar producto",13,10,"2. Aumentar existencias",13,10,"3. Reducir existencias",13,10,"4. Mostrar inventario",13,10,"5. Salir",13,10,"Opcion: $"


    
ask_code db 13,10, "Codigo del producto (1 digito): $"
ask_qty db 13,10, "Cantidad (2 digitos): $"
ask_price db 13,10, "Precio (2 digitos): $"
added_msg db 13,10, "Producto agregado $"
full_msg db 13,10, "Inventario lleno $"
not_found db 13,10, "Producto no encontrado $"
increase_msg db 13,10, "Existencia aumentada $"
decrease_msg db 13,10, "Existencia reducida $"
no_stock db 13,10, "No hay suficiente stock $"

inv_header db 13,10, "INVENTARIO" ,13,10,"$"

newline db 13,10,"$"
  
  
  
;Inicio


inicio:

menu:
    mov ah,09h
    mov dx, offset menu_msg
    int 21h
    
    mov ah,01h
    int 21h
    sub al, '0'
            
            
            
    cmp al, 1
    je agregar
    cmp al,2
    je aumentar
    cmp al, 3
    je reducir
    cmp al,4
    je mostrar
    cmp al,5
    je salir
    
    jmp menu
    
    
agregar:
    mov al, product_count
    cmp al,5
    je inventario_lleno
    
    mov ah,09h
    mov dx, offset ask_code
    int 21h
    
    mov ah, 01h
    int 21h
    mov bl, al
    mov al, product_count 
    mov ah,0
    mov si,ax
    mov codigos[si], bl 
    
    ;leer cantidad
    mov ah,09h
    mov dx, offset ask_qty
    int 21h
    
    call leer_numero2
    mov cantidades[si], al  
    
    ;leer precio
    mov ah,09h
    mov dx, offset ask_price
    int 21h
    
    call leer_numero2
    mov precios[si], al
    
    inc product_count
    
    
    mov ah, 09h
    mov dx offset added_msg
    int 21h
    
    jmp menu
    

inventario_lleno:
    mov ah, 09h
    mov dx, offset full_msg
    int 21h
    jmp menu
    
             
             
             
             
;aumentar existencias 

aumentar:
        mov ah, 09h
        mov dx, offset ask_code
        int 21h
        
        mov ah, 01h
        int 21h
        mov bl, al
        
        call buscar_producto  
        cmp si, -1
        je no_hay
        
        mov ah, 09h
        mov dx offset ask_qty
        int 21h
        
        call leer_numero2
        add cantidades[si], al
        
        mov ah, 09h
        mov dx, offset increase_msg
        int 21h
        jmp menu
        
        
;reducir existencias

reducir:
    mov ah, 09h
    mov dx, offset ask_code
    int 21h
    
    mov ah, 01h
    int 21h
    mov bl, al
    
    call buscar_producto
    cmp si, -1
    je no_hay
    
    mov ah,09h
    mov dx, offset ask_qty
    int 21h
    
    call leer_numero2
       
       
    cmp cantidades[si],al
    jb stock_insuficiente
    
    
    sub cantidades[si], al
    
    
    mov ah, 09h
    mov dx, offset decrease_msg
    int 21h
    jmp menu
    
    
;mostrar inventario

mostrar:
    mov ah,09h
    mov dx, offset inv_header
    int 21h
    
    mov cx,0

mostrar loop:
    mov al, productos_count
    cmo cx, ax
    jae menu  
    
    mov dl,codigos[cx]
    mov ah,02h
    int 21h
    
    mov dl,' '  
    mov ah,02h
    int 21h
    
    ;imprimir cantidad
    mov al, cantidades[cx]
    call imprimir_dos_digitos
    
    mov dl,' '
    mov ah, 02h
    int 21h
    
    ;imprimir precio
    mov al, precios[cx]
    call imprimir_dos_digitos
    
    mov ah,09h
    mov dx,offset newline
    int 21h
    
    
    int cx
    jmp mostrar_loop
    
    
    
;SUBRUTINAS

;Buscar producto por codigo

buscar producto:
    mov si, 0

buscar lp:
    mov al, productos_count
    cmp si, ax
    jae no_hay_label
    
    cmp codigos[si], bl
    je encontrado
    
    inc si
    jmp busar_lp
    
no_hay_label:
    mov si, -1
    ret   
    
encontrado:
    ret
    
    
    
    
    
;Leer numero de dos digitos ASCII --> AL

leer_numero2:
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    mov ah,01h
    int 21h
    sub al,'0'
    
    mov bh,al
    mov al,bl
    mov bl,10
    mul bl
    add al,bh
    ret
    
    
;Imprimir numero

imprimir_dos_digitos:
    mov bl,10
    div bl
    
    add, al'0'
    mov dl,al
    mov ah,02h
    int 21h 
    
    mov al, ah
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h
    ret


;Salir

no_hay:
    mov ah, 09h
    mov dx, offset not_found
    int 21h
    jmp menu   
    
salir:
    mov ax, 4c00h
    int 21h




