# Flujo de trabajo en el proyecto 

primero antes de trabajr en el proyecto tienen que clonarlo **hacer pull por si hay cambios nuevos**
```bash
git clone https://github.com/Viernes137/ProyectoArq.git
```
**IMPORTANTE se trabajara sobre Base_proyecto.asm**

Una vez clonado se meten a la carpeta y trabajan en su propia rama el comando para crear una branch es 
```bash
git checkout -b Nombre_rama
```
Una vez echa la rama hacerle un push para no perder los cambios 

## Reparto 
>- Antonio: Menu y funcion1 (agregar_producto)
>- Xime: Funcion2 (aumentar_existencia)
>- Bruno: Funcion3 (reducir_existencia)
>- Pablito: Funcion4 (mostrar_inventario) y **DOCUMENTACION**

## Notas
Si sale con IA pero hay cosas importantes a aclarar para que erre menos como:
>- 1. emu8086 solo registros de 16bits lamentablemente muy limitado
>- 2. tienen que ver como debugearlo y compilarlo para poder ejecutarlo
>- 3. sintaxis CISC Y **INTEL**
>- 4. funcion offset no funciona en este de 16 bits en su lugar tiene que asignar directamente el mesagge para imprimir **SOLO LINUX**

## Si trabajas en windows solo tienes que agregarle offset a los prints