;#################################
;Inicio del programa 
;#################################

org 100h        ;Este sirve para decir donde iniciar el programa

;#################################
;Funcion Start equivalente al main
;#################################
;En este caso lo voy a usar como menu por que es la app base en si 
start:
    ; ===== LIMPIAR PANTALLA =====
    call limpiar_pantalla

    ;#######estas 3 instrucciones sirven para imprimir el menu
    mov ah, 09h 
    mov dx, menu_msg
    int 21h         ;========OJO CON ESTO INT21H ES IMPORTANTE LE DICE A TODAS LAS INTRUCCIONES QUE PUSISTE ARRIBA EJECUTA========

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
    call limpiar_pantalla
    
    mov ah, 09h
    mov dx, goodbye_msg
    int 21h
    
    mov ah, 4Ch           ; Función 4Ch = terminar programa
    int 21h               ; Llamar a DOS para salir

;#################################
;funcion agregar_producto
;#################################
agregar_producto:
    mov ah, 09h
    mov dx, agregar_msg
    int 21h
    jmp start

;#################################
;funcion aumentar_existencia
;#################################
aumentar_existencia:
    mov ah, 09h
    mov dx, aumentar_msg
    int 21h
    jmp start

;#################################
;funcion reducir_existencia
;#################################
reducir_existencia:
    mov ah, 09h
    mov dx, reducir_msg
    int 21h
    jmp start

;#################################
;funcion mostrar_inventario
;#################################
mostrar_inventario:
    mov ah, 09h
    mov dx, mostrar_msg
    int 21h
    jmp start

;#################################
;FUNCION: limpiar_pantalla
;Limpia la pantalla y pone cursor en (0,0)
;#################################
limpiar_pantalla:
    push ax
    push bx
    push cx
    push dx
    
    ; Scroll up (limpiar pantalla)
    mov ah, 06h           ; Función 06h = scroll up
    mov al, 0             ; 0 = limpiar toda la pantalla
    mov bh, 07h           ; Atributo: blanco sobre negro
    mov cx, 0             ; Esquina superior izquierda (0,0)
    mov dx, 184Fh         ; Esquina inferior derecha (24,79)
    int 10h               ; Llamar BIOS
    
    ; Posicionar cursor en (0,0)
    mov ah, 02h           ; Función 02h = set cursor position
    mov bh, 0             ; Página 0
    mov dx, 0             ; DH=fila 0, DL=columna 0
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;DATA
;==============================
; MENSAJES del menu
;==============================
menu_msg db 13, 10, 13, 10
         db '$$\                                          $$\                         $$\           ', 13, 10
         db '\__|                                         $$ |                        \__|      ', 13, 10
         db '$$\ $$$$$$$\ $$\    $$\  $$$$$$\  $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  $$\  $$$$$$\  ', 13, 10
         db '$$ |$$  __$$\\$$\  $$  |$$  __$$\ $$  __$$\\_$$  _|   \____$$\ $$  __$$\ $$ |$$  __$$\ ', 13, 10
         db '$$ |$$ |  $$ |\$$\$$  / $$$$$$$$ |$$ |  $$ | $$ |     $$$$$$$ |$$ |  \__|$$ |$$ /  $$ |', 13, 10
         db '$$ |$$ |  $$ | \$$$  /  $$   ____|$$ |  $$ | $$ |$$\ $$  __$$ |$$ |      $$ |$$ |  $$ |', 13, 10
         db '$$ |$$ |  $$ |  \$  /   \$$$$$$$\ $$ |  $$ | \$$$$  |\$$$$$$$ |$$ |      $$ |\$$$$$$  |', 13, 10
         db '\__|\__|  \__|   \_/     \_______|\__|  \__|  \____/  \_______|\__|      \__| \______/ ', 13, 10
         db '#####################################################################################################', 13, 10, 13, 10
         db '- 1 Agregar producto', 13, 10
         db '- 2 Aumentar existencia', 13, 10
         db '- 3 Reducir existencia', 13, 10
         db '- 4 Mostrar inventario', 13, 10
         db '- 5 Salir', 13, 10
         db 'Opcion: $'

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