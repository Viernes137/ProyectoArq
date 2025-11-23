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
    mov dx,offset banner_msg
    int 21h         ;========OJO CON ESTO INT21H ES IMPORTANTE LE DICE A TODAS LAS INTRUCCIONES QUE PUSISTE ARRIBA EJECUTA========

    mov ah, 09h 
    mov dx,offset menu_options_msg
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
    mov dx,offset invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h

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
    mov dx,offset goodbye_msg
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
    mov dx, offset products_options
    int 21h
    
    ; Leer opción
    mov ah, 01h
    int 21h
    
    ; Convertir a índice (0-7)
    sub al, '1'           ; '1' ? 0, '2' ? 1, etc.
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
    mov dx,offset invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Papas ---
agregar_papas:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [papas_count], al     ; Sumar cantidad
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Coca ---
agregar_coca:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [coca_count], al
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Galletas ---
agregar_galletas:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [galletas_count], al
    
    mov ah, 09h
    mov dx,offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Agua ---
agregar_agua:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [agua_count], al
    
    mov ah, 09h
    mov dx,offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Cerveza ---
agregar_cerveza:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [cerveza_count], al
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Vodka ---
agregar_vodka:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [vodka_count], al
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Tequila ---
agregar_tequila:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [tequila_count], al
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Agregar Jaggermeister ---
agregar_jagger:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [jagger_count], al
    
    mov ah, 09h
    mov dx, offset msg_agregado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion aumentar_existencia
;#################################
aumentar_existencia:
    call clear_screen
    
    ; Mostrar menú de productos
    mov ah, 09h
    mov dx,offset products_options
    int 21h
    
    ; Leer opción del producto
    mov ah, 01h
    int 21h
    
    ; Convertir a índice (0-7)
    sub al, '1'           ; '1' ? 0, '2' ? 1, etc.
    cmp al, 7
    ja opcion_invalida_aumentar    ; Si > 7, inválido
    
    ; SWITCH según producto elegido
    cmp al, 0
    je aumentar_papas
    
    cmp al, 1
    je aumentar_coca
    
    cmp al, 2
    je aumentar_galletas
    
    cmp al, 3
    je aumentar_agua
    
    cmp al, 4
    je aumentar_cerveza
    
    cmp al, 5
    je aumentar_vodka
    
    cmp al, 6
    je aumentar_tequila
    
    cmp al, 7
    je aumentar_jagger

opcion_invalida_aumentar:
    mov ah, 09h
    mov dx,offset invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Papas ---
aumentar_papas:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [papas_count], al     ; Sumar cantidad al contador
    
    mov ah, 09h
    mov dx, offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Coca ---
aumentar_coca:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [coca_count], al
    
    mov ah, 09h
    mov dx,offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Galletas ---
aumentar_galletas:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [galletas_count], al
    
    mov ah, 09h
    mov dx, offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Agua ---
aumentar_agua:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [agua_count], al
    
    mov ah, 09h
    mov dx,offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Cerveza ---
aumentar_cerveza:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [cerveza_count], al
    
    mov ah, 09h
    mov dx, offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Vodka ---
aumentar_vodka:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [vodka_count], al
    
    mov ah, 09h
    mov dx,offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Tequila ---
aumentar_tequila:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [tequila_count], al
    
    mov ah, 09h
    mov dx, offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Aumentar Jaggermeister ---
aumentar_jagger:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    add [jagger_count], al
    
    mov ah, 09h
    mov dx,offset msg_aumentado
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion reducir_existencia
;#################################
reducir_existencia:
    call clear_screen
    
    ; Mostrar menú de productos
    mov ah, 09h
    mov dx, offset products_options
    int 21h
    
    ; Leer opción del producto
    mov ah, 01h
    int 21h
    
    ; Convertir a índice (0-7)
    sub al, '1'           ; '1' ? 0, '2' ? 1, etc.
    cmp al, 7
    ja opcion_invalida_reducir    ; Si > 7, inválido
    
    ; SWITCH según producto elegido
    cmp al, 0
    je reducir_papas
    
    cmp al, 1
    je reducir_coca
    
    cmp al, 2
    je reducir_galletas
    
    cmp al, 3
    je reducir_agua
    
    cmp al, 4
    je reducir_cerveza
    
    cmp al, 5
    je reducir_vodka
    
    cmp al, 6
    je reducir_tequila
    
    cmp al, 7
    je reducir_jagger

opcion_invalida_reducir:
    mov ah, 09h
    mov dx, offset invalid_option_MSG
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Papas ---
reducir_papas:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    ; Restar cantidad (verificar que no sea negativo)
    mov bl, [papas_count]
    cmp al, bl
    ja cantidad_mayor       ; Si cantidad > existencia, error
    
    sub [papas_count], al   ; Restar cantidad del contador
    
    mov ah, 09h
    mov dx, offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Coca ---
reducir_coca:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [coca_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [coca_count], al
    
    mov ah, 09h
    mov dx,offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Galletas ---
reducir_galletas:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [galletas_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [galletas_count], al
    
    mov ah, 09h
    mov dx,offset  msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Agua ---
reducir_agua:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [agua_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [agua_count], al
    
    mov ah, 09h
    mov dx,offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Cerveza ---
reducir_cerveza:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [cerveza_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [cerveza_count], al
    
    mov ah, 09h
    mov dx,offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Vodka ---
reducir_vodka:
    mov ah, 09h
    mov dx,offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [vodka_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [vodka_count], al
    
    mov ah, 09h
    mov dx, offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Tequila ---
reducir_tequila:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [tequila_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [tequila_count], al
    
    mov ah, 09h
    mov dx, offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Reducir Jaggermeister ---
reducir_jagger:
    mov ah, 09h
    mov dx, offset ask_cantidad
    int 21h
    
    call leer_dos_digitos
    
    mov bl, [jagger_count]
    cmp al, bl
    ja cantidad_mayor
    
    sub [jagger_count], al
    
    mov ah, 09h
    mov dx,offset msg_reducido
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;--- Error: Cantidad mayor que existencia ---
cantidad_mayor:
    mov ah, 09h
    mov dx, offset msg_insuficiente
    int 21h
    
    mov ah, 00h
    int 16h
    
    jmp start

;#################################
;funcion mostrar_inventario
;#################################
mostrar_inventario:
    call clear_screen
    
    ; Mostrar título
    mov ah, 09h
    mov dx, offset titulo_inventario
    int 21h
    
    ; ===== 1. Papitas =====
    mov ah, 09h
    mov dx, offset nombre_papas
    int 21h
    
    mov al, [papas_count]      ; Cargar cantidad
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [papas_price]      ; Cargar precio
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 2. Coca =====
    mov ah, 09h
    mov dx,offset nombre_coca
    int 21h
    
    mov al, [coca_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [coca_price]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 3. Galletas =====
    mov ah, 09h
    mov dx,offset nombre_galletas
    int 21h
    
    mov al, [galletas_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [galletas_price]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 4. Agua =====
    mov ah, 09h
    mov dx,offset nombre_agua
    int 21h
    
    mov al, [agua_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [agua_price]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 5. Cerveza =====
    mov ah, 09h
    mov dx,offset nombre_cerveza
    int 21h
    
    mov al, [cerveza_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [cerveza_price]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 6. Vodka =====
    mov ah, 09h
    mov dx,offset nombre_vodka
    int 21h
    
    mov al, [vodka_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [vodka_price]
    call imprimir_tres_digitos   ; Precio de 3 dígitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 7. Tequila =====
    mov ah, 09h
    mov dx,offset nombre_tequila
    int 21h
    
    mov al, [tequila_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [tequila_price]
    call imprimir_tres_digitos   ; Precio de 3 dígitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; ===== 8. Jaggermeister =====
    mov ah, 09h
    mov dx,offset nombre_jagger
    int 21h
    
    mov al, [jagger_count]
    call imprimir_dos_digitos
    
    mov ah, 09h
    mov dx,offset texto_precio
    int 21h
    
    mov al, [jagger_price]
    call imprimir_tres_digitos   ; Precio de 3 dígitos
    
    mov ah, 09h
    mov dx,offset salto_linea
    int 21h
    
    ; Pausa antes de volver
    mov ah, 09h
    mov dx,offset msg_continuar
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
leer_dos_digitos:
    push bx
    push dx

    ; Leer primer dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al        ; BL = decenas

    ; Leer segundo dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al        ; BH = unidades

    ; Convertir: resultado = BL*10 + BH
    mov al, bl        ; AL = decena
    xor ah, ah        ; ???? AH = 0 (esto faltaba)
    mov dl, 10
    mul dl            ; AX = AL * 10

    add al, bh        ; AL = decena*10 + unidad

    pop dx
    pop bx
    ret


;--- Imprimir dos dígitos ---
imprimir_dos_digitos:
    push ax
    push bx
    push dx
         
    xor ah, ah     
    mov bl, 10
    div bl          ; AL = decenas, AH = unidades
     
    push ax
    
    ; imprimir decenas (si = 0 imprimir espacio)
    cmp al, 0
    jne impresion_decena
    mov dl, ' '     ; espacio en lugar de 0
    mov ah, 02h
    int 21h
    jmp imprimir_unidad
impresion_decena:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

imprimir_unidad:
    pop ax
    mov al, ah
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    pop dx
    pop bx
    pop ax
    ret

;--- Imprimir tres dígitos (para precios como 150, 120, 200) ---
imprimir_tres_digitos:
    push ax
    push bx
    push dx
    
    xor ah, ah           ; Limpiar AH
    mov bl, 100
    div bl              ; AL = centenas, AH = resto
    
    add al, '0'         ; Centenas a ASCII
    mov dl, al
    push ax             ; Guardar resto
    mov ah, 02h
    int 21h
    
    pop ax              ; Recuperar resto
    mov al, ah          ; AL = resto (decenas y unidades)
    mov ah, 0
    mov bl, 10
    div bl              ; AL = decenas, AH = unidades
    
    add al, '0'         ; Decenas a ASCII
    mov dl, al
    push ax             ; Guardar unidades
    mov ah, 02h
    int 21h
    
    pop ax              ; Recuperar unidades
    mov al, ah
    add al, '0'         ; Unidades a ASCII
    mov dl, al
    mov ah, 02h
    int 21h
    
    pop dx
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
; MENSAJES funcion agregar_producto
;==============================
ask_cantidad     db 13, 10, 'Cantidad (2 digitos): $'
msg_agregado     db 13, 10, 'Producto agregado exitosamente!', 13, 10, '[Presiona tecla...]$'

;buffers para existencia 
products_options db '          1. Papitas', 13, 10
                 db '          2. Coca', 13, 10
                 db '          3. Galletas', 13, 10
                 db '          4. Agua', 13, 10
                 db '          5. Cerveza', 13, 10
                 db '          6. Vodka', 13, 10
                 db '          7. Tequila', 13, 10
                 db '          8. Jaggermeister', 13, 10
                 db 13, 10, 'Elige un producto (1-8): $' 

;==============================
; MENSAJES funcion aumentar_existencia
;==============================
msg_aumentado db 13, 10, 'Existencia aumentada exitosamente!', 13, 10, '[Presiona tecla...]$'

;==============================
; MENSAJES funcion reducir_existencia
;==============================
msg_reducido      db 13, 10, 'Existencia reducida exitosamente!', 13, 10, '[Presiona tecla...]$'
msg_insuficiente  db 13, 10, 'ERROR: No hay suficiente existencia!', 13, 10, '[Presiona tecla...]$'

;==============================
; MENSAJES funcion mostrar_inventario
;==============================
titulo_inventario db 13, 10, '========== INVENTARIO ==========', 13, 10, 13, 10, '$'
nombre_papas      db 'Papitas       - Cant: $'
nombre_coca       db 'Coca          - Cant: $'
nombre_galletas   db 'Galletas      - Cant: $'
nombre_agua       db 'Agua          - Cant: $'
nombre_cerveza    db 'Cerveza       - Cant: $'
nombre_vodka      db 'Vodka         - Cant: $'
nombre_tequila    db 'Tequila       - Cant: $'
nombre_jagger     db 'Jaggermeister - Cant: $'
texto_precio      db '   Precio: $'
salto_linea       db 13, 10, '$'
msg_continuar     db 13, 10, '[Presiona tecla para volver al menu...]$'