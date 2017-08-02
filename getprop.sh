config=$1
key=$2

cat $config | while read l
do
    k=`echo $l | awk '{print $1}'`
    v=`echo $l | awk '{print $2}'`
    if [ "$key" == "$k" ] ; then
        echo $v
        break;
    fi
done
