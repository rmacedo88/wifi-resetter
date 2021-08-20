# wifi-resetter

> Reinicia o modem TPLink TD-W9970 quando a conexão é perdida.

Efetua ping continuamente em um ip provido pelo usuário. Caso haja alguma falha de conexão, reinicia o modem.

> Esta ferramenta _*DEVE*_ executar em um aparelho conectado ao modem via cabo RJ45.
> Quando a conexão é perdida a rede wifi não fica disponível.

> O scrapping na interface de administração do roteador, depende do **Google Chrome**.
> Certifique-se que este esteja instalado.

## Utilização

Basta baixar e editar o arquivo **config.json** bem como um executável (compatível com seu sistema operacional). Ambos
disponíveis na seção [Releases](https://github.com/rmacedo88/wifi-resetter/releases).

Nos sistemas Linux e macOs é necessário atribuir permissão de execução:

```
# Linux
chmod +x wifi_resetter_linux_amd64
# macOs
chmod +x wifi_resetter_macos_amd64
```

Uma vez que o arquivo **config.json** esteja configurado e presente no mesmo diretório que o binário baixado, basta
clicar duas vezes no binário, ou abrir um terminal ou promt de comando e executá-lo da seguinte forma:

```
# Linux
./wifi_resetter_linux_amd64
# macOs
./wifi_resetter_macos_amd64
# Windows
wifi_resetter_macos_amd64.exe
```

## Construir localmente

#### linux e macos

Para compilar localmente é estritamente necessário utilizar um sistema baseado em Linux ou macOs devido à natureza das
ferramentas utilizadas.

Em sistemas Linux ou macOs, basta atribuir permissão de execução e executar o script **build.sh** e verificar o
diretório **bin** após o término da compilação.

#### windows

Para facilitar o processo de compilação para windows, basta copiar os jobs contidos no arquivo Makefile e executar cada
um deles no promt de comando ou outro terminal.

```shell
# Compilar localmente para WINDOWS
env GOOS=windows GOARCH=amd64 \
		go build -v -o wifi_resetter_windows_amd64.exe \
		-ldflags="-s -w -X main.version=1"	\
		-gcflags '-m' \
		-tags netgo startup\\main.go

# Compilar localmente para LINUX (opcional)
env GOOS=linux GOARCH=amd64 \
		go build -v -o wifi_resetter_linux_amd64 \
		-ldflags="-s -w -X main.version=1" \
		-gcflags '-m' \
		-tags netgo startup\\main.go

# Compilar localmente para MACOS (opcional)
env GOOS=darwin GOARCH=amd64 \
		go build -v -o wifi_resetter_macos_amd64 \
		-ldflags="-s -w -X main.version=1" \
		-gcflags '-m' \
		-tags netgo startup\\main.go
```

## Configuração do config.json

Considerando que o arquivo **config.json** está no mesmo diretório que o executável baixado. ex.:

```
├── <diretório de execução do programa>
│   ├── config.json                                <- arquivo de configuração
│   ├── wifi_resetter_<windows/linux/macos>_amd64 <- executável

```

#### Conteúdo de config.json

```json
{
	"application": {
		"config-url-test-ip": "1.1.1.1",
		"config-url-test-port": 80,
		"config-test-timeout-sec": 5,
		"config-logging": false
	},
	"modem": {
		"config-url": "http://192.168.25.1/",
		"config-user": "admin",
		"config-password": "senha",
		"config-reset-timeout-min": 10
	}
}
```

Onde:

> ###### Configurações da aplicação
> **config-url-test-ip**: IP para o qual a aplicação vai efetuar os pigs. recomendo 1.1.1.1, 8.8.4.4 ou 8.8.8.8. São extremamente estáveis e praticamente não tem latência<br>
> **config-url-test-port** : Porta requerida pelo ip informado no campo supracitado. Nos exemplos recomendados o valor é 80.<br>
> **config-test-timeout-sec**: Intervalo (em segundos) para efetuar os pings <br>
> **config-logging** : Habilita ou desabilita completamente a impressão de logs no terminal<br>
> ###### Configurações de acesso ao modem
> **config-url**: IP para a página de administração do roteador<br>
> **config-user**: Usuário administrador do seu modem<br>
> **config-url**: Senha<br>
> **config-url**: Intervalo (em minutos) para que o sistema volte a efetuar pings <br>

## Considerações:

Esta ferramenta é livre para utilização como base para o scrapping de outros roteadores/modems desde que o código fonte
da aplicação resultante esteja disponível para consulta e preferencialmente, para compilação local pelo usuário.

Contribuições são bem vindas
