#!/bin/bash
###

if [[ ${BASH_VERSION:0:1} < 4 ]] ; then
	echo "The script will not run in older versions of bash. Please, update bash to v4."
	exit
fi


read -e -p "Enter DNS Domain (this will also be the KDC Realm name, in all caps): " -i "example.com" NAME
read -e -p "Enter KDC & Admin server FQDN: " -i "kdc" IP

SUBDOMENNAME=$(echo $_SUBDOMENNAME| tr '[:upper:]' '[:lower:]')
NAMELOWER=$(echo $NAME| tr '[:upper:]' '[:lower:]')
NAMEUPPER=$(echo $NAME| tr '[:lower:]' '[:upper:]')
address=$(echo $IP)

echo
echo "Realm:            $NAMEUPPER"
echo "Address:          $NAMELOWER"
echo "KDC:              $address"
echo "Admin server:     $address"
echo

read -s -e -p "Enter password for cloudera/admin KDC principal: " ROOTKDCPASS
echo
#read -e -p "Enter name for normal KDC principal: " TESTUSERNAME
#read -s -e -p "Enter password for $TESTUSERNAME: " TESTUSERPASS
echo

###


function installKRBSERVLIB {
	echo
	echo "Installing krb5-server, krb5-libs, krb5-workstation..."
	yum -y install krb5-server krb5-libs krb5-workstation
}

installKRBSERVLIB

###

echo
echo "Configuring Kerberos KDC"

# In parameters: $1 -- NAMEUPPER, $2 -- NAMELOWER, $3 -- IP
function krbconf {
cat << EOF
[libdefaults]
    default_realm = $1
    dns_lookup_realm = false
    dns_lookup_kdc = false
    ticket_lifetime = 24h
    forwardable = true
    udp_preference_limit = 1000000
    default_tkt_enctypes = des-cbc-md5 des-cbc-crc des3-cbc-sha1
    default_tgs_enctypes = des-cbc-md5 des-cbc-crc des3-cbc-sha1
    permitted_enctypes = des-cbc-md5 des-cbc-crc des3-cbc-sha1

[realms]
    $1 = {
        kdc = $address:88
        admin_server = $address:749
        default_domain = $2
    }

[domain_realm]
    .$2 = $1
     $2 = $1

[logging]
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmin.log
    default = FILE:/var/log/krb5lib.log
EOF
}

krbconf $NAMEUPPER $NAMELOWER $SUBDOMENNAME > /etc/krb5.conf

# In parameter: $1 -- NAMEUPPER
function kdcconf {
cat << EOF
default_realm = $1

[kdcdefaults]
    v4_mode = nopreauth
    kdc_ports = 0
    kdc_tcp_ports = 88
[realms]
    $1 = {
        kdc_ports = 88
        admin_keytab = /etc/kadm5.keytab
        database_name = /var/kerberos/krb5kdc/principal
        acl_file = /var/kerberos/krb5kdc/kadm5.acl
        key_stash_file = /var/kerberos/krb5kdc/stash
        max_life = 10h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = des3-hmac-sha1
        supported_enctypes = arcfour-hmac:normal des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm des:afs3
        default_principal_flags = +preauth
    }
EOF
}

kdcconf $NAMEUPPER > /var/kerberos/krb5kdc/kdc.conf

# In parameter: $1 -- NAMEUPPER
function kadm {
cat << EOF
*/admin@$1    *
EOF
}

kadm $NAMEUPPER > /var/kerberos/krb5kdc/kadm5.acl

###


echo
echo "Creating database... (this may take a couple of minutes)"
echo "After it's finished, you will need to give it a new password"

kdb5_util create -r $NAMEUPPER -s

###

echo
echo "Creating root/admin principal and $TESTUSERNAME principal"

#echo "add_principal -pw $ROOTPASS root/admin" | kadmin.local > /dev/null
#kadmin.local -q "addprinc -pw $ROOTPASS cloudera/admin"
#echo "add_principal -pw $TESTUSERPASS $TESTUSERNAME" | kadmin.local > /dev/null

echo "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/admin" | kadmin.local > /dev/null
echo "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/changepw" | kadmin.local > /dev/null

###

echo
echo "Starting KDC & admin daemons"

# CentOS 7
systemctl start krb5kdc.service
systemctl start kadmin.service
systemctl enable krb5kdc.service
systemctl enable kadmin.service

# CentOS 6
/sbin/service krb5kdc start
/sbin/service kadmin start
echo "NEED TO SET UP TO START AUTOMATICALLY ON BOOT!"

###

echo "Creating cloudera admin principal"
kadmin.local -q "addprinc -pw $ROOTPASS cloudera/admin"

echo
echo "Creating principal for KDC server"

echo "add_principal -randkey host/kdc.$NAMELOWER" | kadmin.local > /dev/null
echo "ktadd host/kdc.$NAMELOWER" | kadmin.local > /dev/null

###

echo
echo "Finished setting up Kerberos KDC! Default realm is $NAMEUPPER."
