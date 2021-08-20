package main

import (
	"time"
	"wifi-resetter/internet-connection"
	"wifi-resetter/modem-restarter"
	"wifi-resetter/utils"
)

var (
	config = utils.Config{}
)

func main() {

	config.Parse()

	for {

		if internet_connection.PingConnection(&config) == nil {
			modem_restarter.RestartTpLinkModem(&config)
		}

		time.Sleep(time.Duration(config.Application.ConfigTestTimeoutSec) * time.Second)
	}

}
