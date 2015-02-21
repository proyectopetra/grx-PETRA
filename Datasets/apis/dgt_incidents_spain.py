import requests
from bs4 import BeautifulSoup

source_code = requests.get('http://infocar.dgt.es/etraffic/Incidencias?caracter=acontecimiento&orden=fechahora_ini%20DESC&IncidenciasOTROS=IncidenciasOTROS&IncidenciasEVENTOS=IncidenciasEVENTOS&IncidenciasRETENCION=IncidenciasRETENCION&IncidenciasPUERTOS=IncidenciasPUERTOS&IncidenciasMETEOROLOGICA=IncidenciasMETEOROLOGICA').text
soup = BeautifulSoup(source_code)

def encode(st):
    if st: 
        return st.encode('utf8').replace("\n","")
    else: 
        return ""

incidents = soup.find_all('td')

for i in range(0,100,6):
    # Scrapping
    inicio = incidents[i+0].find('span').string
    fin = incidents[1].find('span').string
    tipo = incidents[i+2].find('img').get('title')
    provincia = incidents[i+3].find('b').string
    poblacion = incidents[i+3].contents[2]
    
    # None values, encoding
    inicio    = encode(inicio)
    fin       = encode(fin)
    tipo      = encode(tipo)
    provincia = encode(provincia)
    poblacion = encode(poblacion)
    
    print([inicio,fin,tipo,provincia,poblacion])
