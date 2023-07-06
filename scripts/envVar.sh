#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true

export ORDERER1_CA=${PWD}/organizations/ordererOrganizations/orderer1/msp/tlscacerts/tlsca-cert.pem
export ORDERER2_CA=${PWD}/organizations/ordererOrganizations/orderer2/msp/tlscacerts/tlsca-cert.pem
export ORDERER3_CA=${PWD}/organizations/ordererOrganizations/orderer3/msp/tlscacerts/tlsca-cert.pem
export PEER0_COMMITTEE_CA=${PWD}/organizations/peerOrganizations/committee/peers/peer0.committee/tls/ca.crt
export PEER0_VOTER_CA=${PWD}/organizations/peerOrganizations/voter/peers/peer0.voter/tls/ca.crt
export PEER0_ADMINOPS_CA=${PWD}/organizations/peerOrganizations/adminops/peers/peer0.adminops/tls/ca.crt


# Set environment variables for the peer org
setGlobals() {
  PEER=$1
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$2
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ "$USING_ORG" == "committee" ]; then
    export CORE_PEER_LOCALMSPID="committeemsp"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COMMITTEE_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/committee/users/Admin@committee/msp
    # export CORE_PEER_ADDRESS=localhost:4444
    if [ $PEER -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:4444
    elif [ $PEER -eq 1 ]; then
      export CORE_PEER_ADDRESS=localhost:4454
    fi
  elif [ "$USING_ORG" == "voter" ]; then
    export CORE_PEER_LOCALMSPID="votermsp"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_VOTER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/voter/users/Admin@voter/msp
    # export CORE_PEER_ADDRESS=localhost:5555
    if [ $PEER -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:5555
    elif [ $PEER -eq 1 ]; then
      export CORE_PEER_ADDRESS=localhost:5565
    fi
  elif [ "$USING_ORG" == "adminops" ]; then
    export CORE_PEER_LOCALMSPID="adminopsmsp"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ADMINOPS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/adminops/users/Admin@adminops/msp
    # export CORE_PEER_ADDRESS=localhost:6666
    if [ $PEER -eq 0 ]; then
      export CORE_PEER_ADDRESS=localhost:6666
    elif [ $PEER -eq 1 ]; then
      export CORE_PEER_ADDRESS=localhost:6676
    fi
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals 0 $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ "$USING_ORG" == "committee" ]; then
    export CORE_PEER_ADDRESS=peer0.committee:4444
  elif [ "$USING_ORG" == "voter" ]; then
    export CORE_PEER_ADDRESS=peer0.voter:5555
  elif [ "$USING_ORG" == "adminops" ]; then
    export CORE_PEER_ADDRESS=peer0.voter:6666
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  echo $1
  while [ "$#" -gt 0 ]; do
    setGlobals 0 $1
    PEER="peer0.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$(echo $1 | tr 'a-z' 'A-Z')_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

