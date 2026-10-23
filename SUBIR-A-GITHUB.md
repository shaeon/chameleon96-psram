# Subir el proyecto a GitHub desde el CMD de Windows

Todo con `cmd.exe`, no PowerShell. Si copias y pegas, hazlo línea a línea las
primeras veces: así ves dónde falla si falla.

---

## 0. Requisitos

```cmd
git --version
docker --version
```

Si `git` no responde, instala **Git for Windows** desde https://git-scm.com/download/win
(opciones por defecto). Si `docker` no responde, instala **Docker Desktop**.
Cierra y vuelve a abrir el CMD después de instalar, o no verá el PATH nuevo.

Identifícate una vez:

```cmd
git config --global user.name "Shaeon"
git config --global user.email "tu@email"
```

---

## 1. Crear el repositorio vacío en GitHub

En la web: **New repository** → nombre `chameleon96-psram` → **privado** (puedes
hacerlo público después) → **sin** README, **sin** .gitignore, **sin** licencia.
Si lo creas con ficheros, el primer `push` te dará un rechazo por historiales
divergentes.

---

## 2. Preparar la carpeta

Descomprime `chameleon96-psram-repo.zip` en una carpeta nueva. Ya viene el
árbol entero y listo: proyecto, RTL, simulación y la CI, sin los ficheros
generados.

```cmd
cd /d C:\dev\chameleon96-psram
dir /a
```

Debe verse esto:

```
.gitattributes
.github
.gitignore
README-ci.md
SUBIR-A-GITHUB.md
docker
quartus
rtl
scripts
sim
```

Comprobación rápida de que están las piezas clave:

```cmd
dir quartus\psram_qspi_test_dual.sv
dir sim\tb_psram_dual.sv
dir quartus\hps\synthesis\hps.qip
type .gitignore
```

---

## 3. Qué sube y qué no

Importa, porque el proyecto en bruto ocupa 119 MB y GitHub avisa a partir de
50 MB por fichero:

| Carpeta | Tamaño | ¿Sube? |
|---|---|---|
| `quartus\db` | 29 MB | **No** — la regenera Quartus |
| `quartus\output_files` | 22 MB | **No** — la genera la CI |
| `quartus\incremental_db` | 6 MB | **No** |
| `quartus\eda` | 7 MB | **No** |
| `sim\vcd` | 23 MB | **No** — salida de simulación |
| `quartus\hps` | 27 MB | **Sí** — es el IP generado, hace falta para compilar |
| el resto | pequeño | Sí |

Total que sube: **unos 32 MB en 149 ficheros**. Sin problemas de tamaño y sin
necesidad de Git LFS.

Lo de `quartus\hps` es importante: son 23 MB en `synthesis\`, generados por
Qsys, pero **tienen que ir al repo**. Si no, la CI no puede compilar, porque
no vamos a regenerar el Qsys (y además no debe regenerarse: va emparejado con
el `iocsr_config.h` que arregló el USB).

---

## 4. Primer commit

```cmd
git init -b main
git add -A
git status
```

Repasa la lista antes de confirmar. **No deben aparecer** ficheros bajo `db/`,
`output_files/`, `incremental_db/`, `eda/` ni `vcd/`. Si aparecen, el
`.gitignore` no está en la raíz o tiene otro nombre (ojo con que el Bloc de
notas lo guarde como `.gitignore.txt`).

```cmd
git commit -m "Test PSRAM QSPI para Chameleon96: chip1, chip2 y dual"
```

---

## 5. Conectar y empujar

Con el nombre de tu repo:

```cmd
git remote add origin https://github.com/shaeon/chameleon96-psram.git
git push -u origin main
```

La primera vez se abre una ventana del navegador para autenticarse. Si prefieres
token: usuario = tu nombre de GitHub, contraseña = un **Personal Access Token**
(Settings → Developer settings → Tokens, con scope `repo`). La contraseña de la
cuenta no vale desde 2021.

Comprueba:

```cmd
git log --oneline
git remote -v
```

---

## 6. La imagen de Quartus: nada que hacer

Igual que en el Aleste520EX: el workflow hace `docker pull raetro/quartus:21.1.1`
y listo. Imagen pública, sin token, sin package, sin construir nada.

Pasa directamente al paso 7.

## 7. Lanzar la compilación

En GitHub: pestaña **Actions** → **Build RBF** → **Run workflow**. Deja los
valores por defecto o cambia las frecuencias:

```
tops  ["psram_qspi_test_dual"]
freqs [120, 144, 160, 180]
```

Cuatro jobs en paralelo. Cada uno sube su `.rbf` y los informes como artefacto,
y el resumen de timing sale en la página de la ejecución.

Para una release con todos juntos:

```cmd
git tag v0.1
git push origin v0.1
```

---

## 8. Probar en local antes de gastar CI

Si tienes Docker en Windows, un ciclo de CI son 20-30 minutos y esto diez:

```cmd
docker run --rm --entrypoint /bin/bash -v "%cd%":/build -w /build raetro/quartus:21.1.1 -c "./scripts/build.sh psram_qspi_test_dual 144"
```

> `%cd%` es la variable de CMD (en PowerShell sería `${PWD}`). Las comillas son
> necesarias si la ruta tiene espacios.

## Problemas típicos en Windows

| Síntoma | Causa |
|---|---|
| `error: failed to push some refs` | Creaste el repo con README. `git pull --rebase origin main` y vuelve a empujar |
| `Permission denied (publickey)` | Estás usando la URL SSH; usa la `https://` |
| `./scripts/build.sh: Permission denied` | Git no guardó el bit de ejecución: `git update-index --chmod=+x scripts/build.sh` y commit |
| `bad interpreter: /usr/bin/env bash^M` | Finales de línea CRLF en los `.sh`. Añade un `.gitattributes` con `*.sh text eol=lf`, borra el fichero y vuelve a hacer checkout |
| Suben ficheros de `db/` | El `.gitignore` se guardó como `.gitignore.txt`. Compruébalo con `dir /a` |
| `docker: invalid reference format` | Ruta con espacios sin comillas en el `-v` |

El de los finales de línea es el que más muerde: Git for Windows convierte a
CRLF por defecto y el contenedor es Linux. Lo zanjas de entrada creando un
`.gitattributes` en la raíz con:

```
*.sh text eol=lf
*.tcl text eol=lf
```

y haciéndolo en el **primer** commit, antes de que nada se guarde mal.
