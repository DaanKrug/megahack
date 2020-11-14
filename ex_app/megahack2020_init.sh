#!/bin/bash
sudo cp /var/www/html/megahack2020/ex_app/compiled_megahack2020/megahack2020_startup.sh /usr/local/bin/megahack2020_startup.sh
sudo chmod 744 /usr/local/bin/megahack2020_startup.sh
sudo chmod +x /usr/local/bin/megahack2020_startup.sh
sudo cp /var/www/html/megahack2020/ex_app/compiled_megahack2020/megahack2020_shutdown.sh /usr/local/bin/megahack2020_shutdown.sh
sudo chmod 744 /usr/local/bin/megahack2020_shutdown.sh
sudo chmod +x /usr/local/bin/megahack2020_shutdown.sh
sudo cp /var/www/html/megahack2020/ex_app/compiled_megahack2020/megahack2020.service /etc/systemd/system
sudo chmod 664 /etc/systemd/system/megahack2020.service
sudo chmod +x /etc/systemd/system/megahack2020.service
sudo systemctl daemon-reload
sudo systemctl enable megahack2020.service
sudo systemctl restart megahack2020.service