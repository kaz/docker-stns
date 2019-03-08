#!/bin/bash

cd $(dirname $0)

USERS=$(cat users | tr '\n' ' ')
USER_LIST=$(echo -n $USERS | sed 's/ /", "/g')

TMP_GENERAL='
[groups.sysad]
id = 60000
users = ["%s"]
'

TMP_USER='
[users.%s]
id = %d
group_id = %d
keys = [
%s
]

[groups.%s]
id = %d
users = ["%s"]
'

printf "$TMP_GENERAL" "$USER_LIST"

COUNT=60000
for USER in $(cat users)
do
	(( COUNT++ ))
	KEYS=$(curl https://github.com/$USER.keys | sed -e 's/^/	"/g' -e 's/$/",/g')
	printf "$TMP_USER" $USER $COUNT $COUNT "$KEYS" $USER $COUNT $USER
done
