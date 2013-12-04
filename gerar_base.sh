#!/usr/bin/env bash

wget "http://transparencia.prefeitura.sp.gov.br/_layouts/PPT/Exportacao/RelatorioServidores.aspx?Filters=;0;;0;1;0;0;0&ExportType=xls" -O RelatorioServidores.xls
cat RelatorioServidores.xls  | iconv -f ISO_8859-1 -t UTF8 > relatorio_utf8.xls
ruby parse_xls.rb relatorio_utf8.xls gerado/RelatorioServidores.csv
rm gerado/RelatorioServidores.db
python csv2sqlite.py
