require 'nokogiri'
require 'csv'


puts 'Processando arquivo de funcionarismo da Prefeitura de SP...'

puts 'Lendo arquivo...'
xls=open(ARGV[0]).read()

puts 'Transformando em um documento DOM...'
dom=Nokogiri.parse(xls)



puts 'Extraindo conteúdo...'
headers=dom.css('table:nth(2) h3').map{|el| el.text.strip }
values =dom.css('table:nth(2) tr:nth(n+3)').map {|tr| tr.css('td').map{|td| td.text.strip }}
dtfonte=values[-1][0].split().join(' ')

puts dtfonte

#ignora rodape
values=values[1..-4]

# formata endereço
headers[8..10]="#{headers[8]} #{headers[9]}, #{headers[10]}"
values.each do |el|
	el[8..10]="#{el[8]} #{el[9]}, #{el[10]}"
end

CSV.open(ARGV[1], 'w', {col_sep: ';', headers: headers, write_headers: true}) do |csv| 
	values.each {|el| csv << el }
end
