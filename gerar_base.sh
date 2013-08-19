#!/usr/bin/env bash

wget "http://transparencia.prefeitura.sp.gov.br/_layouts/PPT/Exportacao/RelatorioServidores.aspx?Filters=;0;;0;1;0;0;0&ExportType=xls" -o RelatorioServidores.xls
cat RelatorioServidores.xls \
  | iconv -f ISO_8859-1 -t UTF8 \
  | sed -r 's/^\s+//;s/\s+$//' \
  | tail -n +46 \
  | grep -v -E '</?h3' \
  | grep -v -E '</?table' \
  | tr '\n\r' '  ' \
  | sed -ru 's/<\/tr>\s*<tr>/\n/g' \
  | grep -v 'form>' \
  | sed -ru 's/\s*<\/td>\s*<td[^>]*>\s*/;/g' \
  | sed -ru 's/^\s*<td[^>]*>\s*//g;s/<\/td>\s*$//g'  \
  | sed 's/\.//g;s/,/\./g' \
  | awk -F ';' '{print $1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9" "$10", "$11";"$12";"$13}' \
  | perl -pe 'chomp if eof' - >! gerado/RelatorioServidores.csv
rm gerado/RelatorioServidores.db
python csv2sqlite.py
