#!/bin/bash
APPLICATION="content-sync"

# CLUSTER: optional environment variable set in Task Definition
if [ -n "$CLUSTER" ]; then
 SECRETS_COMMAND="tinyawscli secrets -e $SECRETS_ENV -a $APPLICATION -c $CLUSTER --shared"
else
 SECRETS_COMMAND="tinyawscli secrets -e $SECRETS_ENV -a $APPLICATION --shared"
fi

case "$1" in
 web)
 $SECRETS_COMMAND &&\
 source .secrets &&\
 rm -f .secrets

 # IMDSv2 needs the token
 TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
 IP_ADDRESS=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

 if [[ $SPRING_PROFILES_ACTIVE == *"production"* ]]; then
 JVM_MEM_MIN="Xms2G"
 JVM_MEM_MAX="Xmx2G"
 VAR_ENV_SHORT="prod"
 elif [[ $SPRING_PROFILES_ACTIVE == *"uat"* ]]; then
 JVM_MEM_MIN="Xms2G"
 JVM_MEM_MAX="Xmx2G"
 VAR_ENV_SHORT="uat"
 elif [[ $SPRING_PROFILES_ACTIVE == *"staging"* ]]; then
 JVM_MEM_MIN="Xms1G"
 JVM_MEM_MAX="Xmx1G"
 VAR_ENV_SHORT="stg"
 elif [[ $SPRING_PROFILES_ACTIVE == *"development"* ]]; then
 JVM_MEM_MIN="Xms1G"
 JVM_MEM_MAX="Xmx1G"
 VAR_ENV_SHORT="dev"
 else
 JVM_MEM_MIN="Xms1G"
 JVM_MEM_MAX="Xmx1G"
 VAR_ENV_SHORT="local"
 fi

 # Enable New Relic
 JAVA_OPTS="-Dnewrelic.config.file=/newrelic/newrelic.yml -javaagent:/newrelic/newrelic.jar"

 # Memory usage
 JAVA_OPTS="$JAVA_OPTS -$JVM_MEM_MIN -$JVM_MEM_MAX"

 # Options for ps admin
 JAVA_OPTS="$JAVA_OPTS -Dip.address.ipv4=${IP_ADDRESS}"

 # GC and logs
 JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC -XX:+UseStringDeduplication -Xlog:gc*:file=/app/log/gc.log::filecount=10,filesize=10M:utctime,hostname,pid,uptime,level,tags -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/app/log/java_pid%p.hprof -XX:ErrorFile=/app/log/java_error%p.log"

 # SecureRandom
 JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"

 # Kafka variable
 JAVA_OPTS="$JAVA_OPTS -DVAR_ENV_SHORT=${VAR_ENV_SHORT}"

 exec java $JAVA_OPTS -jar ./app.jar
 ;;
 pause)
 tail -f /dev/null
 ;;
 *)
 echo "Please pass in an argument"
 exit 1
esac