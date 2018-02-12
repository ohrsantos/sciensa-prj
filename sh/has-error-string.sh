#!/bin/ksh 
#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="has-error-string"
################################################################################
VERSION="0.021a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="31-01-2018"
DATE_END="31-01-2018"
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

if curl ${HOST}:${PORT} 2> /dev/null | grep -i error ; then
   exit 1 # to signal build to fail
else
   exit 0 #otherwise, success!
fi
