#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="is-server-up"
################################################################################
VERSION="0.02a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="23-01-2018"
DATE_END="03-02-2018"
################################################################################
#Changes:
#

# 172.17.0.1 for container use only

HOST=127.0.0.1
PORT=3000

usage(){
        echo $SCRIPT_NAME
        echo "Usage: $SCRIPT_NAME.sh [-h host] [-p port] [-D]"
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
            h)  
                HOST=172.17.0.1
                ;;  
           *)
                usage
                exit 1
                ;;
        esac
done

shift $(($OPTIND - 1))

if curl ${HOST}:${PORT} >/dev/null 2>&1; then
   exit 0
else
   exit 1
fi
