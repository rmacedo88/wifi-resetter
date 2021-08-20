package modem_restarter

import (
	"context"
	"github.com/chromedp/cdproto/page"
	"github.com/chromedp/chromedp"
	"log"
	"time"
	"wifi-resetter/utils"
)

func RestartTpLinkModem(config *utils.Config) {

	//Configura as opções do chromedp
	opts := append(chromedp.DefaultExecAllocatorOptions[:],
		chromedp.Flag("headless", true),
		chromedp.Flag("disable-gpu", true),
		chromedp.Flag("enable-automation", true),
		chromedp.Flag("disable-extensions", true),
	)

	//Cria um contexto de execução do chrome
	allocCtx, cancel := chromedp.NewExecAllocator(context.Background(), opts...)
	defer cancel()

	//Efetua o carregamento do navegador
	ctx, cancel := chromedp.NewContext(allocCtx, chromedp.WithLogf(log.Printf))
	defer cancel()

	//Monitora a abertura de janelas nativas como window.confirm e window.alert e clicka no botão 'OK'
	chromedp.ListenTarget(ctx, func(ev interface{}) {

		if ev, ok := ev.(*page.EventJavascriptDialogOpening); ok {
			log.Println("Reiniciando o modem ao confirmar a mensagem:", ev.Message)

			//Clica no botão 'ok' da janela modal de confirmação
			go func() {
				if err := chromedp.Run(ctx, page.HandleJavaScriptDialog(true)); err != nil {
					panic(err)
				}
			}()

		}
	})

	//Efetua o scrapping para reiniciar o modem
	err := chromedp.Run(ctx,

		//Acessa o url de configuração do modem
		chromedp.Navigate(config.Modem.ConfigUrl),

		//Aguarda a página carregar...
		chromedp.WaitVisible(`iframe`),

		//Preenche o formulário de login
		chromedp.SendKeys(`userName`, config.Modem.ConfigUser, chromedp.ByID),
		chromedp.SendKeys(`pcPassword`, config.Modem.ConfigPassword, chromedp.ByID),

		//Efetua login
		chromedp.Click(`//*[@id="loginBtn"]`),

		//Aguarda o carregamento da tela de status
		chromedp.WaitVisible("wlan_con", chromedp.ByID),

		//Menu > System Tools
		chromedp.Click(`//*[@id="menu_tools"]`),

		//Menu > Reboot
		chromedp.Click(`//*[@id="menu_restart"]`),

		//Botão > Restart
		chromedp.Click(`//*[@id="button_reboot"]`),

		//Aguarda a confirmação do restarting do modem antes de encerrar o chrome
		chromedp.WaitVisible(`_gitem`, chromedp.ByID),
		chromedp.WaitVisible(`_gbar`, chromedp.ByID),

		chromedp.Stop(),
	)

	if err != nil {
		log.Println(err, "Não foi possível reiniciar o modem. O endereço", config.Modem.ConfigUrl, "está incancessível.")
		return
	}

	//Força o encerramento do chrome
	cancel()

	//Aguarda o modem retornar às operações normais após o restart
	log.Printf("Vou esperar %d minutos para tentar novamente", config.Modem.ConfigResetTimeoutMin)
	time.Sleep(time.Duration(config.Modem.ConfigResetTimeoutMin) * time.Minute)
	log.Println("SERVIÇO RESTABELECIDO")

}
