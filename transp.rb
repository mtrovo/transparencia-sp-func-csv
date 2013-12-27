#!/usr/bin/env ruby


require 'sinatra'
require 'sqlite3'
require 'json'
require 'unicode'

db=SQLite3::Database.new 'gerado/RelatorioServidores.db'
db.results_as_hash=true
db.type_translation=true

class String 
  def titleize
    split.map{|w| Unicode::capitalize w}.join ' '
  end
end

ABBRV={MUNICIPAL: "MUN.",
      SECRETARIA: "SEC.",
      DESENVOLVIMENTO: "DESENV."}

LOWERCASE=%w{De Da Do Dos Das E A O As Os}

def format_title title
  ABBRV.each{|k,v| title.sub! k.to_s, v}
  ret=title.gsub('/', ' ').titleize
  LOWERCASE.each{|w| ret.gsub! Regexp.new("\\b#{ w }\\b"), w.downcase }
  ret
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/optout.json' do 
	query=<<-SQL
		select func.unidade, tot, count(*) as com_dados, 
				tot - count(*) as sem_dados, 
				(1.0*count(*)/tot)*100 as pct 
		from func, 
		(select unidade, count(*) as tot 
				from func 
				group by unidade) as tot
		where tot.unidade = func.unidade 
			and rem_mes != '' 
		group by func.unidade 
		order by pct;
	SQL

	rows=db.execute(query).each{|d|d['unidade']=format_title(d['unidade'])}
	rows.to_json
end
