#!/bin/bash

function createcommittee() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/committee/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/committee/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:4400 --caname ca-committee --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-committee.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-committee.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-committee.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-4400-ca-committee.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/committee/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-committee --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-committee --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-committee --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-committee --id.name committeeadmin --id.secret committeeadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/msp --csr.hosts peer0.committee --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/msp --csr.hosts peer1.committee --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/committee/msp/config.yaml ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/committee/msp/config.yaml ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls --enrollment.profile tls --csr.hosts peer0.committee --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls --enrollment.profile tls --csr.hosts peer1.committee --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/signcerts/* ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/keystore/* ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/signcerts/* ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/keystore/* ${PWD}/organizations/peerOrganizations/committee/peers/peer1.committee/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/committee/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/committee/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/committee/tlsca
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/committee/tlsca/tlsca.committee-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/committee/ca
  cp ${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/msp/cacerts/* ${PWD}/organizations/peerOrganizations/committee/ca/ca.committee-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/users/User1@committee/msp --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/committee/msp/config.yaml ${PWD}/organizations/peerOrganizations/committee/users/User1@committee/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://committeeadmin:committeeadminpw@localhost:4400 --caname ca-committee -M ${PWD}/organizations/peerOrganizations/committee/users/Admin@committee/msp --tls.certfiles ${PWD}/organizations/fabric-ca/committee/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/committee/msp/config.yaml ${PWD}/organizations/peerOrganizations/committee/users/Admin@committee/msp/config.yaml
}
function createvoter() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/voter/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/voter/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:5500 --caname ca-voter --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-voter.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-voter.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-voter.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-5500-ca-voter.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/voter/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-voter --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-voter --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-voter --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-voter --id.name voteradmin --id.secret voteradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/msp --csr.hosts peer0.voter --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/msp --csr.hosts peer1.voter --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/voter/msp/config.yaml ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/voter/msp/config.yaml ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls --enrollment.profile tls --csr.hosts peer0.voter --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls --enrollment.profile tls --csr.hosts peer1.voter --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/signcerts/* ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/keystore/* ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/signcerts/* ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/keystore/* ${PWD}/organizations/peerOrganizations/voter/peers/peer1.voter/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/voter/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/voter/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/voter/tlsca
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/voter/tlsca/tlsca.voter-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/voter/ca
  cp ${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/msp/cacerts/* ${PWD}/organizations/peerOrganizations/voter/ca/ca.voter-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/users/User1@voter/msp --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/voter/msp/config.yaml ${PWD}/organizations/peerOrganizations/voter/users/User1@voter/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://voteradmin:voteradminpw@localhost:5500 --caname ca-voter -M ${PWD}/organizations/peerOrganizations/voter/users/Admin@voter/msp --tls.certfiles ${PWD}/organizations/fabric-ca/voter/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/voter/msp/config.yaml ${PWD}/organizations/peerOrganizations/voter/users/Admin@voter/msp/config.yaml
}
function createadminops() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/adminops/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/adminops/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:6600 --caname ca-adminops --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-adminops.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-adminops.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-adminops.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6600-ca-adminops.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/adminops/msp/config.yaml

  infoln "Registering peer0"

  fabric-ca-client register --caname ca-adminops --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  infoln "Registering peer1"

  fabric-ca-client register --caname ca-adminops --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  infoln "Registering user"

  fabric-ca-client register --caname ca-adminops --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  infoln "Registering the org admin"

  fabric-ca-client register --caname ca-adminops --id.name adminopsadmin --id.secret adminopsadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  infoln "Generating the peer0 msp"

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/msp --csr.hosts peer0.adminops --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  infoln "Generating the peer1 msp"

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/msp --csr.hosts peer1.adminops --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/adminops/msp/config.yaml ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/msp/config.yaml
  cp ${PWD}/organizations/peerOrganizations/adminops/msp/config.yaml ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls --enrollment.profile tls --csr.hosts peer0.adminops --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem

  infoln "Generating the peer1-tls certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls --enrollment.profile tls --csr.hosts peer1.adminops --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem

  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/signcerts/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/keystore/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/server.key



  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/signcerts/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/keystore/* ${PWD}/organizations/peerOrganizations/adminops/peers/peer1.adminops/tls/server.key



  mkdir -p ${PWD}/organizations/peerOrganizations/adminops/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/adminops/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/adminops/tlsca
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/adminops/tlsca/tlsca.adminops-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/adminops/ca
  cp ${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/msp/cacerts/* ${PWD}/organizations/peerOrganizations/adminops/ca/ca.adminops-cert.pem

  infoln "Generating the user msp"

  fabric-ca-client enroll -u https://user1:user1pw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/users/User1@adminops/msp --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/adminops/msp/config.yaml ${PWD}/organizations/peerOrganizations/adminops/users/User1@adminops/msp/config.yaml

  infoln "Generating the org admin msp"

  fabric-ca-client enroll -u https://adminopsadmin:adminopsadminpw@localhost:6600 --caname ca-adminops -M ${PWD}/organizations/peerOrganizations/adminops/users/Admin@adminops/msp --tls.certfiles ${PWD}/organizations/fabric-ca/adminops/tls-cert.pem


  cp ${PWD}/organizations/peerOrganizations/adminops/msp/config.yaml ${PWD}/organizations/peerOrganizations/adminops/users/Admin@adminops/msp/config.yaml
}

function createorderer1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/orderer1

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/orderer1


  fabric-ca-client enroll -u https://admin:adminpw@localhost:2200 --caname ca-orderer1 --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2200-ca-orderer1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml

  infoln "Registering orderer"

  fabric-ca-client register --caname ca-orderer1 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  infoln "Registering the orderer admin"

  fabric-ca-client register --caname ca-orderer1 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  infoln "Generating the orderer msp"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp --csr.hosts orderer1 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/config.yaml

  infoln "Generating the orderer-tls certificates"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls --enrollment.profile tls --csr.hosts orderer1 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/keystore/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/msp/tlscacerts/tlsca-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer1/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer1/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer1/msp/tlscacerts/tlsca-cert.pem

  infoln "Generating the admin msp"

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:2200 --caname ca-orderer1 -M ${PWD}/organizations/ordererOrganizations/orderer1/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer1/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer1/users/Admin@example.com/msp/config.yaml
}
function createorderer2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/orderer2

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/orderer2


  fabric-ca-client enroll -u https://admin:adminpw@localhost:2201 --caname ca-orderer2 --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2201-ca-orderer2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2201-ca-orderer2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2201-ca-orderer2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2201-ca-orderer2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/orderer2/msp/config.yaml

  infoln "Registering orderer"

  fabric-ca-client register --caname ca-orderer2 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  infoln "Registering the orderer admin"

  fabric-ca-client register --caname ca-orderer2 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  infoln "Generating the orderer msp"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2201 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/msp --csr.hosts orderer2 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer2/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/msp/config.yaml

  infoln "Generating the orderer-tls certificates"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2201 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls --enrollment.profile tls --csr.hosts orderer2 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/keystore/* ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/msp/tlscacerts/tlsca-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer2/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer2/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer2/msp/tlscacerts/tlsca-cert.pem

  infoln "Generating the admin msp"

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:2201 --caname ca-orderer2 -M ${PWD}/organizations/ordererOrganizations/orderer2/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer2/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer2/users/Admin@example.com/msp/config.yaml
}
function createorderer3() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/orderer3

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/orderer3


  fabric-ca-client enroll -u https://admin:adminpw@localhost:2202 --caname ca-orderer3 --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2202-ca-orderer3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2202-ca-orderer3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2202-ca-orderer3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2202-ca-orderer3.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/orderer3/msp/config.yaml

  infoln "Registering orderer"

  fabric-ca-client register --caname ca-orderer3 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  infoln "Registering the orderer admin"

  fabric-ca-client register --caname ca-orderer3 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  infoln "Generating the orderer msp"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2202 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/msp --csr.hosts orderer3 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer3/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/msp/config.yaml

  infoln "Generating the orderer-tls certificates"

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:2202 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls --enrollment.profile tls --csr.hosts orderer3 --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/keystore/* ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/msp/tlscacerts/tlsca-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/orderer3/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/orderer3/config.orderers/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/orderer3/msp/tlscacerts/tlsca-cert.pem

  infoln "Generating the admin msp"

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:2202 --caname ca-orderer3 -M ${PWD}/organizations/ordererOrganizations/orderer3/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem


  cp ${PWD}/organizations/ordererOrganizations/orderer3/msp/config.yaml ${PWD}/organizations/ordererOrganizations/orderer3/users/Admin@example.com/msp/config.yaml
}



