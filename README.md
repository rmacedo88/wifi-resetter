# wifi-resetter

> Reinicia o modem TPLink TD-W9970 quando a 'internet cai'

Efetua ping continuamente em um ip provido pelo usuário, caso haja alguma falha de conexão, reinicia o modem.

> Esta ferramenta _*DEVE*_ executar em um aparelho conectado ao modem via cabo RJ45.
> Quando o modem "trava" a rede wifi não fica disponível.

> O scrapping na interface de administração do roteador, depende do **Google Chrome**.
> Certifique-se que este esteja instalado.

## Download

...

## Configuração

É necessário criar um arquivo chamado **config.json** no mesmo diretório em que o executável estiver. ex.:

```
├── <diretório de execução do programa>
│   ├── config.json                                <- arquivo de configuração
│   ├── wifi_resetter_<windows/linux/darwin>_amd64 <- executável

```

#### Conteúdo de config.json

```json
{
	"application": {
		"config-url-test-ip": "1.1.1.1",
		"config-url-test-port": 80,
		"config-test-timeout-sec": 5,
		"config-logging": true
	},
	"modem": {
		"config-url": "http://192.168.25.1/",
		"config-user": "admin",
		"config-password": "senha_admin",
		"config-reset-timeout-min": 10
	}
}
```

Onde:

> ###### Configurações da aplicação
> **config-url-test-ip**: IP para o qual a aplicação vai efetuar os pigs. recomendo 1.1.1.1, 8.8.4.4 e 8.8.8.8. São extremamente estáveis e praticamente não tem latência<br>
> **config-url-test-port** : Porta requerida pelo ip informado no campo supracitado. Nos exemplos recomendados o valor é 80.<br>
> **config-test-timeout-sec**: Intervalo (em segundos) para efetuar os pings <br>
> **config-logging** : Habilitar ou desabilitar completamente a impressão de logs no terminal<br>
> ###### Configurações de acesso ao modem
> **config-url**: IP para a tela de administração do roteador<br>
> **config-user**: Usuário administrador do seu modem<br>
> **config-url**: Senha<br>
> **config-url**: Intervalo (em minutos) para que o sistema volte a efetuar pings <br>

## Considerações:

Esta ferramenta é livre para utilização como base para o scrapping de outros roteadores/modems desde que o código fonte
da aplicação resultante esteja disponível para consulta e preferencialmente, para compilação local pelo usuário. 

Contribuiçãoes são bem vindas
