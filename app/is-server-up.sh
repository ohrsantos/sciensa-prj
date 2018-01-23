#!/bin/bash
#!/bin/ksh 
#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="is-server-up"
################################################################################
VERSION="0.01a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="23-01-2018"
DATE_END="21-01-2018"
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
        echo "  -h   TCP Port, default is 3000"
}

while getopts "h:p:" arg
do
        case $arg in
            h)  
                HOST=$OPTARG
                ;;  
            p)  
                PORT=$OPTARG
                ;;  
           *)
                usage
                exit 1
                ;;
        esac
done

shift $(($OPTIND - 1))

if curl ${HOST}:${PORT}; then
   exit 0
else
   exit 1
fi
