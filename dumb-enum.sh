#!/bin/bash
# colors
green=$(tput -T xterm setaf 2)
red=$(tput -T xterm setaf 1)
reset=$(tput sgr0)

echo $red && cat <<EOF
D)dddd                      b)         E)eeeeee
D)   dd                     b)         E)
D)    dd u)   UU  m)MM MMM  b)BBBB     E)eeeee  n)NNNN  u)   UU  m)MM MMM
D)    dd u)   UU m)  MM  MM b)   BB    E)       n)   NN u)   UU m)  MM  MM
D)    dd u)   UU m)  MM  MM b)   BB    E)       n)   NN u)   UU m)  MM  MM
D)ddddd   u)UUU  m)      MM b)BBBB     E)eeeeee n)   NN  u)UUU  m)      MM
EOF
# checks
echo $green && echo '## SUID // SGID ##'
echo $reset

check_find=$(which find)
if [ -z "$check_find" ]; then
echo 'Find Not installed using other <SUID/SGID> methods...'
        ls -al /*/*/* 2>/dev/null |grep rws
else
        find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null
fi

echo $green && echo '## File Caps ##'
echo $reset

        getcap -r / 2>/dev/null

echo $green && echo '## Active Processes ##'
echo $reset

        ps aux | grep root && echo ''
        ps -ef --forest

echo $green && echo '## Linux Sockets ##'

check_netstat=$(which netstat)
check_ss=$(which ss)

if [ -z "$check_ss" ]; then
echo "ss not found trying netstat..."
        netstat -antup && netstat -tulpn
elif [ -z "$check_netstat"]; then
        echo "netstat is also not found no socket info..."
else
        ss -tulpn
fi
echo $green && echo "## Enumerating DNS..."
echo $reset
echo "## Checking hosts file for adresses...."
echo $green && echo "Full host list below..."
echo $reset
cat /etc/hosts | grep -v 127.*


echo $green && echo "## Checking for local 192. DNS addresses"
echo $reset
echo $red && cat /etc/hosts | grep 192.*

echo $green && echo '## Crontab ##\n'
echo $reset

        cat /etc/crontab
        ls -al /etc/cron.d/

echo $green && echo '## Readable // Writable Files ##'
echo $reset

check_find=$(which find)
if [ -z "$check_find"]; then
        echo "find command is not installed. running through simple checks"
        ls -al /etc/passwd
        ls -al /etc/shadow
        ls -al /etc/crontab
else
        find / -writable 2>/dev/null
        find / -type f -name *.txt 2>/dev/null
fi
echo $green && echo '## Commond log/history files ##'
echo $reset

        find /home/ -name *.*history* -print -exec 'cat' {} \; 2>/dev/null

echo $green && echo '## files that may contain plain text creds you never think of ##'
echo $reset

        cat /etc/fstab

echo $green && echo '## Hidden Files ##'
echo $reset

check_find=$(which find)
if [ -z "$check_find" ]; then
echo 'Find Not installed using other <Hidden-File> methods...'
        ls -alR  2>/dev/null| grep "^." 2>/dev/null
        echo ""
        du -a / 2>/dev/null| grep "^." | awk '{print $2}' 
else
        find / -type f -name '.*' 2>/dev/null
fi

echo  $green && echo '## Stupid triple dot directories if there are any  ##'
echo $reset

        find / -type d -name '...' 2>/dev/null

echo  $green && echo "## double check opt since everyone ##"
echo $reset
        ls -al /opt
touch info.txt
#leaves just the versioning numbers
strip_ver=$(echo "${kern}" | sed 's/[^0-9.]//g' | awk '{ print substr($0,1,length($0)-3 )}')


echo $strip_ver >> info.txt


echo $green && echo "## checking kernel version for CVE-2022-0847 AKA Dirty Pipe"
#logic to check if version is vulnerable.
if grep -q "5.8.0" info.txt ;then
	echo $red && "Machine Might Be Vulnerable to Dirty Pipe" && rm info.txt;

else
	echo $green && echo "Not vulnerable to Dirty Pipe Vuln" && rm info.txt;
	echo $reset

fi

exit 
