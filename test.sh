#!/bin/bash

wget https://raw.githubusercontent.com/GreatMedivack/files/master/list.out
DATE=`date '+%d_%m_%Y'`;
touch SERVER_$DATE\_failed.out
touch SERVER_$DATE\_running.out
touch SERVER_$DATE\_report.out
FAIL=./SERVER_$DATE\_failed.out
RUNN=./SERVER_$DATE\_running.out
REP=./SERVER_$DATE\_report.out
ARCHV=./SERVER_$DATE.tar
name="$(whoami)"
awk '{if ($3 == "CrashLoopBackOff" || $3 == "Error") print $1 > 1}' list.out; cat 1  > $FAIL
awk '{if ($3 == "Running") print $1 > 1}' list.out; cat 1 > $RUNN
rm -rf 1
cat $RUNN | rev > revout.out
for line in $(cat revout.out); do
  if [[ ${line:(16):1} == "-" ]]; 
      then (echo $line | sed -r 's/^.{17}//') >> good.out
  elif [[ ${line:15:1} == "-" ]];
        then (echo $line | sed -r 's/^.{16}//') >> good.out
  else
      echo $line >> good.out
  fi
done
cat good.out | rev > $RUNN
rm -rf good.out
cat $FAIL | rev > revout.out
for line in $(cat revout.out); do
  if [[ ${line:(16):1} == "-" ]];
      then (echo $line | sed -r 's/^.{17}//') >> good.out
  elif [[ ${line:15:1} == "-" ]];
        then (echo $line | sed -r 's/^.{16}//') >> good.out
  else
      echo $line >> good.out
  fi
done
cat good.out | rev > $FAIL
rm -rf good.out
rm -rf revout.out 
failrep=$(wc -l $FAIL | awk '{print $1}')
echo "Количество сервисов c ошибками:" $failrep >> $REP 
runrep=$(wc -l $RUNN | awk '{print $1}')
echo "Количество работающих сервисов:" $runrep >> $REP
name="$(whoami)"
echo "User запустивший скрипт" $name >> $REP ; echo "Дата:" $DATE >> $REP
[ ! -d ./archives ] && mkdir -p ./archives
tar -cf $ARCHV $FAIL $RUNN $REP
rsync $ARCHV ./archives/
find  ./ -maxdepth 1 -name "*.out" -delete
find ./ -maxdepth 1 -name "*.tar" -delete
if [ -e ./archives/SERVER_$DATE.tar ];
then echo "The script finished YES";
else echo "The script finished NO"; fi

