nohup /usr/bin/traefik $@ > /data/traefik.log 2>&1 &   
/usr/bin/happynet \
-a $HAPPYNET_A \
-c $HAPPYNET_C \
-k $HAPPYNET_K \
-l $HAPPYNET_L -f