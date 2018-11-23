THIS=$(cd ${0%/*} && echo $PWD/${0##*/})

BASEDIR=`dirname ${THIS}`
BASEDIR=`dirname ${BASEDIR}`

for f in $(find $BASEDIR/lib/*.jar -type f)
do
  CP=${CP}:${f}
done

for f in $(find $BASEDIR/lib/thirdparty -type f)
do
  CP=${CP}:${f}
done

# echo "JAVA classpath:  ${CP}"

JAVA=`which java`
$JAVA -version 2>&1 > /dev/null
if [ $? != 0 ]; then
  PATH=${JAVA_HOME}/bin:${PATH}
  JAVA=${JAVA_HOME}/bin/java
fi

JAVA_OPTS="$JAVA_OPTS $JAVA_DEBUG_OPTS"

MAIN_CLASS=org.commonjava.auditquery.boot.Main

"$JAVA" ${JAVA_OPTS} -cp "${CP}" -Daq.home="${BASEDIR}" ${MAIN_CLASS} "$@"
ret=$?
if [ $ret == 0 -o $ret == 130 ]; then
  exit 0
else
  exit $ret
fi