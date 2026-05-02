# BlinderKitten en NixOS

Wrapper para correr el AppImage de
[BlinderKitten](https://www.blinderkitten.com/) en NixOS.

## El problema

BlinderKitten se distribuye como AppImage. En NixOS, los AppImages no corren
directamente porque el sistema no tiene las librerías del sistema en las rutas
que estos esperan. La solución estándar (`appimage-run` con `binfmt`) no es
suficiente para este AppImage en particular — necesita dependencias muy
específicas, incluyendo una versión antigua de `curl` de nixpkgs 23.11.

La solución es un entorno FHS (`buildFHSEnv`) que provee las librerías
correctas y apunta al binario ya extraído del AppImage.

## Uso

Primero extraer el AppImage manualmente:

```bash
nix-shell -p squashfsTools --run "unsquashfs -o 944632 -d squashfs-root ./BlinderKitten-linux-x64-1.0.1b95.AppImage"
```

Luego buildear:

```bash
nix-build blinderkitten.nix
./result/bin/blinderkitten
```

y correr el wrapper:

```bash
nix-build blinderkitten.nix
./result/bin/blinderkitten
```

El wrapper asume que `squashfs-root` existe en el directorio de trabajo.

### El offset

El valor `944632` es el offset en bytes donde empieza el sistema de archivos
SquashFS dentro del AppImage. Es específico a la versión `1.0.1b95`. Si se
actualiza el AppImage, encontrar el nuevo offset con:

```bash
strings -t d ./BlinderKitten-linux-x64-X.X.X.AppImage | grep "hsqs"
```

El número al inicio de la línea donde aparece `hsqs` es el offset.

## Ramas

- `main` — esta rama. Extracción manual, script simple.
- `sinExtraer` — el wrapper extrae el AppImage automáticamente la primera vez.
  El offset está hardcodeado, lo que significa que hay que actualizarlo si
  cambia la versión del AppImage. Ver el README de esa rama para más detalles.
