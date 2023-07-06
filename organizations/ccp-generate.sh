#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

## prepare connection profile for orgcommittee
ORG=committee
P0PORT=4444
P1PORT=4454
CAPORT=4400
PEERPEM=organizations/peerOrganizations/committee/tlsca/tlsca.committee-cert.pem
CAPEM=organizations/peerOrganizations/committee/ca/ca.committee-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/committee/connection-committee.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/committee/connection-committee.yaml
# save another copy of json connection profile in a different directory
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > network-config/network-config-committee.json

## prepare connection profile for orgvoter
ORG=voter
P0PORT=5555
P1PORT=5565
CAPORT=5500
PEERPEM=organizations/peerOrganizations/voter/tlsca/tlsca.voter-cert.pem
CAPEM=organizations/peerOrganizations/voter/ca/ca.voter-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/voter/connection-voter.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/voter/connection-voter.yaml
# save another copy of json connection profile in a different directory
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > network-config/network-config-voter.json

ORG=adminops
P0PORT=6666
P1PORT=6676
CAPORT=6600
PEERPEM=organizations/peerOrganizations/adminops/tlsca/tlsca.adminops-cert.pem
CAPEM=organizations/peerOrganizations/adminops/ca/ca.adminops-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/adminops/connection-adminops.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/adminops/connection-adminops.yaml
# save another copy of json connection profile in a different directory
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > network-config/network-config-adminops.json



