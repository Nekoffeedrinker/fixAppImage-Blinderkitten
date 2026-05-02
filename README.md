# BlinderKitten en NixOS — extracción automática

Esta rama contiene un wrapper para correr el AppImage de
[BlinderKitten](https://www.blinderkitten.com/) en NixOS sin tener que extraer
el AppImage manualmente antes de cada uso.

## El problema

BlinderKitten se distribuye como AppImage. En NixOS, los AppImages no corren
directamente porque el sistema no tiene las librerías del sistema en las rutas
que estos esperan. La solución estándar (`appimage-run` con `binfmt`) no es
suficiente para este AppImage en particular ya que necesita dependencias muy
específicas.

La solución es un entorno FHS (`buildFHSEnv`) que provee las librerías
correctas. El detalle es que el entorno FHS necesita apuntar al binario
extraído, no al AppImage directamente.

## Cómo funciona esta rama

El script dentro del wrapper:

1. Recibe el AppImage como argumento
2. Busca si ya existe un directorio `squashfs-root` junto al AppImage
3. Si no existe, lo extrae automáticamente con `unsquashfs`
4. Ejecuta `squashfs-root/AppRun` dentro del entorno FHS

## Uso

Ejecutar una vez:

```bash
nix-build blinderkitten.nix
```

Y para cada apertura del programa:

```bash
./result/bin/blinderkitten ./BlinderKitten-linux-x64-1.0.1b95.AppImage
```

La primera vez extrae el AppImage (tarda unos segundos). Las siguientes veces
reutiliza el `squashfs-root` y abre directo.

## El offset hardcodeado

`unsquashfs` necesita saber en qué byte del AppImage empieza el sistema de
archivos SquashFS, porque el archivo es en realidad un ejecutable ELF con un
SquashFS pegado al final.

El offset está hardcodeado en el script como `944632`. Este valor es específico
a la versión `1.0.1b95` de BlinderKitten. Si se actualiza el AppImage, el
offset puede cambiar.

### Cómo encontrar el offset de una versión nueva

```bash
strings -t d ./BlinderKitten-linux-x64-X.X.X.AppImage | grep "hsqs"
```

Buscar la línea donde aparece `hsqs` seguido de caracteres (no como parte de
una palabra más larga). El número al inicio de esa línea es el offset. Por
ejemplo:

```
944632 hsqs!
```

Luego actualizar la línea en `blinderkitten.nix`:

```nix
unsquashfs -o 944632 -d "$EXTRACT_DIR" "$APPIMAGE"
```

## Por qué `binfmt` interfiere

NixOS tiene `programs.appimage.binfmt = true` habilitado, lo que hace que el
kernel intercepte cualquier AppImage y lo mande a `appimage-run`. Esto impide
usar `--appimage-extract` directamente desde el script, porque el kernel nunca
le pasa el flag al AppImage — lo manda a `appimage-run` en su lugar. Por eso
se usa `unsquashfs` con el offset en vez de dejar que el AppImage se extraiga
a sí mismo.

## Ver también

La rama `main` tiene la versión donde la extracción es manual pero el script
es más simple.
