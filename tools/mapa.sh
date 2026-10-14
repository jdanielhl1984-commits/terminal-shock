#!/bin/sh
# Regenera la tabla de funciones de MAPA.md a partir de index.html.
# Uso:  sh tools/mapa.sh          -> lista secciones y funciones con su línea
#       sh tools/mapa.sh grep X   -> busca dónde se define y dónde se usa X
cd "$(dirname "$0")/.." || exit 1
if [ "$1" = "grep" ] && [ -n "$2" ]; then
  echo "== se define en:"; grep -nE "(function|const|let|var) +$2\b" index.html
  echo "== se usa en:";    grep -n "\b$2\b" index.html | grep -vE "(function|const|let|var) +$2\b" | head -40
  exit 0
fi
awk '
/^\/\* =+ /{ gsub(/^\/\* =+ /,""); gsub(/ =+ \*\/$/,""); gsub(/ =+$/,"");
             printf "\n### %s  (línea %d)\n", $0, NR; next }
/^function [A-Za-z_$][A-Za-z0-9_$]*/ { match($0,/^function [A-Za-z0-9_$]+/);
             printf "%5d  %s()\n", NR, substr($0,10,RLENGTH-9); next }
/^const [A-Z][A-Z0-9_]*=/ { match($0,/^const [A-Z0-9_]+/);
             printf "%5d  %s  (datos)\n", NR, substr($0,7,RLENGTH-6); next }
' index.html
