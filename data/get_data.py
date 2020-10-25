import requests
import zipfile
from bs4 import BeautifulSoup
import codecs


# Getting data from Loterias Caixa and saving files
# # URL of the file containing the data we need
downloadMega = 'http://www1.caixa.gov.br/loterias/_arquivos/loterias/D_mgsasc.zip'
downloadLoto = 'http://www1.caixa.gov.br/loterias/_arquivos/loterias/D_lotfac.zip'

rMega = requests.get(downloadMega, allow_redirects=True)
rLoto = requests.get(downloadLoto, allow_redirects=True)

open('mega.zip', 'wb').write(rMega.content)
open('loto.zip', 'wb').write(rLoto.content)

# Unzip these files
with zipfile.ZipFile('mega.zip', 'r') as zip_ref:
    zip_ref.extractall('./unziped_files/mega')

with zipfile.ZipFile('loto.zip', 'r') as zip_ref:
    zip_ref.extractall('./unziped_files/loto')

# Creates BeatifulSoup object for Web Crawling
soupLoto = BeautifulSoup(codecs.open(
    './unziped_files/loto/d_lotfac.htm', "r", "latin1"), 'html.parser')
soupMega = BeautifulSoup(codecs.open(
    './unziped_files/mega/d_megasc.htm', "r", "latin1"), 'html.parser')


# Find all "td" tags
extractionLoto = soupLoto.find_all('td')
extractionMega = soupMega.find_all('td')


# Dictionaries that contain the data
concursoLoto = []
sorteioLoto = []
concursoMega = []
sorteioMega = []

# Variables
dataInicio = ''


# Converts a "money string" to float
def toFloat(string):
    aux = string.split(',', 1)
    return (float(aux[0].replace('.', '')) + (float(aux[1])/100))



# ================================== Lotofácil ==================================
# Starts from "Concurso 429" ~ because some data is missing before it
# # Data: 25/05/2009 - Index: 16823
for idx, extract in enumerate(extractionLoto):
    if idx >= 16822:
        # First elem treatment
        if idx == 16823:
            dataInicio = '21/05/2009'
            concursoLoto.append({'id_concurso': int(extractionLoto[idx-1].text), 
                  'dataInicio': dataInicio,
                  'dataFim': extractionLoto[idx].text,
                  'arrecadacaoTotal': toFloat(extractionLoto[idx+16].text),
                  'valorDoPremio': toFloat(extractionLoto[idx+30].text),
                  'id_tipo': 1,
                  'id_sort': 1,
                  'ganhadores15': int(extractionLoto[idx+17].text),
                  'ganhadores14': int(extractionLoto[idx+20].text),
                  'ganhadores13': int(extractionLoto[idx+21].text),
                  'ganhadores12': int(extractionLoto[idx+22].text),
                  'ganhadores11': int(extractionLoto[idx+23].text)
                  })
            sorteioLoto.append({'concursoPremiado': int(extractionLoto[idx-1].text),
                                'bola1': int(extractionLoto[idx+1].text),
                                'bola2': int(extractionLoto[idx+2].text),
                                'bola3': int(extractionLoto[idx+3].text),
                                'bola4': int(extractionLoto[idx+4].text),
                                'bola5': int(extractionLoto[idx+5].text),
                                'bola6': int(extractionLoto[idx+6].text),
                                'bola7': int(extractionLoto[idx+7].text),
                                'bola8': int(extractionLoto[idx+8].text),
                                'bola9': int(extractionLoto[idx+9].text),
                                'bola10': int(extractionLoto[idx+10].text),
                                'bola11': int(extractionLoto[idx+11].text),
                                'bola12': int(extractionLoto[idx+12].text),
                                'bola13': int(extractionLoto[idx+13].text),
                                'bola14': int(extractionLoto[idx+14].text),
                                'bola15': int(extractionLoto[idx+15].text)
                                })
            # Update the variable
            dataInicio = extractionLoto[idx].text
        else:
            # Strategy to discover the "Concurso"
            if extract.text.__contains__('/'):
                # print('Data: ' + extract.text + ' - Index: ' + str(idx))    # Verification
                concursoLoto.append({'id_concurso': int(extractionLoto[idx-1].text), 
                      'dataInicio': dataInicio,
                      'dataFim': extractionLoto[idx].text,
                      'arrecadacaoTotal': toFloat(extractionLoto[idx+16].text),
                      'valorDoPremio': toFloat(extractionLoto[idx+30].text),
                      'id_tipo': 1,
                      'id_sort': int(extractionLoto[idx-1].text),
                      'ganhadores15': int(extractionLoto[idx+17].text),
                      'ganhadores14': int(extractionLoto[idx+20].text),
                      'ganhadores13': int(extractionLoto[idx+21].text),
                      'ganhadores12': int(extractionLoto[idx+22].text),
                      'ganhadores11': int(extractionLoto[idx+23].text)
                      })
                sorteioLoto.append({'concursoPremiado': int(extractionLoto[idx-1].text),
                                    'bola1': int(extractionLoto[idx+1].text),
                                    'bola2': int(extractionLoto[idx+2].text),
                                    'bola3': int(extractionLoto[idx+3].text),
                                    'bola4': int(extractionLoto[idx+4].text),
                                    'bola5': int(extractionLoto[idx+5].text),
                                    'bola6': int(extractionLoto[idx+6].text),
                                    'bola7': int(extractionLoto[idx+7].text),
                                    'bola8': int(extractionLoto[idx+8].text),
                                    'bola9': int(extractionLoto[idx+9].text),
                                    'bola10': int(extractionLoto[idx+10].text),
                                    'bola11': int(extractionLoto[idx+11].text),
                                    'bola12': int(extractionLoto[idx+12].text),
                                    'bola13': int(extractionLoto[idx+13].text),
                                    'bola14': int(extractionLoto[idx+14].text),
                                    'bola15': int(extractionLoto[idx+15].text)
                                    })
                
                # Update the variable
                dataInicio = extractionLoto[idx].text
    



# Converts "SIM" and "NÃO", to 1 or 0
def toBool(string):
    if string == 'SIM':
        return 1
    else:
        return 0


# ================================== Megasena ==================================
# Starts from "Concurso 1077" ~ because some data is missing before it
# # Data: 27/05/2009 - Index: 22765
for idx, extract in enumerate(extractionMega):
    if idx >= 22765:
        # First elem treatment
        if idx == 22765:
            dataInicio = '23/05/2009'
            concursoMega.append({'id_concurso': int(extractionMega[idx-1].text), 
                  'dataInicio': dataInicio,
                  'dataFim': extractionMega[idx].text,
                  'arrecadacaoTotal': toFloat(extractionMega[idx+7].text),
                  'valorDoPremio': toFloat(extractionMega[idx+18].text),
                  'id_tipo': 2,
                  'id_sort': int(extractionMega[idx-1].text),
                  'acumulado': toBool(extractionMega[idx+16].text),
                  'somadorMegaDaVirada': toFloat(extractionMega[idx+19].text),
                  'ganhadores6': int(extractionMega[idx+8].text),
                  'ganhadores5': int(extractionMega[idx+12].text),
                  'ganhadores4': int(extractionMega[idx+14].text)
                  })
            sorteioMega.append({'concursoPremiado': int(extractionMega[idx-1].text),
                                'bola1': int(extractionMega[idx+1].text),
                                'bola2': int(extractionMega[idx+2].text),
                                'bola3': int(extractionMega[idx+3].text),
                                'bola4': int(extractionMega[idx+4].text),
                                'bola5': int(extractionMega[idx+5].text),
                                'bola6': int(extractionMega[idx+6].text)
                                })
            
            # Update the variable
            dataInicio = extractionMega[idx].text
        else:
            # Strategy to discover the "Concurso"
            if extract.text.__contains__('/'):
                # print('Data: ' + extract.text + ' - Index: ' + str(idx))    # Verification
                concursoMega.append({'id_concurso': int(extractionMega[idx-1].text), 
                      'dataInicio': dataInicio,
                      'dataFim': extractionMega[idx].text,
                      'arrecadacaoTotal': toFloat(extractionMega[idx+7].text),
                      'valorDoPremio': toFloat(extractionMega[idx+18].text),
                      'id_tipo': 2,
                      'id_sort': int(extractionMega[idx-1].text),
                      'acumulado': toBool(extractionMega[idx+16].text),
                      'somadorMegaDaVirada': toFloat(extractionMega[idx+19].text),
                      'ganhadores6': int(extractionMega[idx+8].text),
                      'ganhadores5': int(extractionMega[idx+12].text),
                      'ganhadores4': int(extractionMega[idx+14].text)
                      })
                sorteioMega.append({'concursoPremiado': int(extractionMega[idx-1].text),
                                    'bola1': int(extractionMega[idx+1].text),
                                    'bola2': int(extractionMega[idx+2].text),
                                    'bola3': int(extractionMega[idx+3].text),
                                    'bola4': int(extractionMega[idx+4].text),
                                    'bola5': int(extractionMega[idx+5].text),
                                    'bola6': int(extractionMega[idx+6].text)
                                    })
                # Update the variable
                dataInicio = extractionMega[idx].text

