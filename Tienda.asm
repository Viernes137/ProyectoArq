
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
    cmp 

ret




