;#################################
;Inicio del programa 
;#################################

org 100h        ;Este sirve para decir donde iniciar el programa

;#################################
;Variables globales
;#################################
product_count db 0                  ;para usarlo de contador

;==============================
; CONTADORES DE CADA PRODUCTO
;==============================
papas_count       db 0
coca_count        db 0
galletas_count    db 0
agua_count        db 0
cerveza_count     db 0
vodka_count       db 0
tequila_count     db 0
jagger_count      db 0

;==============================
; PRECIOS FIJOS DE CADA PRODUCTO
;==============================
papas_price       db 15
coca_price        db 25
galletas_price    db 20
agua_price        db 10
cerveza_price     db 35
vodka_price       db 150
tequila_price     db 120
jagger_price      db 200

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
    call clear_screen

    ;#######estas 3 instrucciones sirven para imprimir el menu
    mov ah, 09h 
    mov dx, banner_msg
    int 21h         ;========OJO CON ESTO INT21H ES IMPORTANTE LE DICE A TODAS LAS INTRUCCIONES QUE PUSISTE ARRIBA EJECUTA========

    mov ah, 09h 
    mov dx, menu_options_msg
    int 21h

    ;#######Aca estan las intrucciones para leer la opcion del user
    mov ah, 01h
    int 21h

    ;#######Aca hago una especie de SWITCH
    ; Leer opción del usuario
    ; SWITCH: Comparar opción
    cmp al, '1'
    je agregar_producto        ; Tecla '1' → agregar
    
    cmp al, '2'
    je aumentar_existencia     ; Tecla '2' → aumentar
    
    cmp al, '3'
    je reducir_existencia      ; Tecla '3' → reducir
    
    cmp al, '4'
    je mostrar_inventario      ; Tecla '4' → mostrar
    
    cmp al, '5'
    je exit_program            ; Tecla '5' → salir

    ;######Opcion invalida
    mov ah, 09h
    mov dx, invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h

    ;#####IMPORTANTE PARA COMPLETAR CICLO WHILE####
    jmp start


;Trabajo en equipo funciona desde aca
;███████╗██╗░░░██╗███╗░░██╗░█████╗░██╗░█████╗░███╗░░██╗███████╗░██████╗
;██╔════╝██║░░░██║████╗░██║██╔══██╗██║██╔══██╗████╗░██║██╔════╝██╔════╝
;█████╗░░██║░░░██║██╔██╗██║██║░░╚═╝██║██║░░██║██╔██╗██║█████╗░░╚█████╗░
;██╔══╝░░██║░░░██║██║╚████║██║░░██╗██║██║░░██║██║╚████║██╔══╝░░░╚═══██╗
;██║░░░░░╚██████╔╝██║░╚███║╚█████╔╝██║╚█████╔╝██║░╚███║███████╗██████╔╝
;╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝░╚════╝░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝╚═════╝░

;#################################
;funcion de salir del programa equivalente a return 0
;#################################
exit_program:
    call clear_screen
    
    mov ah, 09h
    mov dx, goodbye_msg
    int 21h
    
    mov ah, 4Ch           ; Función 4Ch = terminar programa
    int 21h               ; Llamar a DOS para salir

;#################################
;funcion agregar_producto
;#################################
agregar_producto:
    call clear_screen
    
    ; Mostrar menú de productos
    mov ah, 09h
    mov dx, products_options
    int 21h
    
    ; Leer opción
    mov ah, 01h
    int 21h
    
    ; Convertir a índice (0-7)
    sub al, '1'           ; '1' → 0, '2' → 1, etc.
    cmp al, 7
    ja opcion_invalida    ; Si > 7, inválido
    
    ; SWITCH según producto elegido
    cmp al, 0
    je agregar_papas
    
    cmp al, 1
    je agregar_coca
    
    cmp al, 2
    je agregar_galletas
    
    cmp al, 3
    je agregar_agua
    
    cmp al, 4
    je agregar_cerveza
    
    cmp al, 5
    je agregar_vodka
    
    cmp al, 6
    je agregar_tequila
    
    cmp al, 7
    je agregar_jagger

opcion_invalida:
    mov ah, 09h
    mov dx, invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Papas ---
agregar_papas:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [papas_count], al     ; Sumar cantidad
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Coca ---
agregar_coca:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [coca_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Galletas ---
agregar_galletas:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [galletas_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Agua ---
agregar_agua:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [agua_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Cerveza ---
agregar_cerveza:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [cerveza_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Vodka ---
agregar_vodka:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [vodka_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Tequila ---
agregar_tequila:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [tequila_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Jaggermeister ---
agregar_jagger:
    mov ah, 09h
    mov dx, ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [jagger_count], al
    
    mov ah, 09h
    mov dx, msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion aumentar_existencia
;#################################
aumentar_existencia:
    call clear_screen
    mov ah, 09h
    mov dx, aumentar_msg
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion reducir_existencia
;#################################
reducir_existencia:
    call clear_screen
    mov ah, 09h
    mov dx, reducir_msg
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion mostrar_inventario
;#################################
mostrar_inventario:
    call clear_screen
    mov ah, 09h
    mov dx, mostrar_msg
    int 21h
    
    mov ah, 00h
    int 16h
    
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

;#################################
; SUBRUTINAS AUXILIARES
;#################################

;--- Leer dos dígitos ---
leer_dos_digitos:      ;importante usar el stack para que funcione y no perder los datos
    push bx
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al
    
    mov al, bl
    mov cl, 10
    mul cl
    add al, bh
    
    pop bx              ;Pop para guardar la direccion memoria y incrementar el stack pointer 
    ret

;--- Imprimir dos dígitos ---
imprimir_dos_digitos:
    push ax
    push dx
    
    mov bl, 10
    div bl
    
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    mov al, ah
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    pop dx
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
; MENSAJES funcion agregar_producto
;==============================
Full_storage_msg db 13, 10, 'El inventario esta lleno quita prodcutos', 13, 10, '$'
Ask_product      db 'Que codigo de producto quieres agregar', 13, 10, '$'
ask_cantidad     db 13, 10, 'Cantidad (2 digitos): $'
msg_agregado     db 13, 10, 'Producto agregado exitosamente!', 13, 10, '[Presiona tecla...]$'

;buffers para exixtencia 
products_options db '          1. Papitas', 13, 10
                 db '          2. Coca', 13, 10
                 db '          3. Galletas', 13, 10
                 db '          4. Agua', 13, 10
                 db '          5. Cerveza', 13, 10
                 db '          6. Vodka', 13, 10
                 db '          7. Tequila', 13, 10
                 db '          8. Jaggermeister', 13, 10
                 db 13, 10, 'Elige un producto para agregar (1-8): $' 

;==============================
; MENSAJES temporales (BORRAR después)
;==============================
agregar_msg  db 'TODO: Implementar agregar_producto', 13, 10, '[Presiona tecla...]', 13, 10, '$'
aumentar_msg db 'TODO: Implementar aumentar_existencia', 13, 10, '[Presiona tecla...]', 13, 10, '$'
reducir_msg  db 'TODO: Implementar reducir_existencia', 13, 10, '[Presiona tecla...]', 13, 10, '$'
mostrar_msg  db 'TODO: Implementar mostrar_inventario', 13, 10, '[Presiona tecla...]', 13, 10, '$'