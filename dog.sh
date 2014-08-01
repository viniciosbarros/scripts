#!/bin/bash
#
#
#       Identificar Acesso SSH
#       watch for ssh break-in
#
#
ID=0
MACHINE=""
SSHDACK=""
LAST=""
LAAST=""
IP=""

#while [ 1 ]
#do
        MACHINE=`tail  /var/log/auth.log | grep "POSSIBLE BREAK-IN ATTEMPT" | awk '/sshd/ { print $11 } '`
        IP=`tail  /var/log/auth.log | grep "POSSIBLE BREAK-IN ATTEMPT" | awk '/sshd/ { print $12 } '`
        SSHDACK=`tail -n1  /var/log/auth.log | grep "ssh" | awk '/sshd/ { print $3 }'`

        if [ ! -z $MACHINE ]
        then
                if [ "$IP" != "$LAAST" ]; then
                xmessage -center -print "break-in-warning ACESSO SSH IDENTIFICADO IP: $IP MAQUINA: $MACHINE ID: $ID" &
                LAAST=$IP
                ID=$(( $ID + 1 ))
                fi
        fi

        if [ ! -z $SSHDACK ]
        then
                if [ "$SSHDACK" != "$LAST" ]; then
                  if [ ! -e /tmp/ssh_lock_show ];then
                  touch /tmp/ssh_lock_show
                  xmessage -center -print "TENTATIVA DE ACESSO SSH IDENTIFICADO Hora: [ $SSHDACK ]" &
                  LAST=$SSHDACK
                  sleep 5
                  /bin/rm /tmp/ssh_lock_show
                  fi
                  LAST=$SSHDACK
                  sleep 1
                fi
        fi
#sleep 2
#done


#echo -e " \033[41;1;37m ALGUM ACESSO SSH IDENTIFICADO \033[0m"
#echo -e " \033[41;1;37m CONTROLE [ $SSHDACK ] \033[0m"
#echo $SSHDACK $LAST
