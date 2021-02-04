#!/bin/bash

FILE=/var/run/httpd/httpd.pid
VPSERVICE=/var/run/vpservice.pid

if ! [ -f "$FILE" ]; then
# confirm Apache is down & start Apache
## mail -s 'Apache is down' ddennis@seamfix.com <<< 'Apache is down on AUTOTOPUP CLOUD SERVER and will try restarting in 10s'
sudo service httpd start
mail -s 'Apache is down' ddennis@seamfix.com <<< 'Apache is down on AUTOTOPUP CLOUD SERVER and will try restarting in 10s'
fi
sleep 10s
if ! [ -f "$FILE" ]; then
sudo service  httpd start
fi
sleep 5s

# confirm AutoTopup service is down and start the service
if ! [ -f "$VPSERVICE" ]; then
sudo service vpservice start
fi

# Restart Tomcat
sudo service vasportal start
sleep 10s

# If all does not go well, alert responsible parties
if ! [ -f "$FILE" ]; then
mail -s 'Apache is down' ddennis@seamfix.com <<< 'Apache is down on AUTOTOPUP CLOUD SERVER and cannot be restarted'
fi


## CRONJOB
#sudo crontab -e
##paste this
##  */10 11-21 * * 1-5 ~ddennis/scripts/apache-service-job.sh