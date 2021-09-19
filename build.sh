#!/usr/bin/env bash

echo "##### ##### ##### VERIFICANDO PRE REQUISITOS ##### ##### #####"

: '
  Checa se a ferramenta make está disponível no sistema
'
if ! make -v &>/dev/null; then
  echo "Comando make não está disponível."
  echo "Este programa possui um job de compilação contido em um Makefile, porém, este depende do comando make para ser executado."
  echo "Consulte o link para maiores detalhes https://www.gnu.org/software/make/"
  exit 1
fi

: '
  Checa se a ferramenta adb está disponível no sistema
'
if ! adb --version &>/dev/null; then
  echo "Comando adb não está disponível."
  echo "O deploy da aplicação no dispositivo depende desta ferramenta."
  echo "Consulte o link para maiores detalhes https://wiki.radxa.com/RockpiS/dev/adb"
  exit 1

  : '
  Checa se o dispositivo está conectado
'
elif [ ! "$(adb get-state)" == "device" ]; then
  echo "O seu dispositivo não está conectado."
  echo "Verifique a conexão e tente novamente."
  exit 1

  : '
  Checa se o chromium-browser está instalado no dispositivo
'
elif ! adb shell which chromium-browser &>/dev/null; then
  echo "O navegador Chromium não está instalado no dispositivo."
  echo "Consulte a documentação para obter informações sobre sistema instalado e o gestor de pacotes disponível. https://rockpi.eu/RockpiS/getting_started"
  echo "Caso tenha optado pelo ubuntu, utilize o comando $(sudo apt-get install chromium-browser) pode demorar consoante a velocidade do cartão uSD instalado."
fi

: '
  Checa se o compilador da linguagem GoLang está instalado no sistema
'
if ! go version &>/dev/null; then
  echo "Compilador GO não encontrado."
  echo "O Makefile utiliza somente instruções de compilação válidas para a distribuição padrão do Go, portanto o GCC GO não é suportado."
  echo "Consulte o link para baixar o compilador Go https://golang.org/dl/"
  exit 1
elif [ "$(go version | awk '{print $3}' | awk -F . '{print $2}')" -lt 16 ]; then
  echo "A versão mínima requerida para compilar este programa é go1.16, por favor atualize seu ambiente de desenvolvimento."
  echo "Consulte o link para baixar uma versão atualizada: https://golang.org/dl/"
  echo "Versão do compilador Go encontrada: $(go version)"
  exit 1
fi

: '
  Checa se o sistema possui o Google Chrome instalado.
   É necessaŕio pois o chromedp utiliza-o no modo headless para efetuar o scrapping da página de administração do modem.
'
#if ! google-chrome --version &>/dev/null; then
#  echo "Navegador Google Chrome não encontrado."
#  echo "A ferramenta de scrapping depende de uma instalação desse navegador e sua ausência tornam inúteis os binários compilados"
#  echo "Consulte o link para baixá-lo https://www.google.com/intl/pt-BR/chrome/"
#  exit 1
#fi

echo "##### ##### ##### PRE REQUISITOS SATISFEITOS ##### ##### #####"

echo

echo "##### ##### ##### COMPILANDO OS BINÁRIOS PARA WINDOWS, lINUX E MACOS ##### ##### #####"

: '
  Executa os jobs de compilação presentes no arquivo Makefile.
'
make "-j$(cat /proc/cpuinfo | grep siblings | awk 'NR==1 { print $NF }')" || {
  echo 'FALHA NA COMPILAÇÃO DO PROGRAMA. REVISE AS MENSAGENS DE ERRO APRESENTADAS NO TERMINAL E TENTE NOVAMENTE.'
  exit 1
}

echo "##### ##### ##### BINÁRIOS COMPILADOS ##### ##### #####"

echo

echo "##### ##### ##### LISTANDO OS ARQUIVOS COMPILADOS ##### ##### #####"

echo "Arquivos compilados no diretório: $(pwd)"
ls assets/tplink-td-w9970/ -lh

echo "##### ##### ##### DEPLOY NO DISPOSITIVO ##### ##### #####"

adb shell mkdir -p /opt/app/tpl-td-w9970
adb push $(pwd)/assets/tplink-td-w9970/* /opt/app/tpl-td-w9970/
adb shell chmod +x /opt/app/tpl-td-w9970/install_service.sh
adb shell /opt/app/tpl-td-w9970/install_service.sh

echo "##### ##### ##### TRABALHO FINALIZADO ##### ##### #####"

exit 0
