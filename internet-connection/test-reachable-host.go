package internet_connection

import (
	"fmt"
	"log"
	"net"
	"time"
	"wifi-resetter/utils"
)

var (
	success = true
)

func PingConnection(config *utils.Config) *bool {
	timeOut := time.Duration(config.Application.ConfigTestTimeoutSec) * time.Second

	conn, err := net.DialTimeout("tcp",
		fmt.Sprintf("%s:%d",
			config.Application.ConfigUrlTestIp,
			config.Application.ConfigUrlTestPort), timeOut)

	if err != nil {
		log.Println(err, "Host não encontrado: ",
			fmt.Sprintf("%s:%d", config.Application.ConfigUrlTestIp, config.Application.ConfigUrlTestPort),
			"reiniciando modem")
		return nil
	}

	log.Printf("\n\t ip remoto : %s \n\t ip local  : %s \n\n",
		conn.RemoteAddr().String(),
		conn.LocalAddr().String())

	return &success
}
