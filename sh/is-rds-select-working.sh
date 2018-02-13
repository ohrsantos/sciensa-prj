#!/bin/ksh 
#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="is-rds-select-working"
################################################################################
VERSION="0.001a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="13-02-2018"
DATE_END="13-02-2018"
################################################################################
#Changes:
#

# 172.17.0.1 for container use only

HOST=127.0.0.1
PORT=3000

usage(){
        echo $SCRIPT_NAME
        echo "Usage: $SCRIPT_NAME.sh [-h host] [-p port]"
        echo "  -h   Host name, default is 127.0.0.1"
        echo "  -p   TCP Port, default is 3000"
        echo "  -D   Host name, default is 172.17.0.1 for docker host use"
}

while getopts "h:p:D" arg
do
        case $arg in
            h)  
                HOST=$OPTARG
                ;;  
            p)  
                PORT=$OPTARG
                ;;  
            D)  
                HOST=172.17.0.1
                ;; 
           *)
                usage
                exit 1
                ;;
        esac
done

shift $(($OPTIND - 1))

if curl ${HOST}:${PORT}/proverbios 2> /dev/null | grep 'Whether you think you can or you think you can' ; then
   exit 0 #otherwise, success!
else
   exit 1 # to signal build to fail
fi
