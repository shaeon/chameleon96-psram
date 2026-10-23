#!/bin/bash
# Barrido de frecuencia x tACLK con las DOS PSRAM a la vez (simulacion).
#
#   ./run_sweep.sh [ruta_al_proyecto]
#
# Espera encontrar rtl/psram.sv, rtl/psram_test_ctrl.sv, rtl/aps6404l_model.sv
# y sim/tb_psram_dual.sv bajo esa ruta.

ROOT="${1:-.}"
WAIT_EB="${WAIT_EB:-7}"      # latencia 0xEB del modelo: 7 es la que casa con psram.sv
NW="${NW:-8}"                # 2^NW palabras por fase (8 = rapido, 12 = mas cobertura)

SRC="$ROOT/sim/tb_psram_dual.sv $ROOT/rtl/psram.sv $ROOT/rtl/psram_test_ctrl.sv $ROOT/rtl/aps6404l_model.sv"

printf "%-7s %-9s" "f(MHz)" "T/2(ns)"
for T in 2.0 3.0 3.5 4.0 5.5; do printf " %-10s" "tACLK=$T"; done
echo

for P in "5.0 100" "4.167 120" "3.846 130" "3.472 144" "3.125 160" "2.778 180" "2.5 200"; do
  set -- $P; H=$1; F=$2
  printf "%-7s %-9s" "$F" "$H"
  for T in 2.0 3.0 3.5 4.0 5.5; do
    iverilog -g2012 -DMODEL_WAIT_EB=$WAIT_EB -DNWORDS_LOG2=$NW \
             -DHALF_NS=$H -DTACLK=$T -o /tmp/sw.vvp $SRC 2>/dev/null
    V=$(timeout 600 vvp /tmp/sw.vvp 2>/dev/null | grep -oE "PASS|FAIL" | tail -1)
    printf " %-10s" "$V"
  done
  echo
done
