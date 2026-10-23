# CI: compilar los RBF en GitHub

Mismo esquema que el `build.yml` de `Aleste520EX_MiSTer`: imagen pública de
`raetro/quartus`, `docker pull` + `docker run`, y ya está. Sin imágenes
propias, sin GHCR, sin tokens.

La única diferencia es que aquí hay una **matriz de frecuencias**, para sacar
un `.rbf` por cada velocidad de sclk y ver en la placa cuál es la más alta sin
fallos.

| | Aleste520EX | Este repo |
|---|---|---|
| Imagen | `raetro/quartus:17.0` | `raetro/quartus:21.1.1` |
| Compilación | `quartus_sh --flow compile Aleste520EX` | `scripts/build.sh <top> <freq>` |
| Salida | un `.rbf` | un `.rbf` por frecuencia |

## La versión

`raetro/quartus` publica hasta **21.1.1** (julio de 2022). El proyecto está
generado con **ACDS 22.1** —lo dicen el `.qpf`, el `hps.qsys`, el `pll96.qip` y
el `hps.qip`— pero el IP **ya viene generado en el repo**: 56 ficheros de HDL
en `hps/synthesis/`, y el `.qip` lleva `SYNTHESIS_ONLY_QIP ON`, o sea que solo
lista Verilog para sintetizar, no manda regenerar nada con Qsys.

Así que lo que 21.1 tiene que hacer es sintetizar Verilog corriente. Lo más
que puede pasar es un aviso de que el proyecto es de una versión más nueva.

Si no colara, las opciones serían un runner self-hosted con tu Quartus 22.1std
local, o construir una imagen a partir de los instaladores descargados a mano
(desde 2025 están detrás de inicio de sesión en altera.com, así que no hay
forma de automatizar la descarga). Pero probar cuesta un ciclo de CI.

> Las imágenes de raetro traen `ENTRYPOINT ["quartus-entrypoint"]`, por eso el
> `docker run` pasa `--entrypoint /bin/bash`.

## Qué hace el workflow

**`sim`** — en runner público, sin Quartus. Compila el banco dual con iverilog,
exige `VERDICT: PASS` y corre el barrido frecuencia × tACLK. Menos de un
minuto, y evita gastar sintesis en algo que ya falla en simulación.

**`rbf`** — matriz de variantes, en paralelo, con `fail-fast: false` para que
una frecuencia que no cierre no tumbe las demás (que es justo el dato
buscado). Cada job sube su `.rbf` y los informes, y el resumen de timing sale
en la página de la ejecución con aviso si hay holguras negativas.

**`release`** — en tags `v*`: todos los `.rbf` juntos.

Por defecto, `Run workflow` propone:

```
tops  ["psram_qspi_test_dual"]
freqs [120, 144, 160, 180]
```

## Cómo cambia la frecuencia

`pll96` es un `altera_pll` instanciado con parámetros de texto:

```verilog
.output_clock_frequency0("144.000000 MHz"),
.phase_shift0("0 ps"),
.output_clock_frequency1("144.000000 MHz"),
.phase_shift1("0 ps"),
```

`build.sh` los reescribe con `sed` antes de compilar — el mismo truco que tu
`sdram_phase.yml`. No hace falta regenerar nada con Qsys.

> El comentario del `loanio_sta.sdc` dice que `outclk_1` está a −2951 ps.
> **No lo está**: el fichero generado tiene `phase_shift1("0 ps")`. Si algún
> día se quiere probar la captura con reloj desplazado, el tercer argumento de
> `build.sh` genera el desfase de verdad:
>
> ```bash
> ./scripts/build.sh psram_qspi_test_dual 144 -2951
> ```
>
> Aunque hoy no sirve: `psram.sv` captura con `outclk_0` y nadie consume
> `outclk_1`. Primero hay que separar lanzamiento y captura en el controlador.

## Probarlo en local

```bash
docker run --rm --entrypoint /bin/bash -v "$PWD":/build -w /build \
    raetro/quartus:21.1.1 -c "./scripts/build.sh psram_qspi_test_dual 144"
```

## Lo que la CI no puede decirte

Verifica el timing interno de la fábrica. **La ventana real de la PSRAM no**:
los pads loan no exponen arcos, así que TimeQuest no ve el bus QSPI. Que un
`.rbf` compile y cierre no garantiza que esa frecuencia funcione en placa.

La CI te da los `.rbf`; la respuesta sale de grabarlos y mirar D6/D7.
