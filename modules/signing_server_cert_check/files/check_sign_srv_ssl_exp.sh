#!/bin/sh

SSL="https://raw.githubusercontent.com/mozilla-releng/signingscript/master/signingscript/data/host.cert"
CERT=/tmp/host.cert
CERT1=/tmp/cert.pem
CERT2=/tmp/cert1.pem
DAYS=60

/usr/bin/wget $SSL -P /tmp
CHECKSSL=/usr/local/bin/cert_check.sh

cat $CERT | awk  'split_after == 1 {n++;split_after=0}  /-----END CERTIFICATE-----/ {split_after=1}{print > "/tmp/cert" n ".pem"}'

sh $CHECKSSL -c $CERT1 -x $DAYS -ab -e relops@mozilla.com -E root@cruncher-aws.srv.releng.usw2.mozilla.com
if [ -f $CERT2 ]; then
    sh $CHECKSSL -c $CERT2 -x $DAYS -ab -e relops@mozilla.com -E root@cruncher-aws.srv.releng.usw2.mozilla.com
fi

rm -rf $CERT $CERT1 $CERT2

exit 0
