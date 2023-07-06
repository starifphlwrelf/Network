
# bring down the current network
./network.sh down

# Pull the images
./bootstrap.sh 2.4.9 1.5.6

# bring up the network
./network.sh up -ca -s couchdb

# create the votechannel
./network.sh createChannel -c votechannel -p DefaultChannel

# package and install 'votechannel' chaincode on all org nodes
./network.sh deployCC -ccn evoteContract -ccp ../../chaincode -ccl go -ccsd true

# deploy chaincode evoteContract on votechannel

# Uncomment if chaincode initialization required
# ./network.sh deployCC -c defaultchannel -ccn evoteContract -ccp ../../chaincode -ccl go -cci Init -ccsp true
./network.sh deployCC -c votechannel -ccn evoteContract -ccp ../../chaincode -ccl go -ccsp true


