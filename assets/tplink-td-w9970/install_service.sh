#!/bin/sh

chmod +x /opt/app/tpl-td-w9970/tpl-td-w9970.service.sh
chmod +x /opt/app/tpl-td-w9970/wifi_resetter

echo "ATUALIZANDO O SERVICO\n"

sudo cp /opt/app/tpl-td-w9970/tpl-td-w9970.service \
  /etc/systemd/system/tpl-td-w9970.service

echo "REINICIANDO O DAEMON DO SYSTEMD"

sudo systemctl daemon-reload

echo "TERMINANDO O SERVICO EM EXECUCAO\n"

sudo service tpl-td-w9970 stop

echo "REINICIANDO O SERVICO\n"

sudo service tpl-td-w9970 start

echo "VERIFIQUE O STATUS DO SERVICO COM: \nadb shell sudo service tpl-td-w9970 status\n"
