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
soupMega = BeautifulSoup(codecs.open(
    './unziped_files/mega/d_megasc.htm', "r", "latin1"), 'html.parser')
soupLoto = BeautifulSoup(codecs.open(
    './unziped_files/loto/d_lotfac.htm', "r", "latin1"), 'html.parser')

# Test
extractionLoto = soupLoto.find_all('tr')
for extract in extractionLoto[:10]:
    print(extract)
