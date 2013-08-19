import sqlite3 as sqlite

def main():
  conn=sqlite.connect('gerado/RelatorioServidores.db')
  c=conn.cursor()
  c.execute("""create table func(nome text, status text,  cargo_base text, 
      cargo_comissao text, rem_mes number, rem_elem number, 
      rem_bruta number, unidade text, end text, 
      complemento text, jornada text)""")
  with open('gerado/RelatorioServidores.csv') as f:
    # discard header
    f.readline()
    insert="insert into func values(%s)" % ','.join(['?']*11)
    for line in f.readlines():
      content=line.decode('utf_8').strip().split(';')
      # print insert
      c.execute(insert, content)
  
  conn.commit()
if __name__=="__main__":
  main()
