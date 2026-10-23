#!/usr/bin/env bash
# Compila una variante del test PSRAM y deja el .rbf en quartus/output_files.
#
#   scripts/build.sh <TOP> <FREQ_MHZ> [PHASE_PS]
#
#   TOP       psram_qspi_test_dual | psram_qspi_test_chip2
#   FREQ_MHZ  frecuencia de outclk_0 y del sclk de la PSRAM: 120, 144, 160...
#   PHASE_PS  desfase de outclk_1 en ps (por defecto 0)
#
# Trabaja sobre el arbol tal cual, igual que el build del Aleste520EX: cada
# job de la matriz corre en su propio runner, asi que no hay nada que aislar.

set -euo pipefail

TOP="${1:?falta TOP}"
FREQ="${2:?falta FREQ_MHZ}"
PHASE="${3:-0}"

VAR="${TOP}_${FREQ}MHz"
[ "$PHASE" != "0" ] && VAR="${VAR}_ph${PHASE}ps"

echo "=== ${VAR} ==="
cd quartus

QSF="$(ls *.qsf | head -1)"
QPF="$(ls *.qpf | head -1)"
PROJ="${QPF%.qpf}"
REV="$(basename "$QSF" .qsf)"

# --- frecuencia del PLL -----------------------------------------------
# pll96 es un altera_pll instanciado con parametros de texto: basta
# reescribirlos, no hay que regenerar nada con Qsys.
PLLV="pll96/pll96_0002.v"
FREQ_STR="$(printf "%.6f MHz" "$FREQ")"
sed -i -E "s/\.output_clock_frequency0\(\"[^\"]*\"\)/.output_clock_frequency0(\"${FREQ_STR}\")/" "$PLLV"
sed -i -E "s/\.output_clock_frequency1\(\"[^\"]*\"\)/.output_clock_frequency1(\"${FREQ_STR}\")/" "$PLLV"
sed -i -E "s/\.phase_shift1\(\"[^\"]*\"\)/.phase_shift1(\"${PHASE} ps\")/" "$PLLV"
grep -E "output_clock_frequency[01]\(|phase_shift1\(" "$PLLV"

# --- top level --------------------------------------------------------
sed -i -E "s/^set_global_assignment -name TOP_LEVEL_ENTITY .*/set_global_assignment -name TOP_LEVEL_ENTITY ${TOP}/" "$QSF"
sed -i -E "s@^set_global_assignment -name SYSTEMVERILOG_FILE psram_qspi_test_[a-z0-9_]+\.sv@set_global_assignment -name SYSTEMVERILOG_FILE ${TOP}.sv@" files.qip
grep -q "${TOP}.sv" files.qip || echo "set_global_assignment -name SYSTEMVERILOG_FILE ${TOP}.sv" >> files.qip

# Preferencia del proyecto: sin analisis multicorner.
sed -i -E "/^set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON/d" "$QSF"

# --- compilar ---------------------------------------------------------
quartus_sh --flow compile "$PROJ" -c "$REV"

# --- .rbf -------------------------------------------------------------
SOF="output_files/${REV}.sof"
[ -f "$SOF" ] || { echo "ERROR: no se genero $SOF"; exit 1; }
quartus_cpf -c "$SOF" "output_files/${VAR}.rbf"

echo "=== ${VAR} LISTO ==="
ls -la "output_files/${VAR}.rbf"
