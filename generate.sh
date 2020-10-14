#!/bin/bash
#Downloads the config file for the client.

eval `echo "${QUERY_STRING}"|tr '&' ';'`
client=$(echo $client | tr -d '\r')

newclient () {
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt /etc/openvpn/clients/$1.ovpn
	echo "<ca>" >> /etc/openvpn/clients/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> /etc/openvpn/clients/$1.ovpn
	echo "</ca>" >> /etc/openvpn/clients/$1.ovpn
	echo "<cert>" >> /etc/openvpn/clients/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> /etc/openvpn/clients/$1.ovpn
	echo "</cert>" >> /etc/openvpn/clients/$1.ovpn
	echo "<key>" >> /etc/openvpn/clients/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> /etc/openvpn/clients/$1.ovpn
	echo "</key>" >> /etc/openvpn/clients/$1.ovpn
	echo "<tls-auth>" >> /etc/openvpn/clients/$1.ovpn
	cat /etc/openvpn/ta.key >> /etc/openvpn/clients/$1.ovpn
	echo "</tls-auth>" >> /etc/openvpn/clients/$1.ovpn
}

cd /etc/openvpn/easy-rsa/

./easyrsa build-client-full $client nopass
# Generates the custom client.ovpn
newclient "$client"

echo "Content-type: text/plain"
echo "Content-Disposition: attachment; filename=\"$client.ovpn\""
echo ""
while read c; do
	echo $c
done </etc/openvpn/clients/$client.ovpn
exit 0
