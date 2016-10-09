!/usr/local/bin/bash
#A bash script to reset a Windows Admin account through Cygwin
#Created by Tad


MACHINE=$1

echo Grabbing Port details
GRABHEX=$(ssh root@$MACHINE /cygdrive/c/cygwin/bin/bash  << EOT
  reg query 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' /f "PortNumber" | grep PortNumber | sed -e 's/^\s*//' -e '/^$/d' | sed -e 's/\<PortNumber\>//g;s/\<REG\_\DWORD\>//g;s/^[        \t]*//'
EOT
)
SUFFIX=$(ssh root@$MACHINE /cygdrive/c/cygwin/bin/bash  << EOT
  reg query 'HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' /f "NV Domain" | grep 'Domain    REG_SZ' | sed -e 's/^\s*//' -e '/^$/d' | sed -e 's/\<NV Domain\>//g;s/\<REG\_\SZ\>//g;s/^[        \t]*//'
EOT
)

CONVPORT='convert_hex.sh'
PRINT="$($CONVPORT $GRABHEX)"

NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

ssh $MACHINE "net user administrator $NEW_UUID"

echo Machine : $MACHINE
echo Port is $PRINT
echo Password is $NEW_UUID

