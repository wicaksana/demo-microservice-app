#/bin/sh
set +x

APP_URL="https://demo-app.wicaksana.uk"
echo $APP_URL
for i in `seq 1 10`; do echo -n "$i. " && curl -sk "$APP_URL/canary1" | grep 'Web App Microservice Status' |  sed 's/.*>\([^<]*\)<\/h1>/\1/'; done

