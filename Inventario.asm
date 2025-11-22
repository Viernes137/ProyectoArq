;#################################
;Inicio del programa 
;#################################

org 100h        ;Este sirve para decir donde iniciar el programa

;#################################
;Funcion Start equivalente al main
;#################################
;En este caso lo voy a usar como menu por que es la app base en si 
start:
    ; *** PASO CRUCIAL: Configurar DS para acceder a las variables de datos ***
    ; En ORG 100h, DS debe apuntar a CS (Segmento de Codigo)
    mov ax, cs  
    mov ds, ax

    ; ===== LIMPIAR PANTALLA =====
    ;call clear_screen

    ;#######estas 3 instrucciones sirven para imprimir el menu
    mov ah, 09h 


    int 21h         ;========OJO CON ESTO INT21H ES IMPORTANTE LE DICE A TODAS LAS INTRUCCIONES QUE PUSISTE ARRIBA EJECUTA========

    mov ah, 09h 
    mov dx, offset menu_options_msg
    int 21h

    ;#######Aca estan las intrucciones para leer la opcion del user
    mov ah, 01h
    int 21h

    ;#######Aca hago una especie de SWITCH
    ; Leer opción del usuario
    ; SWITCH: Comparar opción
    cmp al, '1'
    je agregar_producto        ; Tecla '1' ? agregar
    
    cmp al, '2'
    je aumentar_existencia     ; Tecla '2' ? aumentar
    
    cmp al, '3'
    je reducir_existencia      ; Tecla '3' ? reducir
    
    cmp al, '4'
    je mostrar_inventario      ; Tecla '4' ? mostrar
    
    cmp al, '5'
    je exit_program            ; Tecla '5' ? salir

    ;######Opcion invalida
    mov ah, 09h
    mov dx, offset menu_options_msg
    int 21h

    ;#####IMPORTANTE PARA COMPLETAR CICLO WHILE####
    jmp start


;Trabajo en equipo funciona desde aca
;¦¦¦¦¦¦¦+¦¦+¦¦¦¦¦+¦¦¦+¦¦¦¦+¦¦¦¦¦¦+¦¦¦+¦¦¦¦¦¦+¦¦¦¦+¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+
;¦¦+----+¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦+--¦¦+¦¦¦¦¦+--¦¦+¦¦¦¦+¦¦¦¦¦¦+----+¦¦+----+
;¦¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦+¦¦¦¦¦¦¦¦+-+¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦+¦¦¦¦¦¦¦¦+¦¦+¦¦¦¦¦+¦
;¦¦+--+¦¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+--+¦¦¦+---¦¦+
;¦¦¦¦¦¦¦¦+¦¦¦¦¦¦++¦¦¦¦+¦¦¦¦+¦¦¦¦¦++¦¦¦+¦¦¦¦¦++¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦++
;+-+¦¦¦¦¦¦+-----+¦+-+¦¦+--+¦+----+¦+-+¦+----+¦+-+¦¦+--++------++-----+¦

;#################################
;funcion de salir del programa equivalente a return 0
;#################################
exit_program:
    call clear_screen
    
    mov ah, 09h
    mov dx, offset goodbye_msg
    int 21h
    
    mov ah, 4Ch           ; Función 4Ch = terminar programa
    int 21h               ; Llamar a DOS para salir

;#################################
;funcion agregar_producto
;#################################
agregar_producto:
    call clear_screen
    mov ah, 09h
    mov dx,offset agregar_msg
    int 21h
    jmp start

;#################################
;funcion aumentar_existencia
;#################################
aumentar_existencia:
    call clear_screen

    ;======================================
    ; Pedir nombre del producto
    ;======================================
    mov ah, 09h
    mov dx, offset msg_nombre
    int 21h

    mov ah, 0Ah
    mov dx, offset buffer_nombre
    int 21h

    ;======================================
    ; Pedir cantidad
    ;======================================
    mov ah, 09h
    mov dx, offset msg_cant
    int 21h

    mov ah, 0Ah
    mov dx, offset buffer_cantidad
    int 21h

    ;======================================
    ; Convertir cantidad ASCII ? número
    ;======================================
    mov si, offset buffer_cantidad + 2  
    mov cl, [buffer_cantidad + 1] ; longitud

    xor bx, bx   ; BX = número final

    cmp cl, 0
    je despues_conversion  ; evita loop infinito si no escribió nada

convertir_cant_loop:
    mov al, [si]
    cmp al, '0'
    jb despues_conversion
    cmp al, '9'
    ja despues_conversion

    sub al, '0'
    push ax

    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax

    pop ax
    add bx, ax

    inc si
    dec cl
    jnz convertir_cant_loop

despues_conversion:
    ; BX contiene la cantidad a sumar

    ;======================================
    ; Buscar nombre
    ;======================================
    mov cx, [num_productos]
    mov di, offset productos_nombres

buscar_producto:
    cmp cx, 0
    je no_encontrado

    push cx
    push di

    mov si, offset buffer_nombre + 2
    mov bp, NAME_LEN

comparar_loop:
    mov al, [si]
    mov dl, [di]

    cmp dl, '$'
    je nombre_fin

    cmp al, 0
    je nombre_fin

    cmp al, dl
    jne siguiente_producto

    inc si
    inc di
    dec bp
    jnz comparar_loop

nombre_fin:
    pop di
    pop cx
    jmp encontrado

siguiente_producto:
    pop di
    pop cx
    dec cx
    add di, NAME_LEN
    jmp buscar_producto

;======================================
; PRODUCTO NUEVO
;======================================
no_encontrado:

    mov ax, [num_productos]
    mov dx, NAME_LEN
    mul dx
    mov di, offset productos_nombres
    add di, ax

    mov si, offset buffer_nombre + 2
    mov cx, NAME_LEN

copiar_nombre:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copiar_nombre

    mov ax, [num_productos]
    shl ax, 1              ; ax = ax * 2 (word index)
    mov di, offset productos_cantidades
    add di, ax
    mov [di], bx           ; guardar cantidad

    mov ax, [num_productos]
    inc ax
    mov [num_productos], ax

    mov ah, 09h
    mov dx, offset msg_nuevo
    int 21h

    jmp start

;======================================
; PRODUCTO ENCONTRADO
;======================================
encontrado:
    mov ax, [di]
    add ax, bx
    mov [di], ax

    mov ah, 09h
    mov dx, offset msg_registrado
    int 21h

    jmp start









;#################################
;funcion reducir_existencia
;#################################
reducir_existencia:
    call clear_screen
    mov ah, 09h
    mov dx,offset reducir_msg
    int 21h
    jmp start

;#################################
;funcion mostrar_inventario
;#################################
mostrar_inventario:
    call clear_screen
    mov ah, 09h
    mov dx, offset mostrar_msg
    int 21h
    jmp start

;#################################
;FUNCION: limpiar_pantalla
;Limpia la pantalla y pone cursor en (0,0)
;#################################
clear_screen:
    ; Guarda el estado de los registros
    push ax
    push bx
    push cx
    push dx
    
    ; --- 1. Limpiar Pantalla (INT 10h / AH=06h) ---
    mov ah, 06h             ; Funcion: Inicializar/Desplazar ventana hacia arriba
    mov al, 00h             ; Desplazar 0 lineas (borra toda el area)
    mov ch, 00h             ; Fila de inicio: 0
    mov cl, 00h             ; Columna de inicio: 0
    
    ; *** CORRECCION 2: Usar DH y DL por separado ***
    mov dh, 24              ; Fila final (24 decimal)
    mov dl, 79              ; Columna final (79 decimal)
    
    mov bh, 07h             ; Atributo de color: Blanco sobre Negro
    int 10h                 ; Llama a la interrupcion de video de la BIOS

    ; --- 2. Mover el cursor a (0, 0) (INT 10h / AH=02h) ---
    mov ah, 02h             ; Funcion: Establecer posicion del cursor
    mov bh, 00h             ; Pagina 0
    mov dx, 0000h           ; DH=Fila 0, DL=Columna 0
    int 10h
    
    ; Restaura los registros
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;DATA
;==============================
; MENSAJES del menu
;==============================
banner_msg db 13, 10, 13, 10
         db '_____                          _____              _____       ', 13, 10
         db '___(_)_________   _______________  /______ __________(_)_____ ', 13, 10
         db '__  /__  __ \_ | / /  _ \_  __ \  __/  __ `/_  ___/_  /_  __ \', 13, 10
         db '_  / _  / / /_ |/ //  __/  / / / /_ / /_/ /_  /   _  / / /_/ /', 13, 10
         db '/_/  /_/ /_/_____/ \___//_/ /_/\__/ \__,_/ /_/    /_/  \____/ ', 13, 10
         db '################################################################', 13, 10, 13, 10, '$'

menu_options_msg db '          1. Agregar producto', 13, 10
                 db '          2. Aumentar existencia', 13, 10
                 db '          3. Reducir existencia', 13, 10
                 db '          4. Mostrar inventario', 13, 10
                 db '          5. Salir', 13, 10
                 db 13, 10, 'Elige una opcion (1-5): $' 

;==============================
; MENSAJES generales
;==============================
invalid_option_MSG db 'Opcion invalida. Intente de nuevo', 13, 10, '$'
goodbye_msg        db 13, 10, 'Gracias por usar el sistema!', 13, 10, '$'

;==============================
; MENSAJES temporales (BORRAR después)
;==============================
agregar_msg  db 'TODO: Implementar agregar_producto', 13, 10, '[Presiona tecla...]', 13, 10, '$'
aumentar_msg db 'TODO: Implementar aumentar_existencia', 13, 10, '[Presiona tecla...]', 13, 10, '$'
reducir_msg  db 'TODO: Implementar reducir_existencia', 13, 10, '[Presiona tecla...]', 13, 10, '$'
mostrar_msg  db 'TODO: Implementar mostrar_inventario', 13, 10, '[Presiona tecla...]', 13, 10, '$' 

;==============================
; INVENTARIO
;==============================
MAX_PROD        equ 10
NAME_LEN        equ 16     ; 15 chars + '$'

productos_nombres      db MAX_PROD * NAME_LEN dup('$')
productos_cantidades   dw MAX_PROD dup(0)
num_productos          dw 0

buffer_nombre    db 20,0,20 dup('$')
buffer_cantidad  db 5,0,5 dup('$')

msg_nombre       db 'Nombre del producto: $'
msg_cant         db 13,10,'Cantidad a aumentar: $'
msg_registrado   db 13,10,'Cantidad actualizada!$'
msg_nuevo        db 13,10,'Producto agregado!$'

